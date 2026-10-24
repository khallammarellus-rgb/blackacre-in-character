-- In Character: Survival - Zone Climate

Blackacre = Blackacre or {}
Blackacre.ZoneClimate = {}

local DEFAULT = {
    label = "temperate",
    title = nil,
    article = "a",
    hunger = 1,
    thirst = 1,
    exposure = 1,
}

local ARID = {
    label = "arid",
    title = "Arid",
    article = "an",
    hunger = 1,
    thirst = 2,
    exposure = 2,
}

local TUNDRA = {
    label = "tundra",
    title = "Tundra",
    article = "a",
    hunger = 1,
    thirst = 1,
    exposure = 5,
}

local TROPIC = {
    label = "tropic",
    title = "Tropic",
    article = "a",
    hunger = 1,
    thirst = 3,
    exposure = 1,
}

local TAINTED = {
    label = "tainted",
    title = "Tainted",
    article = "a",
    hunger = 2,
    thirst = 1,
    exposure = 1,
}

-- Retail + classic-era uiMapIDs for the listed zones.
local BY_MAP = {
    -- Arid
    [1] = ARID, [1411] = ARID, -- Durotar
    [10] = ARID, [199] = ARID, [1413] = ARID, -- Barrens
    [15] = ARID, [1415] = ARID, -- Badlands
    [17] = ARID, [1419] = ARID, -- Blasted Lands
    [32] = ARID, [1427] = ARID, -- Searing Gorge
    [36] = ARID, [1428] = ARID, -- Burning Steppes
    [52] = ARID, [1436] = ARID, -- Westfall
    [64] = ARID, [1441] = ARID, -- Thousand Needles
    [66] = ARID, [1443] = ARID, -- Desolace
    [71] = ARID, [1446] = ARID, -- Tanaris
    [81] = ARID, [1379] = ARID, [1451] = ARID, -- Silithus
    -- Tundra
    [91] = TUNDRA, -- Alterac Valley
    [83] = TUNDRA, [1452] = TUNDRA, -- Winterspring
    [27] = TUNDRA, [29] = TUNDRA, [30] = TUNDRA, [427] = TUNDRA, [1426] = TUNDRA, -- Dun Morogh / Coldridge
    -- Tropic
    [51] = TROPIC, [1435] = TROPIC, -- Swamp of Sorrows
    [56] = TROPIC, [1437] = TROPIC, -- Wetlands
    [50] = TROPIC, [210] = TROPIC, [224] = TROPIC, [1434] = TROPIC, -- Stranglethorn
    [69] = TROPIC, [1444] = TROPIC, -- Feralas
    [70] = TROPIC, [1445] = TROPIC, -- Dustwallow Marsh
    [78] = TROPIC, [1449] = TROPIC, -- Un'goro Crater
    -- Tainted
    [22] = TAINTED, [1422] = TAINTED, -- Western Plaguelands
    [23] = TAINTED, [1423] = TAINTED, -- Eastern Plaguelands
    [42] = TAINTED, [1430] = TAINTED, -- Deadwind Pass
    [77] = TAINTED, [1448] = TAINTED, -- Felwood

    -- Retail's later lands (added 2026-10-09). Each climate follows the
    -- zone's description on warcraft.wiki.gg (quoted in short below); map
    -- ids are from the wiki's UiMapID list and, for The War Within and
    -- Midnight, the live 12.1 UiMap table on wago.tools. A zone not listed
    -- takes its continent's climate (the lookup walks up the parent maps),
    -- or temperate. Temperate zones are listed only where their continent
    -- has another climate. Zones with two faces (Gorgrond: desert and
    -- jungle; the Waking Shores: lava and green) stay temperate.
    [95] = TAINTED, -- Ghostlands: "a haunted, plagued, decrepit, and dangerous area"
    -- Outland
    [100] = ARID, -- Hellfire Peninsula: "a dry, barren wasteland"
    [102] = TROPIC, -- Zangarmarsh: "a large expanse of swampland"
    [104] = TAINTED, -- Shadowmoon Valley: "a tortured landscape boiling with the fury of fel"
    [105] = ARID, -- Blade's Edge Mountains: "barren plateaus", "harsh winds"
    [109] = TAINTED, -- Netherstorm: soil "that supports absolutely no plant life"
    -- Northrend: "a frozen wasteland" (Grizzly Hills: "snow is everywhere";
    -- Zul'Drak: "one of the most inhospitable climates on Azeroth")
    [113] = TUNDRA,
    [114] = TUNDRA, -- Borean Tundra: "wide, flat, and cold"
    [115] = TUNDRA, -- Dragonblight: "a vast Arctic wasteland"
    [117] = DEFAULT, -- Howling Fjord: green meadows, "a little milder"
    [118] = TUNDRA, -- Icecrown: "dark and inescapably cold"
    [119] = TROPIC, -- Sholazar Basin: "a tropical jungle basin"
    [120] = TUNDRA, -- The Storm Peaks: "stone and ice"
    [123] = TUNDRA, -- Wintergrasp: "a frozen valley"
    [127] = DEFAULT, -- Crystalsong Forest: crystallized forest, not cold
    -- Cataclysm
    [249] = ARID, [1527] = ARID, -- Uldum: "predominately desert"
    -- Pandaria
    [371] = TROPIC, -- The Jade Forest: "a lush rainforest"
    [418] = TROPIC, -- Krasarang Wilds: "thick and heavy with humidity"
    [379] = TUNDRA, -- Kun-Lai Summit: "one of the coldest places in all of Pandaria"
    [422] = TAINTED, -- Dread Wastes: "sha-corrupted soil"
    [554] = TROPIC, -- Timeless Isle: flora "similar to that found in the Jade Forest"
    -- Draenor
    [525] = TUNDRA, -- Frostfire Ridge: "a harsh land of ceaseless winter"
    [534] = TAINTED, -- Tanaan Jungle: jungle "corrupted when Gul'dan unleashed the Felblight"
    -- Broken Isles and Argus
    [641] = TAINTED, [1188] = TAINTED, -- Val'sharah: "a nightmare is spreading unchecked"
    [646] = TAINTED, [1192] = TAINTED, -- Broken Shore: "rivers of fel magic"
    [830] = TAINTED, -- Krokuun: "fel tainted groves", "black soil, devoid of life"
    [885] = TAINTED, -- Antoran Wastes: "fully consumed by the fel"
    -- Zandalar
    [862] = TROPIC, [1193] = TROPIC, -- Zuldazar: "lush, tropical environments"
    [863] = TROPIC, [1194] = TROPIC, -- Nazmir: "a fetid swamp"
    [864] = ARID, [1195] = ARID, -- Vol'dun: "dunes of sand, salt flats"
    -- Shadowlands
    [1543] = TAINTED, [1960] = TAINTED, -- The Maw: "Wasteland of the Damned"
    [1970] = ARID, -- Zereth Mortis: "a dry desert biome"
    -- Dragon Isles
    [2024] = TUNDRA, -- The Azure Span: "defined by its arctic climate"
    [2133] = ARID, -- Zaralek Cavern: "the temperature within the cavern rise[s] significantly"
    -- Khaz Algar
    [2371] = ARID, -- K'aresh: "an arid planet"
    -- Quel'Thalas (Midnight)
    [2413] = TROPIC, -- Harandar: "a bioluminscent primordial jungle"
    [2405] = TAINTED, -- Voidstorm: "a world shaped by the Void"
    [2424] = TAINTED, [2432] = TAINTED, [2565] = TAINTED, -- Isle of Quel'Danas: the Darkwell's "corruption lingered"
}

-- Longer / more specific needles first.
local NAME_HINTS = {
    { match = "dun morogh", profile = TUNDRA },
    { match = "coldridge", profile = TUNDRA },
    { match = "alterac valley", profile = TUNDRA },
    { match = "winterspring", profile = TUNDRA },
    { match = "searing gorge", profile = ARID },
    { match = "burning steppes", profile = ARID },
    { match = "blasted lands", profile = ARID },
    { match = "thousand needles", profile = ARID },
    { match = "eastern plaguelands", profile = TAINTED },
    { match = "western plaguelands", profile = TAINTED },
    { match = "deadwind pass", profile = TAINTED },
    { match = "swamp of sorrows", profile = TROPIC },
    { match = "stranglethorn", profile = TROPIC },
    { match = "un'goro", profile = TROPIC },
    { match = "ungoro", profile = TROPIC },
    { match = "dustwallow", profile = TROPIC },
    { match = "wetlands", profile = TROPIC },
    { match = "feralas", profile = TROPIC },
    { match = "felwood", profile = TAINTED },
    { match = "plaguelands", profile = TAINTED },
    { match = "badlands", profile = ARID },
    { match = "westfall", profile = ARID },
    { match = "barrens", profile = ARID },
    { match = "desolace", profile = ARID },
    { match = "silithus", profile = ARID },
    { match = "tanaris", profile = ARID },
    { match = "durotar", profile = ARID },
}

local function Copy(p)
    return {
        label = p.label,
        title = p.title,
        article = p.article,
        hunger = p.hunger,
        thirst = p.thirst,
        exposure = p.exposure,
    }
end

local function MatchName(name)
    if not name or name == "" then return nil end
    local lower = name:lower()
    for i = 1, #NAME_HINTS do
        if lower:find(NAME_HINTS[i].match, 1, true) then
            return NAME_HINTS[i].profile
        end
    end
    return nil
end

-- Parent-map walks call GetMapInfo several times. One copy per map (or zone name) per session.
local profileCache = {}

function Blackacre.ZoneClimate.GetProfile(mapId, zoneName, zoneText)
    local key = (mapId and mapId ~= 0) and mapId or (zoneName or "")
    local hit = profileCache[key]
    if hit then
        return hit
    end

    local found
    local id = mapId
    if id and C_Map and C_Map.GetMapInfo then
        for _ = 1, 8 do
            if id and BY_MAP[id] then
                found = BY_MAP[id]
                break
            end
            local info = C_Map.GetMapInfo(id or 0)
            if not info or not info.parentMapID or info.parentMapID == 0 then
                break
            end
            id = info.parentMapID
        end
    elseif mapId and BY_MAP[mapId] then
        found = BY_MAP[mapId]
    end
    if not found then
        found = MatchName(zoneName) or MatchName(zoneText) or MatchName(GetZoneText and GetZoneText() or "") or DEFAULT
    end
    local copy = Copy(found)
    profileCache[key] = copy
    return copy
end

function Blackacre.ZoneClimate.EnterMessage(profile)
    if not profile or not profile.title then return nil end
    local art = profile.article or "a"
    return string.format("You have entered %s %s region", art, profile.title)
end
