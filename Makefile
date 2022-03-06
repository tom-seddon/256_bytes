# -*- mode:makefile-gmake; -*-

ifeq ($(OS),Windows_NT)
TASS?=64tass.exe
$(error exomizer...?)
else
TASS?=64tass
EXOMIZER?=exomizer-3.1.1
endif

PYTHON?=python3.8

TMP:=build
TASSCMD:=$(TASS) --m65c02 --cbm-prg -Wall -C --line-numbers
BEEB_BIN:=$(realpath submodules/beeb/bin)
SHELLCMD:=$(PYTHON) $(realpath submodules/shellcmd.py/shellcmd.py)
DEST:=$(realpath beeb/1)

##########################################################################
##########################################################################

$(TMP)/StuntCarRacerTitleScreen.dat:StuntCarRacerTitleScreen.png
	$(PYTHON) $(BEEB_BIN)/png2bbc.py -o "$@" --160 "$<" 2

# $(TMP)/StuntCarRacerTitleScreen.exo:$(TMP)/StuntCarRacerTitleScreen.dat
# 	$(EXO) 

##########################################################################
##########################################################################

.PHONY:_folders
_folders:
	$(SHELLCMD) mkdir "$(DEST)"
	$(SHELLCMD) mkdir "$(TMP)"

.PHONY:build
build: _folders
	$(MAKE) _assemble_and_ssd SRC=wobble_colours BBC=1 SSD=wobble_colours "EXTRA=-DSCROLL_OFFSET=0"
	$(MAKE) _assemble_and_ssd SRC=wobble_colours BBC=2 SSD=wobble_colours_scroll "EXTRA=-DSCROLL_OFFSET=1"
	$(MAKE) _assemble_and_ssd SRC=alias_sines BBC=ASINES SSD=alias_sines
	$(MAKE) _assemble_and_ssd SRC=2_scrollers BBC=2SCROLL SSD=2_scrollers
	$(MAKE) _assemble_and_ssd SRC=alien_daydream BBC=ALIEN SSD=alien_daydream
	$(MAKE) build_r22

.PHONY:build_r22
build_r22: _folders
	$(MAKE) _assemble SRC=r22 BBC=r22
	cd "$(TMP)" && $(EXOMIZER) sfx 0x2000 r22.prg -o r22exo -t48075 -n
	$(SHELLCMD) copy-file "$(TMP)/r22exo" "$(DEST)/$$.r22exo"
	$(SHELLCMD) copy-file "$(TMP)/r22exo.inf" "$(DEST)/$$.r22exo.inf"
	$(MAKE) _ssd SSD=r22exo BBC=r22exo

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
	$(TASSCMD) $(EXTRA) "$(SRC).s65" "-L$(TMP)/$(SRC).lst" "-l$(TMP)/$(SRC).sym" "-o$(TMP)/$(SRC).prg"
	$(PYTHON) $(BEEB_BIN)/prg2bbc.py "$(TMP)/$(SRC).prg" "$(DEST)/$$.$(BBC)"

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
	$(SHELLCMD) copy-file "$(TMP)/2_scrollers.ssd" "$(SSD)/"
	$(SHELLCMD) copy-file "$(TMP)/alien_daydream.ssd" "$(SSD)/"

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
	$(MAKE) _github.io NAME=2_scrollers.ssd
	$(MAKE) _github.io NAME=alien_daydream.ssd
	cd "$(GITHUB_IO)" && git push

.PHONY:_github.io
_github.io:
	cp "$(TMP)/$(NAME)" "$(GITHUB_IO)/"
	cd "$(GITHUB_IO)" && git add "$(NAME)" && git commit --allow-empty -m "Add/update $(NAME)." "$(NAME)"

##########################################################################
##########################################################################

# for me, on my laptop
.PHONY:tom_laptop
tom_laptop:
#	$(MAKE) build_r22
	$(MAKE) build
	$(MAKE) b2 'CONFIG=Master 128 (MOS 3.20)' SSD=r22exo

.PHONY:b2
b2:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=$(CONFIG)"
	curl -H 'Content-Type:application/binary' --upload-file '$(TMP)/$(SSD).ssd' 'http://localhost:48075/run/b2?name=$(SSD).ssd'
