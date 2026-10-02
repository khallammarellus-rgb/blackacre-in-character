# Blackacre

A WoW addon for in-character immersive RPG elements and making simple environmental based connections.

**Version:** 2.0.0-dev (renamed from In Character · Blackacre identity)  
**Target:** Retail WoW 12.0.7+ (`120007`) and WoW Forever beta (`16001` / Camelot)  
**Repo:** Forever fork: https://github.com/khallammarellus-rgb/blackacre-in-character-forever

---

## Packages (enable all four for the full suite)

| Folder | Title | Role |
|---|---|---|
| `Blackacre` | **Blackacre** | Base |
| `Blackacre_Presence` | Blackacre **Presence** | Connections |
| `Blackacre_Tome` | Blackacre **Tome** | Journaling |
| `Blackacre_Survival` | Blackacre **Survival** | Survival Immersion|

---

## Features

| Module | Package | Status |
|---|---|---|
| **Chronicle** — Tome with skins and voice prose | Tome | 0.2+ |
| **Survival** — hunger, thirst, exposure | Survival | 0.4+ |
| **Afterlife** — IC return rites | Tome | 0.5+ |
| **Share** — Journal sharing | Tome | 0.7+ |
| **Lineage** — Character development | Tome | 0.8+ |
| **Presence** — Beacons + Bulletins | Presence | 0.9+ |
| **Setup wizard** — rough non-operable right now | Tome | **1.2.0** |

---

## Install from GitHub

```Intall within the AddOn folder
Unzip after downloading, and only place the folders titled "Blackacre" within the Interface AddonFolder. See the example filepath below
C:\Program Files (x86)\World of Warcraft\_classic_beta_\Interface\AddOns
```

Slash aliases: **`/ba`**, **`/blackacre`**

---

## Slash commands

| Command | Description |
|---|---|
| `/ba` or `/blackacre` or `/ic` | Presence panel (requires Presence folder) |
| `/ba beacon` | Emit / withdraw beacon |
| `/ba bulletin` | Post a bulletin at a board |
| `/ba beacons on` / `off` | Receive beacons (default is on) |
| `/ba tome` / `/ba chronicle` | Traveler’s Tome (one book, tabs) |
| `/ba setup` | First-run character & lineage tutorial (WIP)|
| `/ba voice` | Accent / IC voice settings |
| `/ba survival` | Condition toggle |
| `/ba eat` / `drink` / `rest` | Survival recovery |
| `/ba packages` | List loaded packages + version |
| `/ba ping` | Invisible comms test |

**Minimap:** Left = Presence · Right = Tome · Shift+Right = emit beacon

---

## Legal

World of Warcraft © Blizzard Entertainment. This is a fan addon, not affiliated with Blizzard.

## Credits
Thanks to the Texture Atlas Viewer add on developer for making the visuals entirely possible
