-- In Character - Client Compatibility

Blackacre = Blackacre or {}
Blackacre.Compat = {}

local GetBuildInfo, GetRealmName, tonumber, date = GetBuildInfo, GetRealmName, tonumber, date

local cached

local function Detect()
    if cached then return cached end
    local version, _, _, interface = GetBuildInfo()
    cached = {
        version = version or "",
        interface = tonumber(interface) or 0,
    }
    return cached
end

--- Build facts for diagnostics (/ba storage, /ba packages).
function Blackacre.Compat.GetFlavor()
    return Detect()
end

function Blackacre.Compat.FlavorLabel()
    local f = Detect()
    return string.format("Retail (%s / %d)", f.version, f.interface)
end

-- Retail realms are stable, so Blackacre's default profile name is the same
-- "Name - Realm" key AceDB builds itself. A character name alone is never
-- enough on Retail: players reuse names across realms.
function Blackacre.Compat.GetProfileScope()
    local realm = GetRealmName and GetRealmName()
    if type(realm) == "string" and realm ~= "" then return realm end
    return "Realm"
end

-- The story's present year follows the real calendar (owner rule): 2026 is
-- 42 ADP (634 K.C.), and each 1 January moves it on one, so 2027 is 43 ADP
-- (635 K.C.). The realm's calendar decides the date, the same one journal
-- stamps use for month and day; the computer clock is the fallback.
local PRESENT_BASE_ADP, PRESENT_BASE_YEAR = 42, 2026

--- The present year in ADP, from today's date.
function Blackacre.Compat.PresentADP()
    local t = C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime and C_DateAndTime.GetCurrentCalendarTime()
    local year = t and t.year or tonumber(date("%Y"))
    return PRESENT_BASE_ADP + ((year or PRESENT_BASE_YEAR) - PRESENT_BASE_YEAR)
end
