-- In Character: Journal - Page Capture

Blackacre = Blackacre or {}
Blackacre.Chronicle = Blackacre.Chronicle or {}
Blackacre.Chronicle.Capture = {}

local time, pcall, tostring, pairs, type = time, pcall, tostring, pairs, type
local floor = math.floor
local C_Timer, C_Reputation, C_GossipInfo = C_Timer, C_Reputation, C_GossipInfo
local C_MajorFactions, C_ProfSpecs, C_TradeSkillUI = C_MajorFactions, C_ProfSpecs, C_TradeSkillUI

local lastTitleIndex = nil
local titleReady = false
local suppressToasts = false
local repScanPending = false

local STANDING_NAME = {
    [4] = "Friendly",
    [5] = "Honored",
    [6] = "Revered",
    [7] = "Exalted",
}

local function Toast(msg, kit)
    if suppressToasts then return end
    local quiet = Blackacre.CharDB.settings and Blackacre.CharDB.settings.quietNotifications
    if quiet then return end
    Blackacre.UI.Theme.Toast(msg, kit)
end

local function StoryDB()
    Blackacre.CharDB.chronicleStory = Blackacre.CharDB.chronicleStory or {
        chains = {},
        repStanding = {},
    }
    return Blackacre.CharDB.chronicleStory
end

--- Store a finished entry, announce it, and open the book to it.
local function Publish(entry)
    Blackacre.Chronicle.Store.Add(entry)
    Toast("Journal updated: " .. (entry.title or entry.kind), "journal")
    if Blackacre.Chronicle.UI and Blackacre.Chronicle.UI.OnNewEntry then
        Blackacre.Chronicle.UI.OnNewEntry(entry)
    end
    return entry
end

local function MakeEntry(kind, facts, source)
    facts = facts or {}
    local context = Blackacre.Chronicle.Hooks.GetContext()
    facts.zoneName = facts.zoneName or context.zone
    local title, body = Blackacre.Chronicle.Hooks.Resolve(kind, facts, context)
    local zone = Blackacre.GetZoneContext()
    local now = time()
    return Publish({
        kind = kind,
        source = source or "auto",
        facts = facts,
        context = context,
        title = title,
        body = body,
        zoneId = zone.zoneId,
        zoneName = zone.zoneName,
        yearKC = context.yearKC,
        createdAt = now,
        editedAt = now,
        pinned = false,
        tags = {},
        editable = true,
    })
end

function Blackacre.Chronicle.Capture.AddEntry(kind, facts, source)
    return MakeEntry(kind, facts, source or "auto")
end

--- Add an entry another module built in full (e.g. a logged quest page
--- with its own storyAt), with the same toast and book jump as any page.
function Blackacre.Chronicle.Capture.AddPreparedEntry(entry)
    return Publish(entry)
end

-- A fresh page gets a starting title and opening line from the in-game hour
-- and where the player stands, instead of "Untitled". Weather is not used:
-- Retail has no weather API (C_Weather is not in the 12.1 client).
local TOD_PHRASE = {
    Night = "tonight", Dawn = "at dawn", Morning = "this morning",
    Midday = "at midday", Afternoon = "this afternoon", Evening = "this evening",
}

local function TimeOfDayWord()
    local h = GetGameTime and GetGameTime()
    if not h then return nil end
    if h < 5 then return "Night" end
    if h < 8 then return "Dawn" end
    if h < 12 then return "Morning" end
    if h < 14 then return "Midday" end
    if h < 18 then return "Afternoon" end
    if h < 21 then return "Evening" end
    return "Night"
end

local MONTH_NAMES = {
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December",
}
Blackacre.Chronicle.Capture.MONTH_NAMES = MONTH_NAMES

local function Ordinal(n)
    local tens = n % 100
    if tens >= 11 and tens <= 13 then return n .. "th" end
    local last = n % 10
    if last == 1 then return n .. "st" end
    if last == 2 then return n .. "nd" end
    if last == 3 then return n .. "rd" end
    return n .. "th"
