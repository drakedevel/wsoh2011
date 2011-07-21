`define UC_DONE 1'b0
`define UC_NEXT 1'b1

`define UC_POP(n) n

`define UC_NOPUSH 2'd0
`define UC_PUSHALU 2'd1
`define UC_PUSHIMM 2'd2

`define TYPE_UNDEFINED 3'd0
`define TYPE_INTEGER 3'd1

`define UC_LEFT_IMM 2'd0
`define UC_LEFT_STK0 2'd1
`define UC_LEFT_STK1 2'd2

`define UC_RIGHT_IMM 2'd0
`define UC_RIGHT_STK0 2'd1
`define UC_RIGHT_STK1 2'd2

`define OP_NOP 8'd0
`define OP_PUSHI 8'd1
`define OP_PUSHV 8'd2
`define OP_BITAND 8'd3