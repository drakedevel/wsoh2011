module vga_core(/*AUTOARG*/
   // Outputs
   Hsync, Vsync, vgaRed, vgaGreen, vgaBlue, vg__stall,
   // Inputs
   clk, rst_b, vg__color
   );
   parameter HOR_BITS = 11;
   parameter VER_BITS = 10;
   parameter HOR_ADDR = 800;
   parameter HOR_BLANK = 240;
   parameter HOR_TOTAL = HOR_ADDR + HOR_BLANK;
   parameter VER_ADDR = 600;
   parameter VER_BLANK = 66;
   parameter VER_TOTAL = VER_ADDR + VER_BLANK;
   parameter HSYNC_START = 856;
   parameter HSYNC_LENGTH = 120;
   parameter VSYNC_START = 637;
   parameter VSYNC_LENGTH = 6;

   output reg 	     Hsync;
   output reg 	     Vsync; 
   output [1:3]      vgaRed;
   output [1:3]      vgaGreen;
   output [2:3]      vgaBlue;
   output 	     vg__stall;
   input 	     clk;
   input 	     rst_b;
   input [7:0] 	     vg__color;

   reg [HOR_BITS-1:0] h_addr;
   reg [VER_BITS-1:0] v_addr;

   assign vg__stall = (h_addr >= HOR_ADDR || v_addr >= VER_ADDR);
   assign { vgaRed, vgaGreen, vgaBlue } = vg__stall ? 8'b0 : vg__color;

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 Hsync <= 1'h0;
	 Vsync <= 1'h0;
	 h_addr <= {HOR_BITS{1'b0}};
	 v_addr <= {VER_BITS{1'b0}};
	 // End of automatics
      end else begin
	 if (h_addr == (HOR_TOTAL - 1)) begin
	    h_addr <= {HOR_BITS{1'b0}};
	    if (v_addr == (VER_TOTAL - 1))
	      v_addr <= {VER_BITS{1'b0}};
	    else
	      v_addr <= v_addr + 1;
	 end else begin
	    h_addr <= h_addr + 1;
	 end

	 Hsync <= (HSYNC_START <= h_addr && h_addr < (HSYNC_START + HSYNC_LENGTH));
	 Vsync <= (VSYNC_START <= v_addr && v_addr < (VSYNC_START + VSYNC_LENGTH));
      end
   end
endmodule
