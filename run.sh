#!/bin/bash
if [[ ! -d "out/" ]]; then
	mkdir out
fi
iverilog -g2012 -Wall -smain -tvvp -v -oout/cpu32.vvp main.v
pushd out > /dev/null
vvp -iv cpu32.vvp -fst
popd > /dev/null
