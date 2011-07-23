`timescale 1ns / 1ps
`include "opcode.vh"
`include "jsopcode.vh"
module tb();

   reg        clk, rst_b;
   reg [47:0] hatch_instruction;
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]		hatch_address;		// From DUT of cpu.v
   // End of automatics

   always begin
      clk <= 1'b0;
      #10;
      clk <= 1'b1;
      #10;
   end

   initial begin
      rst_b = 1'b0;
      #25;
      rst_b = 1'b1;

      wait (hatch_address == 32'h00000000) hatch_instruction = { `OP_GOTO, 8'b0, 16'h0, 16'h0007 };
      wait (hatch_address == 32'h00000007) hatch_instruction = { `JSOP_PUSH, 8'b1, 32'h00001001 };
      wait (hatch_address == 32'h0000000d) hatch_instruction = { `JSOP_PUSH, 8'b1, 32'h1337D00D };
      wait (hatch_address == 32'h00000013) hatch_instruction = { `JSOP_CALL, 8'b1, 32'h00000001 };
      wait (hatch_address == 32'h00000019) hatch_instruction = { `JSOP_NOP, 8'b0, 32'h0 };

      wait (hatch_address == 32'h00001001) hatch_instruction = { `JSOP_PUSH, 8'b1, 32'h15410AAA };
      wait (hatch_address == 32'h00001007) hatch_instruction = { `JSOP_RETURN, 8'b0, 32'h0 };
      wait (hatch_address == 32'h00000019) hatch_instruction = { `JSOP_NOP, 8'b0, 32'h0 };

      #1000;
/*
      wait (hatch_address == 32'h0000101F) hatch_instruction = { `JSOP_NOP, 8'b0, 32'h0 };

      wait (hatch_address == 32'h00000013) hatch_instruction = { `JSOP_NOP, 8'b0, 32'h0 };
*/
/*
      wait (hatch_address == 32'h00000018) hatch_instruction = { `OP_BITAND, 8'b0, 32'h0 };
      wait (hatch_address == 32'h0000001e) hatch_instruction = { `OP_NOP, 8'b0, 32'b0 };
*/
      $finish();
   end

   cpu DUT(/*AUTOINST*/
	   // Outputs
	   .hatch_address		(hatch_address[31:0]),
	   // Inputs
	   .clk				(clk),
	   .hatch_instruction		(hatch_instruction[47:0]),
	   .rst_b			(rst_b));
   
endmodule
// Local Variables:
// verilog-library-flags:("-y ../rtl")
// End:
