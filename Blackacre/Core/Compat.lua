-- In Character - Client Compatibility

Blackacre = Blackacre or {}
Blackacre.Compat = {}

local GetBuildInfo, GetRealmName, tonumber = GetBuildInfo, GetRealmName, tonumber

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

--- Present year: The War Within and after, 42 years after the Dark Portal
--- (the value the Retail build used before the Forever split).
Blackacre.Compat.PRESENT_ADP = 42
