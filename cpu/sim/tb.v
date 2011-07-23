`timescale 1ns / 1ps
`include "opcode.vh"
`include "jsopcode.vh"
module tb();

   reg        clk, rst_b;
   wire [47:0] hatch_instruction;
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]		hatch_address;		// From DUT of cpu.v
   wire [10:0]		st__saved_pc_3a;	// From DUT of cpu.v
   wire [10:0]		st__sp_2a;		// From DUT of cpu.v
   // End of automatics

   reg [31:0] 		funtab [0:127];
   reg [47:0] 		instructions [0:127];
   reg [10:0] 		st__saved_pc_2a, st__saved_sp_3a;

   always begin
      clk <= 1'b0;
      #10;
      clk <= 1'b1;
      #10;
   end

   initial $readmemh("funtab.hex", funtab);
   initial $readmemh("jsops.hex", instructions);

   assign hatch_instruction = instructions[hatch_address / 6];
   
   initial begin
      rst_b = 1'b0;
      #25;
      rst_b = 1'b1;

/*      
      wait (hatch_address == 32'h00000000) hatch_instruction = { `OP_GOTO, 8'b0, 16'h0, 16'h0007 };
      wait (hatch_address == 32'h00000007) hatch_instruction = { `JSOP_PUSH, 8'b1, 32'h00001001 };
      wait (hatch_address == 32'h0000000d) hatch_instruction = { `JSOP_PUSH, 8'b1, 32'h1337D00D };
      wait (hatch_address == 32'h00000013) hatch_instruction = { `JSOP_CALL, 8'b1, 32'h00000001 };
      wait (hatch_address == 32'h00000019) hatch_instruction = { `JSOP_NOP, 8'b0, 32'h0 };

      wait (hatch_address == 32'h00001001) hatch_instruction = { `JSOP_PUSH, 8'b1, 32'h15410AAA };
 */
/*
      wait (hatch_address == 32'h00001007) hatch_instruction = { `JSOP_RETURN, 8'b0, 32'h0 };
      wait (hatch_address == 32'h0000101F) hatch_instruction = { `JSOP_NOP, 8'b0, 32'h0 };

      wait (hatch_address == 32'h00000013) hatch_instruction = { `JSOP_NOP, 8'b0, 32'h0 };
*/
/*
      wait (hatch_address == 32'h00000018) hatch_instruction = { `OP_BITAND, 8'b0, 32'h0 };
      wait (hatch_address == 32'h0000001e) hatch_instruction = { `OP_NOP, 8'b0, 32'b0 };
*/
      #1000;
      $finish();
   end

   cpu DUT(/*AUTOINST*/
	   // Outputs
	   .hatch_address		(hatch_address[31:0]),
	   .st__saved_pc_3a		(st__saved_pc_3a[10:0]),
	   .st__sp_2a			(st__sp_2a[10:0]),
	   // Inputs
	   .clk				(clk),
	   .hatch_instruction		(hatch_instruction[47:0]),
	   .rst_b			(rst_b),
	   .st__saved_pc_2a		(st__saved_pc_2a[10:0]),
	   .st__saved_sp_3a		(st__saved_sp_3a[10:0]));
   
endmodule
// Local Variables:
// verilog-library-flags:("-y ../rtl")
// End:
