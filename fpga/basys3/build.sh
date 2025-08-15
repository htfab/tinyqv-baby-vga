#!/bin/bash
f4pga -vv build --flow baby-vga-basys3.json
mkdir -p build/log
mv *.log build/log/
cp build/basys3/fpga_top.bit baby_vga.bit
