ifneq ($(wildcard rgbds/.*),)
RGBDS_DIR = rgbds/
else
RGBDS_DIR =
endif

MD5 := md5sum -c

pokered_obj := audio_red.o main_red.o text_red.o wram_red.o
pokeblue_obj := audio_blue.o main_blue.o text_blue.o wram_blue.o

.SUFFIXES:
.SECONDEXPANSION:
# Suppress annoying intermediate file deletion messages.
.PRECIOUS: %.2bpp
.PHONY: all clean red blue compare tools

roms := pokered.gbc pokeblue.gbc

all: $(roms)
red: pokered.gbc
blue: pokeblue.gbc

# For contributors to make sure a change didn't affect the contents of the rom.
compare: red blue
	@$(MD5) roms.md5

clean:
	rm -f $(roms) $(pokered_obj) $(pokeblue_obj) $(roms:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' \) -exec rm {} +
	$(MAKE) clean -C tools/

tools:
	$(MAKE) -C tools/


# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tools,$(MAKECMDGOALS)))
$(info $(shell $(MAKE) -C tools))
endif



%.asm: ;

%_red.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(pokered_obj): %_red.o: %.asm $$(dep)
	$(RGBDS_DIR)rgbasm -D _RED -h -o $@ $*.asm

%_blue.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(pokeblue_obj): %_blue.o: %.asm $$(dep)
	$(RGBDS_DIR)rgbasm -D _BLUE -h -o $@ $*.asm

pokered_opt  = -Cjv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON RED"
pokeblue_opt = -Cjv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON RED"

%.gbc: $$(%_obj)
	$(RGBDS_DIR)rgblink -m $*.map -n $*.sym -o $@ $^
	$(RGBDS_DIR)rgbfix $($*_opt) $@
	sort $*.sym -o $*.sym

gfx/blue/intro_purin_1.6x6.2bpp: rgbgfx += -h
gfx/blue/intro_purin_2.6x6.2bpp: rgbgfx += -h
gfx/blue/intro_purin_3.6x6.2bpp: rgbgfx += -h
gfx/red/intro_nido_1.6x6.2bpp: rgbgfx += -h
gfx/red/intro_nido_2.6x6.2bpp: rgbgfx += -h
gfx/red/intro_nido_3.6x6.2bpp: rgbgfx += -h

gfx/game_boy.norepeat.2bpp: tools/gfx += --remove-duplicates
gfx/theend.interleave.2bpp: tools/gfx += --interleave --png=$<
gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace

%.png: ;

%.2bpp: %.png
	rgbgfx $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)
%.1bpp: %.png
	rgbgfx -d1 $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)
%.pic:  %.2bpp
	tools/pkmncompress $< $@
