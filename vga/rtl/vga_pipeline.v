module vga_pipeline(/*AUTOARG*/
   // Outputs
   vg__color,
   // Inputs
   clk, rst_b, st__data, vg__addr, vg__rect_write, vg__stall
   );
   parameter WIDTH = 800;
   parameter HEIGHT = 600;
   parameter WIDTHBITS = 10;
   parameter HEIGHTBITS = 10;
   parameter COLORBITS = 8;
   parameter RECTBITS = 6;
   
   /// INTERFACE ///
   
   output [COLORBITS-1:0] vg__color;
   input 		  clk, rst_b;
   input [31:0]           st__data;
   input [RECTBITS:0]     vg__addr;
   input 		  vg__rect_write;
   input 		  vg__stall;

   /// INTERNAL SIGNALS ///
   
   wire [COLORBITS-1:0]   color[0:1];
   wire [WIDTHBITS-1:0]   x[0:1];
   wire [HEIGHTBITS-1:0]  y[0:1];

   reg [WIDTHBITS-1:0] 	  x_counter;
   reg [HEIGHTBITS-1:0]   y_counter;

   /// LOGIC ///

   assign color[0] = 8'h00;
   assign vg__color = color[1];

   assign x[0] = x_counter;
   assign y[0] = y_counter;

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 x_counter <= {WIDTHBITS{1'b0}};
	 y_counter <= {HEIGHTBITS{1'b0}};
	 // End of automatics
      end else begin
	 if (!vg__stall) begin
	    if (x_counter == (WIDTH - 1)) begin
	       x_counter <= 0;

	       if (y_counter == (HEIGHT - 1))
		 y_counter <= 0;
	       else
		 y_counter <= y_counter + 1;
	    end else begin
	       x_counter <= x_counter + 1;
	    end
	 end
      end
   end

   /// MODULE INSTANCES ///
   
   vga_stage_rectangle #(WIDTHBITS,HEIGHTBITS,COLORBITS,RECTBITS)
   RectangleStage(.st__conf_multi_index(vg__addr[RECTBITS:1]),
		  .st__a0		(vg__addr[0]),
		  .st__color_0a(color[0]),
		  .st__color_1a(color[1]),
		  .st__x_0a(x[0]),
		  .st__x_1a(x[1]),
		  .st__y_0a(y[0]),
		  .st__y_1a(y[1]),
		  /*AUTOINST*/
		  // Inputs
		  .clk			(clk),
		  .rst_b		(rst_b),
		  .st__data		(st__data[31:0]),
		  .vg__rect_write	(vg__rect_write),
		  .vg__stall		(vg__stall));

endmodule
