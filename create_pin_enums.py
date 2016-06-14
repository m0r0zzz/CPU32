#!/usr/bin/python

pins = open("pins.txt", "w+")

for i in range(0, 128):
	string = "\t. \\pins[" + str(i) + "] (pins[" + str(i) + "]),\n"
	pins.write(string)

for n in "insn", "sp", "lr", "pc", "st":
	for i in range(0, 32):
		string = "\t. \\" + n + "[" + str(i) + "] (" + n + "[" + str(i) + "]),\n"
		pins.write(string)

pins.write(".clk(clk),\n")
pins.write(".rst(rst)\n")

pins.close()
