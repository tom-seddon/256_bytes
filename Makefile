# -*- mode:makefile-gmake; -*-

ifeq ($(OS),Windows_NT)
TASS?=64tass.exe
# $(error exomizer...?)
PYTHON2?=py -2
PYTHON?=py -3
else
TASS?=64tass
EXOMIZER?=exomizer-3.1.1
PYTHON?=python3.8
endif

BEEBASM?=beebasm

TMP:=build
TASSCMD:=$(TASS) --m65c02 --cbm-prg -Wall -C --line-numbers
SHELLCMD:=$(PYTHON) $(realpath submodules/shellcmd.py/shellcmd.py)
BEEB_BIN:=$(shell $(SHELLCMD) realpath ./submodules/beeb/bin)
DEST:=$(shell $(SHELLCMD) realpath ./beeb/1)

ifeq ($(OS),Windows_NT)
GITHUB_IO:=$(shell $(SHELLCMD) realpath ../tom-seddon.github.io)
else
GITHUB_IO:=$(HOME)/github/tom-seddon.github.io/
endif

##########################################################################
##########################################################################

.PHONY:build
build: _folders
	$(MAKE) _assemble_and_ssd SRC=wobble_colours BBC=1 SSD=wobble_colours "TASS_EXTRA=-DSCROLL_OFFSET=0"
	$(MAKE) _assemble_and_ssd SRC=wobble_colours BBC=2 SSD=wobble_colours_scroll "TASS_EXTRA=-DSCROLL_OFFSET=1"
	$(MAKE) _assemble_and_ssd SRC=alias_sines BBC=ASINES SSD=alias_sines
	$(MAKE) _assemble_and_ssd SRC=2_scrollers BBC=2SCROLL SSD=2_scrollers
	$(MAKE) _assemble_and_ssd SRC=alien_daydream BBC=ALIEN SSD=alien_daydream
	$(MAKE) build_r22
	$(MAKE) build_lovebyte_2023
	$(MAKE) build_lovebyte_2023_2
	$(MAKE) build_lovebyte_2023_3
	$(MAKE) build_lovebyte_2023_4
	$(MAKE) build_nova_2023_1

.PHONY:build_lovebyte_2023
build_lovebyte_2023:
	$(MAKE) _assemble_and_ssd SRC=lovebyte_2023 BBC=LB23 SSD=lovebyte_2023

.PHONY:build_lovebyte_2023_2
build_lovebyte_2023_2:
	$(MAKE) _assemble_and_ssd SRC=lovebyte_2023_2 BBC=LB23_2 SSD=lovebyte_2023_2

.PHONY:build_lovebyte_2023_3
build_lovebyte_2023_3:
	$(MAKE) _assemble_and_ssd SRC=lovebyte_2023_3 BBC=LB23_3 SSD=lovebyte_2023_3

.PHONY:build_lovebyte_2023_4
build_lovebyte_2023_4:
	$(MAKE) _assemble_and_ssd SRC=lovebyte_2023_4 BBC=MOTT SSD=lovebyte_2023_4

.PHONY:build_nova_2023_1
build_nova_2023_1:
	$(MAKE) _assemble_and_ssd SRC=nova_2023_1 BBC=NOVA231 SSD=nova_2023_1 PRG2BBC_EXTRA=--execution-address

.PHONY:build_r22
build_r22: _folders
	$(MAKE) _assemble SRC=r22 BBC=r22
	$(MAKE) _assemble SRC=r22_fast_startup BBC=r22fs
	$(PYTHON) "$(BEEB_BIN)/ssd_create.py" -o "$(TMP)/r22.ssd" -b "CHAIN\"r22fs\"" "$(DEST)/$$.r22" "$(DEST)/$$.r22fs"

.PHONY:_folders
_folders:
	$(SHELLCMD) mkdir "$(DEST)"
	$(SHELLCMD) mkdir "$(TMP)"

# cd "$(TMP)" && $(EXOMIZER) sfx 0x2000 r22.prg -o r22exo -t48075 -n
# $(SHELLCMD) copy-file "$(TMP)/r22exo" "$(DEST)/$$.r22exo"
# $(SHELLCMD) copy-file "$(TMP)/r22exo.inf" "$(DEST)/$$.r22exo.inf"
# $(MAKE) _ssd SSD=r22exo BBC=r22exo

##########################################################################
##########################################################################

$(TMP)/StuntCarRacerTitleScreen.dat:StuntCarRacerTitleScreen.png
	$(PYTHON2) $(BEEB_BIN)/png2bbc.py -o "$@" --160 "$<" 2

# $(TMP)/StuntCarRacerTitleScreen.exo:$(TMP)/StuntCarRacerTitleScreen.dat
# 	$(EXO) 

