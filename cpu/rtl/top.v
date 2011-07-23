module top(/*AUTOARG*/
   // Outputs
   vgaRed, vgaGreen, vgaBlue, st__sp_2a, leds, hatch_address, Vsync,
   Hsync,
   // Inputs
   switches, st__saved_sp_3a, rst_b, clk
   );

   wire [47:0] hatch_instruction;
   
   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		Hsync;			// From CPU of cpu.v
   output		Vsync;			// From CPU of cpu.v
   output [31:0]	hatch_address;		// From CPU of cpu.v
   output [7:0]		leds;			// From CPU of cpu.v
   output [10:0]	st__sp_2a;		// From CPU of cpu.v
   output [2:3]		vgaBlue;		// From CPU of cpu.v
   output [1:3]		vgaGreen;		// From CPU of cpu.v
   output [1:3]		vgaRed;			// From CPU of cpu.v
   // End of automatics
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		clk;			// To CPU of cpu.v
   input		rst_b;			// To CPU of cpu.v
   input [10:0]		st__saved_sp_3a;	// To CPU of cpu.v
   input [7:0]		switches;		// To CPU of cpu.v
   // End of automatics

   reg [47:0] 		hatch_memory [0:255];

   initial $readmemh("jsops.hex", hatch_memory);

   assign hatch_instruction = hatch_memory[hatch_address / 6];
   
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