# In Character

**Blackacre: In Character** for Retail World of Warcraft. Designed to be a journal and RPG enhancing add on for WoW roleplay. This is the foundational base add on for planned extensions.

**Version:** 2.0.0-dev
**Target:** Retail World of Warcraft (Midnight, 12.1)
**Repo:** https://github.com/khallammarellus-rgb/blackacre-in-character · WoW Forever edition: https://github.com/khallammarellus-rgb/blackacre-in-character-forever

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
