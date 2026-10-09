-- In Character: Journal - Age Bands

Blackacre = Blackacre or {}

Blackacre.LongevityProfiles = {
    mortal = {
        label = "Mortal span",
        bands = {
            { id = "child", maxAge = 12, text = "still a child of the hearth" },
            { id = "youth", maxAge = 17, text = "youth on the edge of the road" },
            { id = "young_adult", maxAge = 25, text = "young adult, newly blooded by the world" },
            { id = "adult", maxAge = 40, text = "in the prime of mortal years" },
            { id = "veteran", maxAge = 60, text = "veteran of hard seasons" },
            { id = "elder", maxAge = 99999, text = "elder among short-lived peoples" },
        },
    },
    long_lived = {
        label = "Long-lived",
        bands = {
            { id = "child", maxAge = 40, text = "still young by their people's reckoning" },
            { id = "youth", maxAge = 80, text = "coming into long adulthood" },
            { id = "young_adult", maxAge = 200, text = "a younger adult of centuries" },
            { id = "adult", maxAge = 500, text = "settled into long adulthood" },
            { id = "veteran", maxAge = 1000, text = "aged in the long count" },
            { id = "elder", maxAge = 999999, text = "ancient among the long-lived" },
        },
    },
    elf = {
        label = "Elven span",
        bands = {
            { id = "child", maxAge = 100, text = "a child by elven count" },
            { id = "youth", maxAge = 300, text = "youth among the stars' children" },
            { id = "young_adult", maxAge = 1000, text = "young by millennia, adult by deed" },
            { id = "adult", maxAge = 5000, text = "in the long adulthood of the elves" },
            { id = "veteran", maxAge = 10000, text = "veteran of ages; witness of ruin and vigil" },
            { id = "elder", maxAge = 999999, text = "elder of the Long Vigil and older nights" },
        },
    },
    -- Earthen and Dracthyr spans come back from the Retail build before the
    -- Forever split (commit e7a5370).
    earthen = {
        label = "Earthen / titan-forged",
        bands = {
            { id = "child", maxAge = 50, text = "newly shaped or newly aware" },
            { id = "youth", maxAge = 200, text = "learning the weight of stone and oath" },
            { id = "young_adult", maxAge = 1000, text = "proven in the deep places" },
            { id = "adult", maxAge = 10000, text = "steadfast as the ordered world" },
            { id = "veteran", maxAge = 50000, text = "memory of keepers and long dark" },
            { id = "elder", maxAge = 9999999, text = "as old as vaults and star-metal" },
        },
    },
    dracthyr = {
        label = "Dracthyr",
        bands = {
            { id = "child", maxAge = 20, text = "barely fledged in this age" },
            { id = "youth", maxAge = 50, text = "young weaver of visage and scale" },
            { id = "young_adult", maxAge = 200, text = "adult of the flights' design" },
            { id = "adult", maxAge = 2000, text = "tempered — if memory of stasis counts" },
            { id = "veteran", maxAge = 20000, text = "forged in Scaleborn fire, scarred by ages" },
            { id = "elder", maxAge = 999999, text = "elder of Neltharion's experiment" },
        },
    },
    undead = {
        label = "Undead span",
        bands = {
            { id = "child", maxAge = 12, text = "a brief living childhood, if any" },
            { id = "youth", maxAge = 17, text = "cut short or twisted young" },
            { id = "young_adult", maxAge = 30, text = "death found them early in life" },
            { id = "adult", maxAge = 60, text = "a full mortal life before the grave" },
            { id = "veteran", maxAge = 200, text = "long in undeath" },
            { id = "elder", maxAge = 99999, text = "ancient among the restless" },
        },
    },
}

-- Retail's playable races (UnitRace file tokens), as the Retail build mapped
-- them before the Forever split. Haranir ("Harronir" in Blizzard's code) are
-- left on the mortal default until their lifespan is decided.
Blackacre.RaceLongevityMap = {
    Human = "mortal",
    Orc = "mortal",
    Dwarf = "mortal",
    NightElf = "elf",
    Scourge = "undead",
    Tauren = "mortal",
    Gnome = "mortal",
    Troll = "mortal",
    Goblin = "mortal",
    BloodElf = "elf",
    Draenei = "long_lived",
    Worgen = "mortal",
    Pandaren = "mortal",
    Nightborne = "elf",
    HighmountainTauren = "mortal",
    VoidElf = "elf",
    LightforgedDraenei = "long_lived",
    ZandalariTroll = "mortal",
    KulTiran = "mortal",
    DarkIronDwarf = "mortal",
    Vulpera = "mortal",
    MagharOrc = "mortal",
    Mechagnome = "mortal",
    Dracthyr = "dracthyr",
    EarthenDwarf = "earthen",
}

function Blackacre.DetectLongevityProfile()
    local _, raceFile = UnitRace("player")
    return raceFile and Blackacre.RaceLongevityMap[raceFile] or "mortal"
end

function Blackacre.GetLongevityProfileId()
    local id = Blackacre.YearCalendar.EnsureIdentity()
    if id.longevityProfile and id.longevityProfile ~= "auto" and Blackacre.LongevityProfiles[id.longevityProfile] then
        return id.longevityProfile
    end
    return Blackacre.DetectLongevityProfile()
end

function Blackacre.GetLongevityProfile()
    local pid = Blackacre.GetLongevityProfileId()
    return Blackacre.LongevityProfiles[pid] or Blackacre.LongevityProfiles.mortal, pid
end

function Blackacre.GetAgeBand(ageYears)
    ageYears = tonumber(ageYears) or 0
    if ageYears < 0 then ageYears = 0 end
    local profile = Blackacre.GetLongevityProfile()
    for _, band in ipairs(profile.bands) do
        if ageYears <= band.maxAge then
            return band, profile
        end
    end
    return profile.bands[#profile.bands], profile
end
