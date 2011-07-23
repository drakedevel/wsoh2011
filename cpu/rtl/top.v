module top(/*AUTOARG*/
   // Outputs
   Hsync, Vsync, leds, vgaBlue, vgaGreen, vgaRed,
   // Inputs
   clk, rst_b, switches
   );

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]		hatch_address;		// From CPU of cpu.v
   wire [10:0]		st__sp_2a;		// From CPU of cpu.v
   // End of automatics
   wire [47:0] 		hatch_instruction;
   wire [10:0] 	st__saved_sp_3a;	// To CPU of cpu.v
   
   output       Hsync;			// From CPU of cpu.v
   output 	Vsync;			// From CPU of cpu.v
   output [7:0] leds;			// From CPU of cpu.v
   output [2:3] vgaBlue;		// From CPU of cpu.v
   output [1:3] vgaGreen;		// From CPU of cpu.v
   output [1:3] vgaRed;			// From CPU of cpu.v
   input 	clk;			// To CPU of cpu.v
   input 	rst_b;			// To CPU of cpu.v
   input [7:0] 	switches;		// To CPU of cpu.v

   reg [47:0] 	hatch_memory [0:191];
   
   initial begin
      $readmemh("jsops.hex", hatch_memory);
   end

   assign hatch_instruction = hatch_memory[hatch_address / 2];
   
   cpu CPU(/*AUTOINST*/
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
	   .rst_b			(rst_b),
	   .st__saved_sp_3a		(st__saved_sp_3a[10:0]),
	   .switches			(switches[7:0]));
endmodule