256 byte demo stuff for the BBC Micro.

**This repo has submodules**. Clone it with `git clone --recursive https://github.com/tom-seddon/256_bytes`.

If you're reading this after already cloning it:

	git submodule init
	git submodule update

# build

Prerequisites:

- Python 3.x
- [64tass](https://sourceforge.net/projects/tass64/)
- GNU make

To build, type `make`.

The output is SSD files in `build/`. Put on a disk and run with
Shift+BREAK.

## released demos

- `build/wobble_colours.ssd` - Wobble Colours (https://www.pouet.net/prod.php?which=88421)
- `build/alien_daydream.ssd` - Alien Daydream (https://www.pouet.net/prod.php?which=91130)
- `build/lovebyte_2023_4.ssd` - March of the Triangles (https://www.pouet.net/prod.php?which=93661)
- `build/nova_2023_1.ssd` - Sine of the Chimes (https://www.pouet.net/prod.php?which=94558)
- `beeb/0/$.16B#2e4` - Untitled 16 (no disk image - tokenized BASIC)
- `build/lovebyte_2024_3.ssd` - Untitled 32
- `build/lovebyte_2024_4.ssd` - Untitled 64
- `build/lovebyte_2024_5.ssd` - Untitled 128

## unreleased demos

- `build/2_scrollers.ssd` - big horizontally scrolling text

(plus some prototypes of varying quality)

# licence

GPL 3.0

# example `.dir-locals.el`

    ((nil . ((compile-command . "cd ~/beeb/code/256_bytes && make tom_laptop"))))

# example jsbeeb link

https://bbc.godbolt.org/?&disc=https://raw.githubusercontent.com/tom-seddon/256_bytes/07ac8a22e7e917a5683d4635d65935bbe0b07972/nova_2023/sotc.ssd&autoboot&model=Master
