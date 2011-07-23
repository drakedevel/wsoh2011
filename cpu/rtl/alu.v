`include "alu.vh"

module alu(/*AUTOARG*/
   // Outputs
   alu__cond, alu__out,
   // Inputs
   alu__left, alu__right, alu__op
   );

   output             alu__cond;
   output reg [31:0]  alu__out;
   input [31:0]       alu__left;
   input [31:0]       alu__right;
   input [4:0] 	      alu__op;

   wire signed [31:0] alu__left_s;
   
   /// COMBINATIONAL LOGIC ///

   assign alu__cond = alu__out[0];
   assign alu__left_s = alu__left;
   
   always @* begin
      case (alu__op)
	`ALU_LEFT:
	  alu__out = alu__left;
	`ALU_RIGHT:
	  alu__out = alu__right;
	`ALU_BITOR:
	  alu__out = alu__left | alu__right;
	`ALU_BITXOR:
	  alu__out = alu__left ^ alu__right;
	`ALU_BITAND:
	  alu__out = alu__left & alu__right;
	`ALU_EQ:
	  alu__out = alu__left == alu__right ? { 31'b0, 1'b1 } : 32'b0;
	`ALU_NE:
	  alu__out = alu__left != alu__right ? { 31'b0, 1'b1 } : 32'b0;
	`ALU_LT:
	  alu__out = alu__left < alu__right ? { 31'b0, 1'b1 } : 32'b0;
	`ALU_LE:
	  alu__out = alu__left <= alu__right ? { 31'b0, 1'b1 } : 32'b0;
	`ALU_GT:
	  alu__out = alu__left > alu__right ? { 31'b0, 1'b1 } : 32'b0;
	`ALU_GE:
	  alu__out = alu__left >= alu__right ? { 31'b0, 1'b1 } : 32'b0;
	`ALU_LSH:
	  alu__out = alu__left << alu__right;
	`ALU_RSH:
	  alu__out = alu__left_s >> alu__right;
	`ALU_URSH:
	  alu__out = alu__left >> alu__right;
	`ALU_ADD:
	  alu__out = alu__left + alu__right;
	`ALU_SUB:
	  alu__out = alu__left - alu__right;
	`ALU_LEFT_EQZ:
	  alu__out = alu__left == 0 ? { 31'b0, 1'b1 } : 32'b0;
	`ALU_LEFT_NEZ:
	  alu__out = alu__left != 0 ? { 31'b0, 1'b1 } : 32'b0;
	default:
	  alu__out = 32'bx;
      endcase
   end
   
endmodule