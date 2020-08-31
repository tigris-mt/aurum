# Aurum
Aurum is an adventure/survival/building/crafting voxel game built on the [Minetest Engine](https://www.minetest.net).
Aurum brings core gameplay by default with great extensibility. This game is much more than a modding base, though it provides many useful tools for modders.
Aurum is currently in its rapid development stage, working toward a fully-featured [1.0 release](https://github.com/tigris-mt/aurum/milestone/2). Contributions are very welcome.

[Github Repository](https://github.com/tigris-mt/aurum)

## Getting Aurum
The [latest stable version](https://github.com/tigris-mt/aurum-compiled/archive/stable.zip) of Aurum is 0.54.0.0, developed for Minetest 5.3.0 and later.

* Direct download: [Stable 0.54.0.0](https://github.com/tigris-mt/aurum-compiled/archive/stable.zip)
* Direct download: [Development](https://github.com/tigris-mt/aurum-compiled/archive/master.zip)
* Source repository (has lots of submodules): [Development](https://github.com/tigris-mt/aurum)
* Source repository (automatically generated, no submodules): [Compiled](https://github.com/tigris-mt/aurum-compiled)

### Legacy Versions
When new major versions are released, old versions will remain available.

## Notable Features
* In-game help system and crafting guide.
* Item enchanting system.
* Flexible armor and equipment.
* Magic system with scrolls, rods, and rituals.
* World story and lore.
* Multiple realms/dimensions using normal mapgen; wild and dangerous landscapes accessible via portal.
* Broad, applicable structure and treasure generation.
* Wide variety of biomes.
* Heavily extensible functionality for modding or contributing.

## Screenshots
![Screenshot of the player](https://raw.githubusercontent.com/tigris-mt/aurum/master/screenshots/player.0.46.0.png)

## General Goals
In their [forum post](https://forum.minetest.net/viewtopic.php?f=5&t=19023#p305711), Wuzzy outlined a few interesting goals to achieve for general games to be included in minetest.

* Past alpha stage (completion).
* More than 6 hours of play.
* No obvious/breaking/super-annoying bugs or crashes.
* Help system (manual, in-game help, etc.)
* FOSS
* Stable worlds and APIs.

## License
Unless otherwise noted (such as 3rd party content described in a section below):
* Code is under the [ISC license](https://raw.githubusercontent.com/tigris-mt/aurum-compiled/master/LICENSE.md).
* Media is under the [CC-BY-SA 4.0 license](https://creativecommons.org/licenses/by-sa/4.0/).

### 3rd Party Content and Licenses
3rd party content is included as submodules and symlinked if necessary.
In the development repository, you can view each submodule for its specific details.

#### Textures
* textures/character.png -- Modified from the original by Jordach (CC BY-SA 3.0)
* textures/wieldhand.png -- Modified from the version by paramat (CC BY-SA 3.0) -- Copied from character.png by Jordach (CC BY-SA 3.0)

#### Sounds
* mods/player/aurum_hunger/sounds/aurum_hunger_eat.ogg -- hunger_eat.ogg by BlockMen (CC-BY 3.0)

#### Compiled Repository
In the compiled repository, certain submodules are removed for the sake of space, linked here:
* [2bbcode](https://github.com/lilydjwg/2bbcode)
* [minetest_game](https://github.com/minetest/minetest_game)

You can view the assets and code that originate from such submodules in [symlink_report.txt](https://raw.githubusercontent.com/tigris-mt/aurum-compiled/master/symlink_report.txt)
