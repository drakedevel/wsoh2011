`timescale 1ns / 1ps
`include "opcode.vh"
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

      wait (hatch_address == 32'h00000000) hatch_instruction = { `OP_PUSHI, 8'b0, 32'h1337D00D };
      wait (hatch_address == 32'h00000004) hatch_instruction = { `OP_PUSHI, 8'b0, 32'hCAFEBABE };
      wait (hatch_address == 32'h00000008) hatch_instruction = { `OP_BITAND, 8'b0, 32'h0 };
      wait (hatch_address == 32'h0000000c) hatch_instruction = { `OP_NOP, 8'b0, 32'h0 };
      #1000;
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
