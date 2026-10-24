-- In Character: Journal - Page Templates

Blackacre = Blackacre or {}

Blackacre.HookTemplates = {
    QUEST = {
        "It was {yearKC} {month}, and {day} and I just marked another milestone in my personal histories. . .({questName}). {questOffer} {questReward}",
    },
    QUESTLINE = {
        "It was {yearKC} {month}, and {day} in the {dayDescription} and it was {weatherText}. {giverName} just sent me on an errand. . . {questOffer}",
        "I finished {giverName}'s. . .({questReward})",
    },
    META_QUEST = {
        "It was {yearKC} {month}, and {day}",
    },
    META_ACHIEVEMENT = {
        "{yearKC} {month}, and {day} my long journey came to an end after an exhausting tour. . .",
    },
    FOS = {
        "Today I impressed myself well enough by achieving {achievementName} and I feel more esteemed. . .",
    },
    REPUTATION = {
        "{yearKC} {month}, and {day}, my standing with {theFaction} rose. I am earning their trust. . .I must not squander it. . .",
    },
    -- One person (Ve'nari) or a household (the Tillers): named ranks.
    -- rank = a named rank on a short ladder; closer = a quarter of a long one
    -- (whose rank names may be plain levels, so they're not quoted);
    -- closest = the top rank.
    FRIENDSHIP = {
        rank = "{yearKC} {month}, and {day}, {factionName} and I have grown closer. I would call us {standingName} now. . .",
        closer = "{yearKC} {month}, and {day}, {factionName} trusts me more with every road we share. . .",
        closest = "{yearKC} {month}, and {day}, there is no one {factionName} trusts more than me now, and I would say the same. . .",
    },
    -- Renown: a quarter, half and three quarters of the top level (rising),
    -- then the top (max).
    RENOWN = {
        rising = "{yearKC} {month}, and {day}, word of my deeds has spread among {theFaction}. More of them know my name each day. . .",
        max = "{yearKC} {month}, and {day}, there is no one among {theFaction} who does not know my name. I have done all they could ask of me. . .",
    },
    ACHIEVEMENT = {
        "{yearKC} {month}, and {day}. Huzzah! I made a personal achievement today! {achievementName} {achievementDetail}",
        "My deeds aggregate more and more! {yearKC} {month}, and {day} is the day I made a mark in the annals of history. {achievementName} {achievementDetail}",
    },
    TITLE = {
        "This day on {yearKC} {month} {day} I was bestowed the title of {titleName}. . .",
    },
    -- Retail never writes this kind (no weapon skills); kept so pages brought
    -- in from an In Character Forever backup still read properly.
    WEAPON_SKILL = {
        "It was {yearKC} {month}, and {day}, and my hand knows {skillName} as well as any hand can. There is no more the drills can teach me. . .",
        "It was {yearKC} {month}, and {day}. Years of practice, and today I felt it: I have mastered {skillName}. . .",
    },
    PROFESSION = {
        apprentice = "It was {yearKC} {month}, and {day} and I have completed my apprenticeship in {skillName}.",
        journeyman = "It was {yearKC} {month}, and {day} and I stand as a journeyman of {skillName}.",
        expert = "It was {yearKC} {month}, and {day} and my {skillName} is called expert work.",
        artisan = "It was {yearKC} {month}, and {day} and I have reached artisan in {skillName}.",
        -- Specializations (knowledge points): the trees open, one is chosen,
        -- one is finished.
        specUnlocked = "It was {yearKC} {month}, and {day}, and my {skillName} has grown enough that I may choose where to take it from here. . .",
        specChosen = "It was {yearKC} {month}, and {day}, and I have set my hands to {specName}. My {skillName} will run deeper down that road. . .",
        specMastered = "It was {yearKC} {month}, and {day}. There is nothing left of {specName} that I do not know; my {skillName} has carried me to the end of that road. . .",
    },
    MANUAL = {
        "{manualTitle}. {manualBody}",
    },
    DEATH = {
        "It was {yearKC} {month}, and {day} and I felt the cold grasp me. . .my Rites before me await.",
    },
    AFTERLIFE = {
        "I write this down to remember the solemnity of the Rites of Return I endures to walk the path back and continue the journey this day of {yearKC} {month} {day}",
    },
    PVP = {
        defeat = "{pvpBody}",
        victory = "{pvpBody}",
    },
    DEFAULT = {
        "It is {yearKC} {month} and {day}, and I mark this moment today. . .",
    },
}

-- Level-band flavor fragments for optional templates that use {seasoning}
Blackacre.HookSeasoning = {
    { maxLevel = 20, text = "young and untested" },
    { maxLevel = 40, text = "still early on the path" },
    { maxLevel = 60, text = "seasoned by road and trial" },
    { maxLevel = 80, text = "hard-forged by long campaign" },
    { maxLevel = 999, text = "weathered as old stone" },
}