end
Blackacre.Chronicle.Capture.Ordinal = Ordinal

-- Server calendar date (same day the in-game calendar shows); local clock
-- as fallback. Returns day number and month name, or nil.
local function CurrentDayMonth()
    local d = C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime
        and C_DateAndTime.GetCurrentCalendarTime()
    local day, month = d and d.monthDay, d and d.month
    if not (day and month) then
        local t = date("*t")
        day, month = t.day, t.month
    end
    local name = month and MONTH_NAMES[month]
    if not (day and name) then return nil end
    return day, name
end

--- `yearADP` (optional): the year the page is set in; nil = the character's present year.
local function DefaultManualPage(yearADP)
    local zone = Blackacre.GetZoneContext()
    local zoneName = zone.zoneName ~= "" and zone.zoneName or nil
    local sub = zone.subzone ~= "" and zone.subzone ~= zoneName and zone.subzone or nil
    local tod = TimeOfDayWord()
    local day, month = CurrentDayMonth()

    -- Title: "Evening of 26 September in Elwynn Forest"
    local title = tod or "A page"
    if day then title = title .. " of " .. day .. " " .. month end
    if zoneName then title = title .. " in " .. zoneName end
    if not tod and not day and not zoneName then title = "A new page" end

    -- Opening line, first person (journal pages are always in character):
    -- "I set these words down this evening, the 26th of September, in
    --  Goldshire, Elwynn Forest, in the year 32 K.C."
    local place = (sub and zoneName) and (sub .. ", " .. zoneName) or zoneName or sub
    local year = Blackacre.UI.Theme.FormatFactionYear(yearADP or Blackacre.YearCalendar.GetPresentADP())
    local line = "I set these words down"
    if tod then line = line .. " " .. TOD_PHRASE[tod] end
    if day then line = line .. ", the " .. Ordinal(day) .. " of " .. month end
    if place then line = line .. (day and ", in " or " in ") .. place end
    if year and year ~= "?" then line = line .. ", in the year " .. year end
    return title, line .. ".\n\n"
end

