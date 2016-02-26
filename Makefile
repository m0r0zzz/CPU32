std := 2012
warn := all
dir := /c/Dev/Projects/CPU32
target := vvp
main := main.v
module := main
proj := cpu32

IV = iverilog
VVP = vvp
FLAGS = -v
VVPFLAGS = -iv
VVPEXTFLAGS = -fst

all: clean main

clean:
	rm -fv $(dir)/out/$(proj).vvp

main:
	$(IV) -g$(std) -W$(warn) -y$(dir) -I$(dir) -s$(module) -t$(target) $(FLAGS) -oout/$(proj).vvp $(main)

runonly:
	$(VVP) $(VVPFLAGS) out/$(proj).vvp $(VVPEXTFLAGS)

run: main runonly
