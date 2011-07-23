module vga_unit(/*AUTOARG*/
   // Outputs
   Hsync, Vsync, vgaRed, vgaGreen, vgaBlue,
   // Inputs
   clk, rst_b, vg__data, vg__addr, vg__write
   );

   parameter WIDTH = 800;
   parameter HEIGHT = 600;
   parameter WIDTHBITS = 10;
   parameter HEIGHTBITS = 10;
   parameter COLORBITS = 8;
   parameter RECTBITS = 6;

   /// INTERFACE ///

   output 		Hsync;
   output 		Vsync; 
   output [1:3] 	vgaRed;
   output [1:3] 	vgaGreen;
   output [2:3] 	vgaBlue;
   input 		clk;
   input                rst_b;
   input [31:0]         vg__data;
   input [RECTBITS:0]   vg__addr;
   input                vg__write;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [COLORBITS-1:0]	vg__color;		// From Video of vga_pipeline.v
   wire			vg__stall;		// From VGA of vga_core.v
   // End of automatics
 
   /// MODULE INSTANCES ///

   vga_core VGA(/*AUTOINST*/
		// Outputs
		.Hsync			(Hsync),
		.Vsync			(Vsync),
		.vgaRed			(vgaRed[1:3]),
		.vgaGreen		(vgaGreen[1:3]),
		.vgaBlue		(vgaBlue[2:3]),
		.vg__stall		(vg__stall),
		// Inputs
		.clk			(clk),
		.rst_b			(rst_b),
		.vg__color		(vg__color[7:0]));

   vga_pipeline #(WIDTH, HEIGHT, WIDTHBITS, HEIGHTBITS, COLORBITS, RECTBITS)
   Video(.vg__rect_write		(vg__write),
	 .st__data			(vg__data),
         /*AUTOINST*/
	 // Outputs
	 .vg__color			(vg__color[COLORBITS-1:0]),
	 // Inputs
	 .clk				(clk),
	 .rst_b				(rst_b),
	 .vg__addr			(vg__addr[RECTBITS:0]),
	 .vg__stall			(vg__stall));
endmodule
