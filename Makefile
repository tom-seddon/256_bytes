# -*- mode:makefile-gmake; -*-

ifeq ($(OS),Windows_NT)
TASS?=64tass.exe
else
TASS?=64tass
endif

PYTHON?=python3.8

TMP:=build
TASSCMD:=$(TASS) --m65c02 --cbm-prg -Wall -C --line-numbers
BEEB_BIN:=submodules/beeb/bin
SHELLCMD:=$(PYTHON) submodules/shellcmd.py/shellcmd.py
DEST:=beeb/1
SSD:=ssd

##########################################################################
##########################################################################

.PHONY:build
build:
	$(SHELLCMD) mkdir "$(DEST)"
	$(SHELLCMD) mkdir "$(TMP)"
	$(MAKE) _assemble SRC=wobble_colours BBC=1 SSD=wobble_colours "EXTRA=-DSCROLL_OFFSET=0"
	$(MAKE) _assemble SRC=wobble_colours BBC=2 SSD=wobble_colours_scroll "EXTRA=-DSCROLL_OFFSET=1"
	$(MAKE) _assemble SRC=alias_sines BBC=ASINES SSD=alias_sines
	$(MAKE) _assemble SRC=3_scrollers BBC=3SCROLL SSD=love_byte_2022

##########################################################################
##########################################################################

.PHONY:_assemble
_assemble:
	$(TASSCMD) $(EXTRA) "$(SRC).s65" "-L$(TMP)/$(SRC).lst" "-l$(TMP)/$(SRC).sym" "-o$(TMP)/$(SRC).prg"
	$(PYTHON) $(BEEB_BIN)/prg2bbc.py "$(TMP)/$(SRC).prg" "$(DEST)/@.$(BBC)"
	$(PYTHON) $(BEEB_BIN)/ssd_create.py -o "$(TMP)/$(SSD).ssd" -b "*/@.$(BBC)" "$(DEST)/@.$(BBC)"

##########################################################################
##########################################################################

.PHONY:clean
clean:
	$(SHELLCMD) rm-tree "$(TMP)"

##########################################################################
##########################################################################

.PHONY:dist
dist:
	$(SHELLCMD) mkdir "$(SSD)"
	$(SHELLCMD) copy-file "$(TMP)/wobble_colours.ssd" "$(SSD)/"
	$(SHELLCMD) copy-file "$(TMP)/wobble_colours_scroll.ssd" "$(SSD)/"

##########################################################################
##########################################################################

GITHUB_IO:=$(HOME)/github/tom-seddon.github.io/

# for me, on my Mac, so assume Unix...
.PHONY:dist_and_upload
dist_and_upload:
	$(MAKE) dist
	$(MAKE) _github.io NAME=wobble_colours.ssd
	$(MAKE) _github.io NAME=wobble_colours_scroll.ssd
	$(MAKE) _github.io NAME=alias_sines.ssd
	cd "$(GITHUB_IO)" && git push

.PHONY:_github.io
_github.io:
	cp "$(TMP)/$(NAME)" "$(GITHUB_IO)/"
	cd "$(GITHUB_IO)" && git add "$(NAME)" && git commit -m "Add/update $(NAME)." "$(NAME)"
