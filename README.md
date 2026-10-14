# LD60

A (soon to be) game for [Ludum Dare 60](https://ldjam.com/events/ludum-dare/60).

Initial project template and utilities are based on [EctGodotUtils](https://github.com/ectucker1/EctGodotUtils/tree/gdscript),
available under a MIT license.

There is a CI/CD pipeline that builds the game and hosts it on [its GitHub pages](https://ectucker1.github.io/ld60/).

The final submission will be on my [Ludum Dare profile](https://ldjam.com/users/ectucker1/games).

## Tools You'll Need

This game is made using [Godot Engine 4.7.2](https://godotengine.org/download/archive/4.7.2-stable/)

To work with this repository, you'll need the following:
- [git](https://git-scm.com/downloads)
- [Git Large File Storage](https://git-lfs.com/)

You may prefer to work with it using the [GitHub Desktop GUI](https://github.com/apps/desktop).

## Project Structure

`addon/` - 3rd-party editor addons. The following are included:
- [Aseprite Wizard](https://github.com/viniciusgerevini/godot-aseprite-wizard)

`util/` - non game-specific utilities.
The following are included:
- Debug overlay for printing text and displaying vectors
- LiveValues overlay for changing constants
- Screenshake, hitstop, and camera kickback
- Verlet physics for hair and rope
- Pixel-perfect camera setup
- Scene transitions
- Audio sequences
- Pause menus

Some of these are global autoloads.

`test/` - test scenes for utility features.