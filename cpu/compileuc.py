#!/usr/bin/python
import sys

infile_name = sys.argv[1]
outvh_name = sys.argv[2]
outv_name = sys.argv[3]

infile = open(infile_name, "r")
outvh = open(outvh_name, "w+")
outv = open(outv_name, "w+")

inlines = infile.readlines()
infile.close()

index = 0
for line in [x.rstrip() for x in inlines]:
    if len(line.strip()) == 0:
        continue
    if line[0] == '\t':
        index += 1
    else:
        outvh.write("`define UC_OFFSET_%s 10'd%d\n" % (line, index))
outvh.close()

outv.write("`include \"alu.vh\"\n")
outv.write("`include \"opcode.vh\"\n")
outv.write("reg [10:0] microprogram_label[0:511];\n")
outv.write("integer mcinit_i;\n")
outv.write("initial begin\n")
outv.write("    for (mcinit_i = 0; mcinit_i < 512; mcinit_i = mcinit_i + 1) microprogram_label[mcinit_i] = 11'b0;\n")
for line in [x.rstrip() for x in inlines]:
    if len(line.strip()) == 0:
        continue
    if not line[0] == '\t':
        if line[0:2] == 'JS':
            outv.write("    microprogram_label[{ 1'b1, `%s }] = { 1'b1, `UC_OFFSET_%s };\n" % (line, line))
        else:
            outv.write("    microprogram_label[{ 1'b0, `%s }] = { 1'b1, `UC_OFFSET_%s };\n" % (line, line))
outv.write("end\n")

outv.write("reg [31:0] microprogram[0:%d];\n" % (index - 1))
outv.write("initial begin\n")
index = 0
for line in [x.rstrip() for x in inlines]:
    if not len(line.strip()) == 0 and line[0] == '\t':
        outv.write("    microprogram[%d] = %s;\n" % (index, line.strip()))
        index += 1
outv.write("end\n")
outv.close()
