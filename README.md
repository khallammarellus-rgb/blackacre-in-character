# In Character

**Blackacre: In Character** for Retail World of Warcraft. Designed to be a journal and RPG enhancing add on for WoW roleplay. This is the foundational base add on for planned extensions.

**Version:** 2.5.0
**Target:** Retail World of Warcraft (Midnight, 12.1)
**Repo:** https://github.com/khallammarellus-rgb/blackacre-in-character · WoW Forever edition: https://github.com/khallammarellus-rgb/blackacre-in-character-forever

---

## What's new in 2.5.0

**Journal and Quest Index**
- Quest Index tabs: **This character** and **Warband**. Warband quests are no longer imported into a character's list; one you turn in is recorded as it happens.
- Search the Quest Index by quest name or by words in the quest; put a phrase in "quotes" for an exact match.
- Abandoned quests stay in the Index, marked **Started**.
- Imported quests can be journaled on request with **Journal Quest**.
- Repeatable quests keep their first completion, numbered tracker quests are hidden unless **Numbered** is ticked, and retired quests show as **Retired Quest**.
- Quest text is shared across your characters, and can be swapped with other In Character players (toggle in Settings).
- **Import earlier quests** brings in everything the game lists, with progress messages; the Index stays light however big it gets.
- New journal pages for profession steps, specializations, friendship ranks and renown.
- The in-game year now follows the real calendar (42 ADP in 2026, one more each 1 January); old pages keep their year.
- New journal background.

**Backups**
- **Export Tome** backup, and importing a Tome backup now merges into your journal instead of replacing it.

**Survival**
- **Spirit Form** while dead: meters pause, and you come back hungry and thirsty.
- Campfires warm you: **Campfire Nearby** and **Cozy Fire**.
- Food and water tiers slow the drain, **Well Fed** holds hunger, cooked food refills it, and drinking fills thirst as you drink.
- Climates for about 40 more zones.
- Every character starts with Survival on, and turning it on brings the meters back.

**Tour and Settings**
- **Helper** (`/ba helper`): a full guided tour or one per part, offered once on first login.
- Settings sections are now a list on the left, in a roomier window.

**Fixes**
- Missing game art is left out instead of drawn as a stand-in.
- Windows always come to the front when opened or clicked.
- No more boxes for marks the journal fonts lack; races without a kin font get Morpheus.
- "Player not found" no longer appears after add-on messages.
- Lighter map-pin cursor and chat filter.

---

## Install

1. Download the latest release zip, or on GitHub use **Code → Download ZIP**.
2. Copy these four folders into your Retail `World of Warcraft\_retail_\Interface\AddOns` folder:
   `Blackacre`, `Blackacre_Tome`, `Blackacre_Survival`, `Blackacre_Presence`.
   (In a GitHub ZIP they sit inside the `blackacre-in-character-main` folder; copy the four folders, not that outer folder.)
3. Character select → AddOns → enable the **In Character** group → `/reload`.

## Player Maintenance
Data is saved under SavedVariables per profile generated.

Slash aliases: **`/ba`**, **`/blackacre`**, and legacy **`/ic`**.

---

## Slash commands

| Command | Description |
|---|---|
| `/ba` | Tool Box (beacon, seeking, bulletins) |
| `/ba journal` | Open your journal |
| `/ba quests` | Quest Index: every quest you've taken up and finished |
| `/ba config` | Settings |
| `/ba voice` | Settings → Voice |
| `/ba honor` | Settings → Survival honor rules |
| `/ba survival` | Condition meters |
| `/ba eat` / `drink` / `rest` | Survival recovery |
| `/ba beacon` / `/ba bulletin` | Emit a beacon / post a bulletin |
| `/ba restore` | Backups: restore, undo a restore, or import a backup |
| `/ba export profile` | Full profile backup |
| `/ba packages` | Loaded add-ons + version |

---

## Legal

World of Warcraft © Blizzard Entertainment. This is a fan add-on, not affiliated with Blizzard.

## License

The add-on's own code and text are released under the [MIT License](LICENSE). That covers only this project's work: Warcraft names and lore belong to Blizzard, and the bundled libraries and fonts keep their own licenses (see `Blackacre/Libs/LICENSES.txt` and `Blackacre/Media/Fonts/FONTS.txt`).

The Blackacre fonts made for this add-on (Khaz, Highborne, Highborne Text, Old Gilnean, Learned Hand, Peon and Tol'vir, the `Blackacre*.ttf` files in `Blackacre/Media/Fonts/`) are dedicated to the public domain under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/). Anyone may use, change and redistribute them for any purpose, including commercial work, without asking and without giving credit.

Found a bug? Open an issue on this repository. The in-game report window (Shift+Right-click the minimap button) fills in the details for you.

## Credits

Full credits are in-game under Settings → Credits. Thanks also to the Texture Atlas Viewer add-on developer for making the visuals entirely possible. Claude IDE extensions used in VS code to run lua checkers and assist.
