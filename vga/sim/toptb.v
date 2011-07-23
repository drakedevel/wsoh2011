`timescale 1ns / 1ps

module toptb();

   reg clk;
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			Hsync;			// From DUT of top.v
   wire [0:7]		Led;			// From DUT of top.v
   wire			Vsync;			// From DUT of top.v
   wire [0:3]		an;			// From DUT of top.v
   wire			dp;			// From DUT of top.v
   wire [0:6]		seg;			// From DUT of top.v
   wire [2:3]		vgaBlue;		// From DUT of top.v
   wire [1:3]		vgaGreen;		// From DUT of top.v
   wire [1:3]		vgaRed;			// From DUT of top.v
   // End of automatics

   always begin
      clk <= 1'b0;
      #10;
      clk <= 1'b1;
      #10;
   end

   initial begin
      $monitor($stime,, "HS=%b VS=%b D=%b%b%b", Hsync, Vsync, vgaRed, vgaGreen, vgaBlue);
      wait (Vsync == 1'b1) begin
	  #10000;$finish();
      end
   end

   top DUT(/*AUTOINST*/
	   // Outputs
	   .Led				(Led[0:7]),
	   .Hsync			(Hsync),
	   .Vsync			(Vsync),
	   .seg				(seg[0:6]),
	   .an				(an[0:3]),
	   .dp				(dp),
	   .vgaRed			(vgaRed[1:3]),
	   .vgaGreen			(vgaGreen[1:3]),
	   .vgaBlue			(vgaBlue[2:3]),
	   // Inputs
	   .clk				(clk));
   
endmodule
// Local Variables:
// verilog-library-flags:("-y ../rtl")
// End: