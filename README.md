256 byte demo stuff for the BBC Micro.

**This repo has submodules**. Clone it with `git clone --recursive https://github.com/tom-seddon/256_bytes`.

If you're reading this after already cloning it:

	git submodule init
	git submodule update

# build

Prerequisites:

- Python
- [64tass](https://sourceforge.net/projects/tass64/)
- GNU make

To build, type `make`.

The output is SSD files in `build/`. Put on a disk and run with
Shift+BREAK.

- `build/wobble_colours.ssd` - wobbling text and scrolling colours

# licence

GPL 3.0
