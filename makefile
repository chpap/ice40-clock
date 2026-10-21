YOSYS=yosys
#VHDL_SYN_FILES=$(wildcard *.vhdl)
VHDL_SYN_FILES=clock.vhdl
TOPLEVEL=clock
GHDLSYNTH=ghdl
PLATFORM=ice40
GHDL_FLAGS="--std=08"
include ghdlsynth.mk

synthesize: clock.bin

work-obj08.cf: $(SOURCES)
	ghdl -a --std=08 *.vhdl

.PHONY: work-obj08.cf

clock.asc: clock.json
	nextpnr-ice40 --hx8k --package ct256 --json $< --pcf pinmap.pcf --asc $@

clock.bin: clock.asc
	icepack $< $@

run: demo.bin
	scp demo.bin pi@192.168.0.230:/home/pi/ice40/data.bin
	ssh pi@192.168.0.230 "/home/pi/ice40/upload.sh"

clean:
	rm -f *.{v,asc,bin,blif,json,cf,o}

.PHONY: synthesize
