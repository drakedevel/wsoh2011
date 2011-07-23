module vga_stage_rectangle(/*AUTOARG*/
   // Outputs
   st__color_1a, st__x_1a, st__y_1a,
   // Inputs
   clk, rst_b, st__color_0a, st__x_0a, st__y_0a, st__conf_multi_index,
   st__a0, st__data, vg__rect_write, vg__stall
   );

   /*
    * R0[9:0]	x1
    * R0[19:10] y1
    * R0[27:20] color
    * R0[28]    enabled
    * R1[9:0]   x2
    * R1[19:10] y2
    */

   parameter WIDTHBITS = 10;
   parameter HEIGHTBITS = 10;
   parameter COLORBITS = 8;
   parameter MULTIBITS = 5;

   output reg [COLORBITS-1:0]  st__color_1a;
   output reg [WIDTHBITS-1:0]  st__x_1a;
   output reg [HEIGHTBITS-1:0] st__y_1a;
   input 		       clk;
   input 		       rst_b;
   input [COLORBITS-1:0]       st__color_0a;
   input [WIDTHBITS-1:0]       st__x_0a;
   input [HEIGHTBITS-1:0]      st__y_0a;
   input [MULTIBITS-1:0]       st__conf_multi_index;
   input                       st__a0;
   input [31:0]                st__data;
   input 		       vg__rect_write;
   input 		       vg__stall;

   reg [COLORBITS-1:0] 	       color [0:2**MULTIBITS-1];
   reg 			       enabled[0:2**MULTIBITS-1];
   reg [WIDTHBITS-1:0] 	       rect_x1[0:2**MULTIBITS-1];
   reg [WIDTHBITS-1:0] 	       rect_x2[0:2**MULTIBITS-1];
   reg [HEIGHTBITS-1:0]        rect_y1[0:2**MULTIBITS-1];
   reg [HEIGHTBITS-1:0]        rect_y2[0:2**MULTIBITS-1];

   wire [0:2**MULTIBITS-1]     valid_bus;
   wire [COLORBITS-1:0]        color_bus[0:2**MULTIBITS];

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 st__color_1a <= {COLORBITS{1'b0}};
	 st__x_1a <= {WIDTHBITS{1'b0}};
	 st__y_1a <= {HEIGHTBITS{1'b0}};
	 // End of automatics
      end else begin
	 if (!vg__stall) begin
	    st__color_1a <= (|valid_bus) ? color_bus[2**MULTIBITS] : st__color_0a;
	    st__x_1a <= st__x_0a;
	    st__y_1a <= st__y_0a;
	 end
      end
   end
   
   assign color_bus[0] = {COLORBITS{1'b0}};
   generate
      genvar 		       i;
      for (i = 1; i <= 2**MULTIBITS; i = i + 1) begin : buses
	 assign valid_bus[i-1] = enabled[i-1] &&
				 rect_x1[i-1] <= st__x_0a && st__x_0a <= rect_x2[i-1] &&
				 rect_y1[i-1] <= st__y_0a && st__y_0a <= rect_y2[i-1];
	 assign color_bus[i] = valid_bus[i-1] ? (color[i-1] | color_bus[i-1]) : color_bus[i-1];
      end
      for (i = 0; i < 2**MULTIBITS; i = i + 1) begin : registers
	 always @(posedge clk or negedge rst_b) begin
	    if (!rst_b) begin
	       enabled[i] <= 1'h0;
	    end else begin
	       if (vg__rect_write && st__conf_multi_index == i) begin
                  if (st__a0 == 1'b0) begin
		     rect_x1[i] <= st__data[9:0];
		     rect_y1[i] <= st__data[19:10];
		     color[i] <= st__data[27:20];
		     enabled[i] <= st__data[28];
                  end else begin
		     rect_x2[i] <= st__data[9:0];
		     rect_y2[i] <= st__data[19:10];
                  end
	       end
	    end
	 end
      end
   endgenerate
endmodule
