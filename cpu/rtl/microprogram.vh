`include "alu.vh"
`include "opcode.vh"
reg [10:0] microprogram_label[0:511];
integer mcinit_i;
initial begin
    for (mcinit_i = 0; mcinit_i < 512; mcinit_i = mcinit_i + 1) microprogram_label[mcinit_i] = 11'b0;
    microprogram_label[{ 1'b1, `JSOP_NOP }] = { 1'b1, `UC_OFFSET_JSOP_NOP };
    microprogram_label[{ 1'b1, `JSOP_GOTO }] = { 1'b1, `UC_OFFSET_JSOP_GOTO };
    microprogram_label[{ 1'b1, `JSOP_IFEQ }] = { 1'b1, `UC_OFFSET_JSOP_IFEQ };
    microprogram_label[{ 1'b1, `JSOP_IFNE }] = { 1'b1, `UC_OFFSET_JSOP_IFNE };
    microprogram_label[{ 1'b1, `JSOP_PUSH }] = { 1'b1, `UC_OFFSET_JSOP_PUSH };
    microprogram_label[{ 1'b1, `JSOP_DUP }] = { 1'b1, `UC_OFFSET_JSOP_DUP };
    microprogram_label[{ 1'b1, `JSOP_DUP2 }] = { 1'b1, `UC_OFFSET_JSOP_DUP2 };
    microprogram_label[{ 1'b1, `JSOP_BITOR }] = { 1'b1, `UC_OFFSET_JSOP_BITOR };
    microprogram_label[{ 1'b1, `JSOP_BITXOR }] = { 1'b1, `UC_OFFSET_JSOP_BITXOR };
    microprogram_label[{ 1'b1, `JSOP_BITAND }] = { 1'b1, `UC_OFFSET_JSOP_BITAND };
    microprogram_label[{ 1'b1, `JSOP_EQ }] = { 1'b1, `UC_OFFSET_JSOP_EQ };
    microprogram_label[{ 1'b1, `JSOP_NE }] = { 1'b1, `UC_OFFSET_JSOP_NE };
    microprogram_label[{ 1'b1, `JSOP_LT }] = { 1'b1, `UC_OFFSET_JSOP_LT };
    microprogram_label[{ 1'b1, `JSOP_LE }] = { 1'b1, `UC_OFFSET_JSOP_LE };
    microprogram_label[{ 1'b1, `JSOP_GT }] = { 1'b1, `UC_OFFSET_JSOP_GT };
    microprogram_label[{ 1'b1, `JSOP_GE }] = { 1'b1, `UC_OFFSET_JSOP_GE };
    microprogram_label[{ 1'b1, `JSOP_LSH }] = { 1'b1, `UC_OFFSET_JSOP_LSH };
    microprogram_label[{ 1'b1, `JSOP_RSH }] = { 1'b1, `UC_OFFSET_JSOP_RSH };
    microprogram_label[{ 1'b1, `JSOP_URSH }] = { 1'b1, `UC_OFFSET_JSOP_URSH };
    microprogram_label[{ 1'b1, `JSOP_ADD }] = { 1'b1, `UC_OFFSET_JSOP_ADD };
    microprogram_label[{ 1'b1, `JSOP_SUB }] = { 1'b1, `UC_OFFSET_JSOP_SUB };
    microprogram_label[{ 1'b0, `OP_NOP }] = { 1'b1, `UC_OFFSET_OP_NOP };
    microprogram_label[{ 1'b0, `OP_PUSHI }] = { 1'b1, `UC_OFFSET_OP_PUSHI };
    microprogram_label[{ 1'b0, `OP_PUSHV }] = { 1'b1, `UC_OFFSET_OP_PUSHV };
    microprogram_label[{ 1'b0, `OP_BITAND }] = { 1'b1, `UC_OFFSET_OP_BITAND };
    microprogram_label[{ 1'b0, `OP_GOTO }] = { 1'b1, `UC_OFFSET_OP_GOTO };
end
reg [31:0] microprogram[0:27];
initial begin
    microprogram[0] = { 32'b0 };
    microprogram[1] = { 16'b0, `UC_BR_NONE, `UC_NOPUSH, `UC_POP(2'b0), `ALU_LEFT, `UC_DONE };
    microprogram[2] = { 16'b0, `UC_BR_REL, `UC_LEFT_IMM, `UC_RIGHT_IMM, `UC_NOPUSH, `UC_POP(2'd0), `ALU_LEFT, `UC_DONE };
    microprogram[3] = { 16'b0, `UC_BR_REL_COND, `UC_LEFT_STK0, `UC_RIGHT_IMM, `UC_NOPUSH, `UC_POP(2'd0), `ALU_LEFT_EQZ, `UC_DONE };
    microprogram[4] = { 16'b0, `UC_BR_REL_COND, `UC_LEFT_STK0, `UC_RIGHT_IMM, `UC_NOPUSH, `UC_POP(2'd0), `ALU_LEFT_NEZ, `UC_DONE };
    microprogram[5] = { 16'b0, `UC_BR_NONE, `UC_LEFT_IMM, `UC_RIGHT_IMM, `UC_PUSHIMM, `UC_POP(2'd0), `ALU_LEFT, `UC_DONE };
    microprogram[6] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_IMM, `UC_PUSHALU, `UC_POP(2'd0), `ALU_LEFT, `UC_DONE };
    microprogram[7] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK1, `UC_RIGHT_IMM, `UC_PUSHALU, `UC_POP(2'd0), `ALU_LEFT, `UC_NEXT };
    microprogram[8] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK1, `UC_RIGHT_IMM, `UC_PUSHALU, `UC_POP(2'd0), `ALU_LEFT, `UC_DONE };
    microprogram[9] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_BITOR, `UC_DONE };
    microprogram[10] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_BITXOR, `UC_DONE };
    microprogram[11] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_BITAND, `UC_DONE };
    microprogram[12] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_EQ, `UC_DONE };
    microprogram[13] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_NE, `UC_DONE };
    microprogram[14] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_LT, `UC_DONE };
    microprogram[15] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_LE, `UC_DONE };
    microprogram[16] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_GT, `UC_DONE };
    microprogram[17] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_GE, `UC_DONE };
    microprogram[18] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_LSH, `UC_DONE };
    microprogram[19] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_RSH, `UC_DONE };
    microprogram[20] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_URSH, `UC_DONE };
    microprogram[21] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_ADD, `UC_DONE };
    microprogram[22] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_SUB, `UC_DONE };
    microprogram[23] = { 31'b0, `UC_DONE };
    microprogram[24] = { 16'b0, `UC_BR_NONE, `UC_LEFT_IMM, `UC_RIGHT_IMM, `UC_PUSHALU, `UC_POP(2'd0), `ALU_LEFT, `UC_DONE };
    microprogram[25] = { 16'b0, `UC_BR_NONE, `UC_LEFT_IMM, `UC_RIGHT_IMM, `UC_PUSHIMM, `UC_POP(2'd0), `ALU_LEFT, `UC_DONE };
    microprogram[26] = { 16'b0, `UC_BR_NONE, `UC_LEFT_STK0, `UC_RIGHT_STK1, `UC_PUSHALU, `UC_POP(2'd2), `ALU_BITAND, `UC_DONE };
    microprogram[27] = { 16'b0, `UC_BR_REL, `UC_LEFT_IMM, `UC_RIGHT_IMM, `UC_NOPUSH, `UC_POP(2'd0), `ALU_LEFT, `UC_DONE };
end
