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

##########################################################################
##########################################################################

.PHONY:build
build:
	$(SHELLCMD) mkdir "$(DEST)"
	$(SHELLCMD) mkdir "$(TMP)"
	$(MAKE) _assemble SRC=wobble_colours BBC=1
	$(MAKE) _ssds

.PHONY:_assemble
_assemble:
	$(TASSCMD) "$(SRC).s65" "-L$(TMP)/$(SRC).lst" "-l$(TMP)/$(SRC).sym" "-o$(TMP)/$(SRC).prg"
	$(PYTHON) $(BEEB_BIN)/prg2bbc.py "$(TMP)/$(SRC).prg" "$(DEST)/@.$(BBC)"

.PHONY:_ssds
_ssds:
	$(PYTHON) $(BEEB_BIN)/ssd_create.py -o "$(TMP)/wobble_colours.ssd" -b "*/@.1" "$(DEST)/@.1"
	sha1sum "$(TMP)/wobble_colours.ssd"

.PHONY:clean
clean:
	$(SHELLCMD) rm-tree "$(TMP)"