##########################################################################
##########################################################################

# see _assemble
# SSD=stem of SSD 
.PHONY:_assemble_and_ssd
_assemble_and_ssd:
	$(MAKE) _assemble SRC=$(SRC) BBC=$(BBC)
	$(MAKE) _ssd SSD=$(SSD) BBC=$(BBC)

.PHONY:_ssd
_ssd:
	$(PYTHON) $(BEEB_BIN)/ssd_create.py -o "$(TMP)/$(SSD).ssd" -b "*/$$.$(BBC)" "$(DEST)/$$.$(BBC)"

# SRC=stem of s65
# BBC=stem of Beeb name, copied to $(DEST)
.PHONY:_assemble
_assemble:
	$(TASSCMD) $(TASS_EXTRA) "$(SRC).s65" "-L$(TMP)/$(SRC).lst" "-l$(TMP)/$(SRC).sym" "-o$(TMP)/$(SRC).prg"
	$(PYTHON) $(BEEB_BIN)/prg2bbc.py $(PRG2BBC_EXTRA) "$(TMP)/$(SRC).prg" "$(DEST)/$$.$(BBC)"

##########################################################################
##########################################################################

.PHONY:clean
clean:
	$(SHELLCMD) rm-tree "$(TMP)"

##########################################################################
##########################################################################

.PHONY:_for_each
_for_each:
	@$(MAKE) --no-print-directory $(TARGET) "NAME=wobble_colours"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=wobble_colours_scroll"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=alias_sines"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=2_scrollers"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=alien_daydream"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=lovebyte_2023"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=lovebyte_2023_2"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=lovebyte_2023_3"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=lovebyte_2023_4"
	@$(MAKE) --no-print-directory $(TARGET) "NAME=nova_2023_1"

.PHONY:dist
dist: export _SSD=./ssd/
dist:
	$(MAKE) clean
	$(MAKE) build
	$(SHELLCMD) mkdir "$(_SSD)"
	$(MAKE) _for_each TARGET=_dist_copy

.PHONY:_dist_copy
_dist_copy:
	$(SHELLCMD) copy-file "$(TMP)/$(NAME).ssd" "$(_SSD)/"

.PHONY:urls
urls: export COMMIT:=$(shell git log -1 '--format=%H')
urls:
	echo $(COMMIT)
	$(MAKE) _for_each TARGET=_url

.PHONY:_url
_url:
	@echo "https://bbc.godbolt.org/?&disc=https://raw.githubusercontent.com/tom-seddon/256_bytes/$(COMMIT)/ssd/$(NAME).ssd&autoboot&model=Master"

##########################################################################
##########################################################################


# for me, on my Mac, so assume Unix...
.PHONY:dist_and_upload
dist_and_upload:
	$(MAKE) dist
	$(MAKE) _github.io NAME=wobble_colours.ssd
	$(MAKE) _github.io NAME=wobble_colours_scroll.ssd
	$(MAKE) _github.io NAME=alias_sines.ssd
	$(MAKE) _github.io NAME=2_scrollers.ssd
	$(MAKE) _github.io NAME=alien_daydream.ssd
	$(MAKE) _github.io NAME=lovebyte_2023.ssd
	$(MAKE) _github.io NAME=lovebyte_2023_2.ssd
	$(MAKE) _github.io NAME=lovebyte_2023_3.ssd
	$(MAKE) _github.io NAME=lovebyte_2023_4.ssd
	$(MAKE) _github.io NAME=nova_2023_1.ssd
	cd "$(GITHUB_IO)" && git push

.PHONY:_github.io
_github.io:
	cp "$(TMP)/$(NAME)" "$(GITHUB_IO)/"
	cd "$(GITHUB_IO)" && git add "$(NAME)" && git commit --allow-empty -m "Add/update $(NAME)." "$(NAME)"
# model=Master isn't always appropriate, but it's easy enough to remove...
	@echo "https://bbc.godbolt.org/?&disc=https://tom-seddon.github.io/$(NAME)&autoboot&model=Master"

##########################################################################
##########################################################################

# for me, on my laptop
.PHONY:tom_laptop
tom_laptop: _TARGET=nova_2023_1
tom_laptop:
	$(MAKE) build_$(_TARGET)
	$(MAKE) b2 'CONFIG=Master 128 (MOS 3.20)' SSD=$(_TARGET)

.PHONY:b2
b2:
	curl --connect-timeout 0.25 --silent -G 'http://localhost:48075/reset/b2' --data-urlencode "config=$(CONFIG)"
	curl --connect-timeout 0.25 --silent -H 'Content-Type:application/binary' --upload-file '$(TMP)/$(SSD).ssd' 'http://localhost:48075/run/b2?name=$(SSD).ssd'
