module vga_stage_rectangle(/*AUTOARG*/
   // Outputs
   st__color_1a, st__x_1a, st__y_1a,
   // Inputs
   clk, rst_b, st__color_0a, st__x_0a, st__y_0a, st__conf_multi_index,
   st__conf_enabled, st__conf_color, st__conf_rect_x1,
   st__conf_rect_y1, st__conf_rect_x2, st__conf_rect_y2,
   vg__rect_write, vg__stall
   );

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
   input 		       st__conf_enabled;
   input [COLORBITS-1:0]       st__conf_color;
   input [WIDTHBITS-1:0]       st__conf_rect_x1;
   input [HEIGHTBITS-1:0]      st__conf_rect_y1;
   input [WIDTHBITS-1:0]       st__conf_rect_x2;
   input [HEIGHTBITS-1:0]      st__conf_rect_y2;
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
		  enabled[i] <= st__conf_enabled;
		  color[i] <= st__conf_color;
		  rect_x1[i] <= st__conf_rect_x1;
		  rect_x2[i] <= st__conf_rect_x2;
		  rect_y1[i] <= st__conf_rect_y1;
		  rect_y2[i] <= st__conf_rect_y2;
	       end
	    end
	 end
      end
   endgenerate
endmodule