--- A blank page written now. `storyAt` (optional) places it earlier in the
--- book's chronology, e.g. right after the page the player is reading.
--- `yearKC` (optional, an ADP year despite the field's name) is the year the page is set
--- in, for writing up past events; nil = the present year.
function Blackacre.Chronicle.Capture.AddManual(title, body, kind, storyAt, yearKC)
    kind = kind or "MANUAL"
    if title == nil and body == nil and kind == "MANUAL" then
        title, body = DefaultManualPage(yearKC)
    end
    local facts = { manualTitle = title, manualBody = body, title = title, body = body }
    if not storyAt and not yearKC then
        return MakeEntry(kind, facts, "manual")
    end
    local context = Blackacre.Chronicle.Hooks.GetContext()
    local zone = Blackacre.GetZoneContext()
    local now = time()
    return Publish({
        kind = kind,
        source = "manual",
        facts = facts,
        context = context,
        title = title,
        body = body,
        zoneId = zone.zoneId,
        zoneName = zone.zoneName,
        yearKC = yearKC or context.yearKC,
        createdAt = now,
        storyAt = storyAt,
        editedAt = now,
        pinned = false,
        tags = {},
        editable = true,
    })
end

---------------------------------------------------------------------------
-- Quest finales (called by the Quest Index when a quest is turned in)
---------------------------------------------------------------------------

local function IsMetaQuest(questID)
    if C_QuestLog and C_QuestLog.IsMetaQuest then
        local ok, v = pcall(C_QuestLog.IsMetaQuest, questID)
        if ok and v then return true end
    end
    local E = Enum and Enum.QuestClassification
    if E and C_QuestInfoSystem and C_QuestInfoSystem.GetQuestClassification then
        local ok, c = pcall(C_QuestInfoSystem.GetQuestClassification, questID)
        if ok and c == E.Meta then return true end
    end
    return false
end

local function SceneBits(snapshot)
    if not snapshot then return nil end
    local title, body = Blackacre.Chronicle.Prompt.Build(snapshot)
    local opening = body and body:match("^(.-)\n") or nil
    local npc = snapshot.giverName and ("I spoke with " .. snapshot.giverName .. ".") or nil
    return { opening = opening, npc = npc, title = title, body = body }
end

--- Meta quests and chain finales earn their own page automatically (they are
--- meta-tier). Returns true when a page was written, so the caller does not
--- also write an ordinary quest page.
function Blackacre.Chronicle.Capture.OnQuestTurnedIn(questID, questName, snapshot)
    local zoneName = snapshot and (snapshot.subzone ~= "" and snapshot.subzone or snapshot.zone) or nil

    if IsMetaQuest(questID) then
        local title, body = Blackacre.Chronicle.Prompt.Build(snapshot)
        MakeEntry("META_QUEST", {
            questId = questID,
            questName = questName,
            zoneName = zoneName,
            title = title,
            promptTitle = title,
            promptBody = body,
        })
        return true
    end

    Blackacre.QuestLines.RememberBeat(questID, questName, zoneName, SceneBits(snapshot))
    local isFinale, _, lineId = Blackacre.QuestLines.IsFinale(questID)
    if not isFinale and lineId and C_QuestLine and C_QuestLine.IsComplete then
        local ok, done = pcall(C_QuestLine.IsComplete, lineId)
        isFinale = ok and done
    end
    if not isFinale then return false end

    local title, body, meta = Blackacre.QuestLines.BuildOnePager(lineId, questName, zoneName, snapshot)
    MakeEntry("QUESTLINE", {
        questId = questID,
        zoneName = zoneName,
        title = title,
        promptTitle = title,
        promptBody = body,
        lineId = meta and meta.lineId or lineId,
        lineName = meta and meta.lineName,
    })
    return true
end

---------------------------------------------------------------------------
-- Achievements, titles, standings, professions
---------------------------------------------------------------------------

local function IsMetaAchievement(achievementID)
    local n = GetAchievementNumCriteria(achievementID) or 0
    if n < 2 then return false end
    local hits = 0
    for i = 1, n do
        local ok, _, criteriaType = pcall(GetAchievementCriteriaInfo, achievementID, i)
        if ok and (criteriaType == 8 or criteriaType == 36) then
            hits = hits + 1
        end
    end
    return hits >= 2
end

local function IsFeatOfStrength(achievementID)
    if AchievementUtil and AchievementUtil.IsFeatOfStrength then
        local ok, v = pcall(AchievementUtil.IsFeatOfStrength, achievementID)
        if ok and v then return true end
    end
    return false
end

local function OnAchievement(achievementID)
    if not achievementID then return end
    local _, name, _, _, _, _, _, description = GetAchievementInfo(achievementID)
    name = name or ("Achievement #" .. tostring(achievementID))
    local kind = "ACHIEVEMENT"
    if IsFeatOfStrength(achievementID) then
        kind = "FOS"
    elseif IsMetaAchievement(achievementID) then
        kind = "META_ACHIEVEMENT"
    end
    MakeEntry(kind, {
        achievementId = achievementID,
        achievementName = name,
        achievementDetail = description or "",
        name = name,
    })
end

local function CheckTitleChange()
    if not titleReady then return end
    local idx = GetCurrentTitle()
    if idx and idx > 0 and idx ~= lastTitleIndex then
        local titleName = GetTitleName(idx)
        if titleName and titleName ~= "" then
            titleName = titleName:gsub("%s+$", "")
            MakeEntry("TITLE", { titleIndex = idx, titleName = titleName, name = titleName })
        end
    end
    if idx then lastTitleIndex = idx end
end

---------------------------------------------------------------------------
-- Standings: reputations, friendships, renown
---------------------------------------------------------------------------
-- Retail has three kinds of standing, and each gets its own pages:
--   * ordinary factions: a page at Friendly, Honored, Revered and Exalted
--     (the reaction tiers 4-7);
--   * friendships (Ve'nari, the Tillers, Brann...): named ranks from
--     C_GossipInfo.GetFriendshipReputation / GetFriendshipReputationRanks.
--     Their reaction tier never moves. A short ladder (8 ranks or fewer)
--     writes a page at every rank past the first; a long one (Brann's
--     levels) at each quarter of its top rank;
--   * major factions (Renown): a page at each quarter of the top renown
--     level, from MAJOR_FACTION_RENOWN_LEVEL_CHANGED. Their reaction tier
--     never moves either, so the faction scan skips them.
-- Each faction's last step is remembered, so nothing repeats. What the
-- login scan finds (an account-wide reputation another character raised,
-- or gains while the add-on was off) is only remembered, never written:
-- a page is something this character lived through.

local FRIEND_SHORT_LADDER = 8
local FACTION_PLAIN, FACTION_FRIEND, FACTION_MAJOR = 1, 2, 3
-- A faction's kind never changes; ask the game once per session.
local factionKind = {}

local function KindOfFaction(factionID)
    local kind = factionKind[factionID]
    if kind then return kind end
    kind = FACTION_PLAIN
    if C_Reputation.IsMajorFaction(factionID) then
        kind = FACTION_MAJOR
    else
        local friend = C_GossipInfo.GetFriendshipReputation(factionID)
        if friend and friend.friendshipFactionID and friend.friendshipFactionID > 0 then
            kind = FACTION_FRIEND
        end
    end
    factionKind[factionID] = kind
    return kind
end

local function CheckFriendship(db, factionID, fallbackName, silent)
    local ranks = C_GossipInfo.GetFriendshipReputationRanks(factionID)
    local level, maxLevel = ranks and ranks.currentLevel, ranks and ranks.maxLevel
    if not (level and maxLevel and maxLevel > 1) then return end
    local long = maxLevel > FRIEND_SHORT_LADDER
    local step = level
    if long then
        step = floor(4 * level / maxLevel)
        if step > 4 then step = 4 end
    end
    db.friendStep = db.friendStep or {}
    local prev = db.friendStep[factionID]
    if prev and step <= prev then return end
    db.friendStep[factionID] = step
    if silent or not prev or (not long and level < 2) or (long and step < 1) then return end
    local friend = C_GossipInfo.GetFriendshipReputation(factionID)
    local name = (friend and friend.name) or fallbackName or ("Faction #" .. tostring(factionID))
    local rankName = friend and friend.reaction
    MakeEntry("FRIENDSHIP", {
        factionId = factionID,
        factionName = name,
        name = name,
        standingName = rankName,
        -- A short ladder's ranks have real names ("Cordial"); a long one's are
        -- often just levels, so only the short ladder names its rank.
        title = (not long and rankName and rankName ~= "") and (name .. ": " .. rankName) or nil,
        rank = level,
        maxRank = maxLevel,
        variant = (level >= maxLevel) and "closest" or (long and "closer" or "rank"),
    })
end

local function CheckFaction(factionID, data, silent)
    if not factionID then return end
    local kind = KindOfFaction(factionID)
    if kind == FACTION_MAJOR then return end
    local db = StoryDB()
    if kind == FACTION_FRIEND then
        CheckFriendship(db, factionID, data and data.name, silent)
        return
    end
    data = data or C_Reputation.GetFactionDataByID(factionID)
    local standingId = data and data.reaction
    if not standingId then return end
    db.repStanding = db.repStanding or {}
    local prev = db.repStanding[factionID]
    db.repStanding[factionID] = standingId
    local label = STANDING_NAME[standingId]
    if not silent and label and prev and standingId > prev then
        MakeEntry("REPUTATION", {
            factionId = factionID,
            factionName = data.name or ("Faction #" .. tostring(factionID)),
            standingId = standingId,
            standingName = label,
            name = data.name,
        })
    end
end

-- Every faction the reputation list shows (collapsed headers hide theirs;
-- FACTION_STANDING_CHANGED below covers those by id).
local function ScanReputationBrackets(silent)
    local num = C_Reputation.GetNumFactions()
    if not num or num < 1 then return end
    for i = 1, num do
        local data = C_Reputation.GetFactionDataByIndex(i)
        if type(data) == "table" and not data.isHeader then
            CheckFaction(data.factionID, data, silent)
        end
    end
end

local function OnRenown(majorFactionID, newLevel, oldLevel)
    if not (majorFactionID and newLevel) then return end
    -- Journeys (Delver's Journey and the like) are seasonal tracks, not a people.
    if C_MajorFactions.ShouldDisplayMajorFactionAsJourney(majorFactionID) then return end
    local data = C_MajorFactions.GetMajorFactionData(majorFactionID)
    local maxLevel = data and data.maxLevel
    if not (maxLevel and maxLevel > 0) then return end
    local step = floor(4 * newLevel / maxLevel)
    if step > 4 then step = 4 end
    local db = StoryDB()
    db.renownStep = db.renownStep or {}
    local prev = db.renownStep[majorFactionID] or floor(4 * (oldLevel or 0) / maxLevel)
    if step <= prev then return end
    db.renownStep[majorFactionID] = step
    local isMax = newLevel >= maxLevel or C_MajorFactions.HasMaximumRenown(majorFactionID)
    MakeEntry("RENOWN", {
        factionId = majorFactionID,
        factionName = data.name,
        name = data.name,
        renownLevel = newLevel,
        maxLevel = maxLevel,
        variant = isMax and "max" or "rising",
    })
end

---------------------------------------------------------------------------
-- Professions
---------------------------------------------------------------------------
-- Skill. Retail has no trainer ranks: each expansion has its own skill line
-- ("Khaz Algar Tailoring", 1-100), and GetProfessionInfo reports the newest
-- one the character has learned (its 11th return is that line's name, as
-- Blizzard_ProfessionsBook reads it). A quarter, half, three quarters and
-- all of the line's cap each earn one page, worded with the trade's plain
-- name so no expansion name reaches the page. Only the highest step is
-- remembered per skill line, so a jump past a threshold still counts and
-- nothing repeats. Retail has no weapon skills.
local PROFESSION_STEPS = { "apprentice", "journeyman", "expert", "artisan" }
local professionSlots = {}

local function NoteProfessions(writeEntry)
    local db = StoryDB()
    db.professionStep = db.professionStep or {}
    -- GetProfessions returns up to seven indices with nil gaps (an empty
    -- primary slot), so walk all seven instead of stopping at the first gap.
    local s = professionSlots
    s[1], s[2], s[3], s[4], s[5], s[6], s[7] = GetProfessions()
    for slot = 1, 7 do
        local idx = s[slot]
        if idx then
            local name, _, rank, maxRank, _, _, _, _, _, _, lineName = GetProfessionInfo(idx)
            if name and rank and maxRank and maxRank > 1 then
                local step = floor(4 * rank / maxRank)
                if step > 4 then step = 4 end
                local key = lineName or name
                if step > 0 and (db.professionStep[key] or 0) < step then
                    db.professionStep[key] = step
                    if writeEntry then
                        MakeEntry("PROFESSION", { skillName = name, skillRank = rank, echelon = PROFESSION_STEPS[step] })
                    end
                end
            end
        end
    end
end

-- Specializations (Dragonflight onward): knowledge points spent in a skill
-- line's specialization trees (C_ProfSpecs). Three moments per line, each
-- written once: the trees open (SKILL_LINE_SPECS_UNLOCKED), the character
-- commits to a tree (its tab becomes Unlocked), and a tree is finished
-- (every path in it Completed). The game has no list of a character's spec
-- lines outside the professions window, so lines are learned from the
-- unlock event and from the window's open line, kept in
-- chronicleStory.specLines, and each line is first scanned silently.
local SPEC_TAB_UNLOCKED = (Enum.ProfessionsSpecTabState and Enum.ProfessionsSpecTabState.Unlocked) or 1
local SPEC_PATH_COMPLETED = (Enum.ProfessionsSpecPathState and Enum.ProfessionsSpecPathState.Completed) or 2
local SPEC_CHOSEN, SPEC_MASTERED = 1, 2

-- The plain trade name ("Tailoring") for a base profession skill line.
local function TradeName(tradeSkillID)
    local s = professionSlots
    s[1], s[2], s[3], s[4], s[5], s[6], s[7] = GetProfessions()
    for slot = 1, 7 do
        local idx = s[slot]
        if idx then
            local name, _, _, _, _, _, skillLine = GetProfessionInfo(idx)
            if skillLine == tradeSkillID then return name end
        end
    end
    local name = tradeSkillID and C_TradeSkillUI.GetTradeSkillDisplayName(tradeSkillID)
    return (name and name ~= "") and name or nil
end

local function PathDone(pathID, configID)
    if C_ProfSpecs.GetStateForPath(pathID, configID) ~= SPEC_PATH_COMPLETED then return false end
    local kids = C_ProfSpecs.GetChildrenForPath(pathID)
    for i = 1, (kids and #kids or 0) do
        if not PathDone(kids[i], configID) then return false end
    end
    return true
end

local function ScanSpecLine(db, lineID, silent)
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(lineID)
    if not configID or configID == 0 then return end
    db.specTab = db.specTab or {}
    local tabs = C_ProfSpecs.GetSpecTabIDsForSkillLine(lineID)
    for i = 1, (tabs and #tabs or 0) do
        local tab = tabs[i]
        local reached = 0
        if C_ProfSpecs.GetStateForTab(tab, configID) == SPEC_TAB_UNLOCKED then
            reached = SPEC_CHOSEN
            local root = C_ProfSpecs.GetRootPathForTab(tab)
            if root and PathDone(root, configID) then reached = SPEC_MASTERED end
        end
        local prev = db.specTab[tab]
        if prev == nil or reached > prev then
            db.specTab[tab] = reached
            if not silent and prev ~= nil and reached > 0 then
                local info = C_ProfSpecs.GetTabInfo(tab)
                local specName = info and info.name
                MakeEntry("PROFESSION", {
                    skillName = db.specLines[lineID],
                    specName = specName,
                    title = (reached == SPEC_MASTERED and "Mastered " or "Chose ") .. (specName or "a specialization"),
                    echelon = reached == SPEC_MASTERED and "specMastered" or "specChosen",
                })
            end
        end
    end
end

-- The line the professions window has open, if it has specializations.
local function LearnOpenSpecLine(db)
    local info = C_TradeSkillUI.GetChildProfessionInfo()
    local lineID = info and info.professionID
    if not lineID or lineID == 0 or db.specLines[lineID] then return end
    if not C_ProfSpecs.SkillLineHasSpecialization(lineID) then return end
    db.specLines[lineID] = info.parentProfessionName or TradeName(info.parentProfessionID) or info.professionName
    ScanSpecLine(db, lineID, true)
end

local function SpecDB()
    local db = StoryDB()
    db.specLines = db.specLines or {}
    db.specOpened = db.specOpened or {}
    return db
end

local function ScanAllSpecLines(silent)
    local db = SpecDB()
    for lineID in pairs(db.specLines) do ScanSpecLine(db, lineID, silent) end
end

local function OnSpecsUnlocked(lineID, tradeSkillID)
    if not lineID then return end
    local db = SpecDB()
    local name = TradeName(tradeSkillID)
    db.specLines[lineID] = db.specLines[lineID] or name or "my craft"
    ScanSpecLine(db, lineID, true)
    if db.specOpened[lineID] then return end
    db.specOpened[lineID] = true
    MakeEntry("PROFESSION", {
        skillName = db.specLines[lineID],
        title = (name or "My craft") .. ": a path opens",
        echelon = "specUnlocked",
    })
end

-- Skill-ups fire SKILL_LINES_CHANGED in bursts; check once per burst. Spec
-- point spending (SKILL_LINE_SPECS_RANKS_CHANGED) is batched the same way.
local skillCheckPending = false
local function ScheduleSkillCheck()
    if skillCheckPending then return end
    skillCheckPending = true
    C_Timer.After(1, function()
        skillCheckPending = false
        NoteProfessions(true)
    end)
end

local specCheckPending = false
local function ScheduleSpecCheck()
    if specCheckPending then return end
    specCheckPending = true
    C_Timer.After(1, function()
        specCheckPending = false
        LearnOpenSpecLine(SpecDB())
        ScanAllSpecLines(false)
    end)
end

local function RunRepScan()
    repScanPending = false
    ScanReputationBrackets(false)
end

function Blackacre.Chronicle.Capture.Init()
    local frame = CreateFrame("Frame")
    local professionReady = false

    frame:RegisterEvent("PLAYER_LOGIN")
    frame:RegisterEvent("SKILL_LINES_CHANGED")
    frame:RegisterEvent("ACHIEVEMENT_EARNED")
    frame:RegisterEvent("KNOWN_TITLES_UPDATE")
    frame:RegisterEvent("UPDATE_FACTION")
    frame:RegisterEvent("FACTION_STANDING_CHANGED")
    frame:RegisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
    frame:RegisterEvent("SKILL_LINE_SPECS_UNLOCKED")
    frame:RegisterEvent("SKILL_LINE_SPECS_RANKS_CHANGED")
    frame:RegisterEvent("TRADE_SKILL_SHOW")
    frame:RegisterEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
    frame:RegisterUnitEvent("UNIT_NAME_UPDATE", "player")
    frame:SetScript("OnEvent", function(_, event, ...)
        if event == "PLAYER_LOGIN" then
            lastTitleIndex = GetCurrentTitle()
            titleReady = true
            C_Timer.After(3, function() ScanReputationBrackets(true) end)
            C_Timer.After(4, function()
                -- Remember where skills already stand, silently.
                NoteProfessions(false)
                ScanAllSpecLines(true)
                professionReady = true
            end)
        elseif event == "SKILL_LINES_CHANGED" then
            if professionReady then ScheduleSkillCheck() end
        elseif event == "ACHIEVEMENT_EARNED" then
            OnAchievement(...)
        elseif event == "KNOWN_TITLES_UPDATE" or event == "UNIT_NAME_UPDATE" then
            CheckTitleChange()
        elseif event == "UPDATE_FACTION" then
            -- Fires on every reputation gain (each kill while grinding). Scan
            -- once, 2 s after a burst starts; dropping the event instead could
            -- miss a tier crossing that was the last gain of a burst.
            if repScanPending then return end
            repScanPending = true
            C_Timer.After(2, RunRepScan)
        elseif event == "FACTION_STANDING_CHANGED" then
            -- One faction by id, so factions under collapsed headers count too.
            CheckFaction((...), nil, false)
        elseif event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" then
            OnRenown(...)
        elseif event == "SKILL_LINE_SPECS_UNLOCKED" then
            OnSpecsUnlocked(...)
        elseif event == "SKILL_LINE_SPECS_RANKS_CHANGED" then
            if professionReady then ScheduleSpecCheck() end
        elseif event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_DATA_SOURCE_CHANGED" then
            -- The window's open line becomes known (silently) before any
            -- points are spent in it.
            LearnOpenSpecLine(SpecDB())
        end
    end)
end
