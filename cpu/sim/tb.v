`timescale 1ns / 1ps
`include "opcode.vh"
`include "jsopcode.vh"
module tb();

   reg        clk, rst_b;
   wire [47:0] hatch_instruction;
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			Hsync;			// From DUT of cpu.v
   wire			Vsync;			// From DUT of cpu.v
   wire [31:0]		hatch_address;		// From DUT of cpu.v
   wire [7:0]		leds;			// From DUT of cpu.v
   wire [10:0]		st__sp_2a;		// From DUT of cpu.v
   wire [2:3]		vgaBlue;		// From DUT of cpu.v
   wire [1:3]		vgaGreen;		// From DUT of cpu.v
   wire [1:3]		vgaRed;			// From DUT of cpu.v
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

      #1000;

      $finish();
   end

   cpu DUT(/*AUTOINST*/
	   // Outputs
	   .Hsync			(Hsync),
	   .Vsync			(Vsync),
	   .hatch_address		(hatch_address[31:0]),
	   .leds			(leds[7:0]),
	   .st__sp_2a			(st__sp_2a[10:0]),
	   .vgaBlue			(vgaBlue[2:3]),
	   .vgaGreen			(vgaGreen[1:3]),
	   .vgaRed			(vgaRed[1:3]),
	   // Inputs
	   .clk				(clk),
	   .hatch_instruction		(hatch_instruction[47:0]),
	   .rst_b			(rst_b));
   
endmodule
// Local Variables:
// verilog-library-flags:("-y ../rtl")
// End:
