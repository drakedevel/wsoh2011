#!/bin/bash

cd $(dirname "$0")
ncverilog -incdir cpu/rtl/ cpu/sim/tb.v {cpu,vga}/rtl/*.v

