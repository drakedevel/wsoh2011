`define UC_DONE 1'b0
`define UC_NEXT 1'b1

`define UC_POP

`define UC_NOPUSH 3'd0
`define UC_PUSHALU 3'd1
`define UC_PUSHIMM 3'd2
`define UC_PUSHREG0 3'd3
`define UC_PUSHREG1 3'd4

`define TYPE_UNDEFINED 3'd0
`define TYPE_INTEGER 3'd1

`define UC_LEFT_IMM 2'd0
`define UC_LEFT_STK0 2'd1
`define UC_LEFT_STK1 2'd2
`define UC_LEFT_PC 2'd3

`define UC_RIGHT_IMM 2'd0
`define UC_RIGHT_STK0 2'd1
`define UC_RIGHT_STK1 2'd2
`define UC_RIGHT_R1 2'd3

`define UC_BR_NONE 2'd0
`define UC_BR_REL 2'd1
`define UC_BR_REL_COND 2'd2
`define UC_BR_ALU 2'd3

`define UC_R1_NOP 1'd0
`define UC_R1_STORE 1'd1

`define UC_R0_NOP 1'd0
`define UC_R0_STORE 1'd1

`define UC_TOPN_1 2'd0
`define UC_TOPN_IMM 2'd1
`define UC_TOPN_IMMREG 2'd2

`define OP_NOP 8'd0
`define OP_PUSHI 8'd1
`define OP_PUSHV 8'd2
`define OP_BITAND 8'd3
`define OP_GOTO 8'd4
