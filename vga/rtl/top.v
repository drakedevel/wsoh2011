module top(/*AUTOARG*/
   // Outputs
   Led, Hsync, Vsync, seg, an, dp, vgaRed, vgaGreen, vgaBlue,
   // Inputs
   clk
   );

   parameter WIDTH = 800;
   parameter HEIGHT = 600;
   parameter WIDTHBITS = 10;
   parameter HEIGHTBITS = 10;
   parameter COLORBITS = 8;
   parameter RECTBITS = 6;

   localparam
     STATE_TL_START = 2'd0,
     STATE_TL_WAIT = 2'd1,
     STATE_BR_START = 2'd2,
     STATE_BR_WAIT = 2'd3;
   
   /// INTERFACE ///

   output [0:7]         Led;
   output 		Hsync;
   output 		Vsync; 
   output [0:6] 	seg;
   output [0:3] 	an;
   output 		dp;
   output [1:3] 	vgaRed;
   output [1:3] 	vgaGreen;
   output [2:3] 	vgaBlue;
   input 		clk;

   /// INTERNAL SIGNALS ///

   reg [26:0] 		counter;
   reg [1:0] 		state;
   reg 			rst_b = 1'b0;

   reg [COLORBITS-1:0] 	st__conf_color;
   reg 			st__conf_enabled;
   reg [WIDTHBITS-1:0] 	st__conf_rect_x1;
   reg [WIDTHBITS-1:0] 	st__conf_rect_x2;
   reg [HEIGHTBITS-1:0] st__conf_rect_y1;
   reg [HEIGHTBITS-1:0] st__conf_rect_y2;
   reg [RECTBITS-1:0] 	vg__rect_index;
   reg 			vg__rect_write;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [COLORBITS-1:0]	vg__color;		// From Video of vga_pipeline.v
   wire			vg__stall;		// From VGA of vga_core.v
   // End of automatics
 
   assign Led = 8'h0;
   assign seg = 7'h7f;
   assign an = 4'hf;
   assign dp = 1'b1;
 
   always @(posedge clk) begin
      if (!rst_b)
	rst_b <= 1'b1;
   end
   
   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 counter <= 27'h0;
	 st__conf_color <= {COLORBITS{1'b0}};
	 st__conf_enabled <= 1'h0;
	 st__conf_rect_x1 <= {WIDTHBITS{1'b0}};
	 st__conf_rect_x2 <= {WIDTHBITS{1'b0}};
	 st__conf_rect_y1 <= {HEIGHTBITS{1'b0}};
	 st__conf_rect_y2 <= {HEIGHTBITS{1'b0}};
	 state <= 2'h0;
	 vg__rect_index <= {RECTBITS{1'b0}};
	 vg__rect_write <= 1'h0;
	 // End of automatics
      end else begin
	 counter <= counter + 1;
	 case (state)
	   STATE_TL_START: begin
	      state <= STATE_TL_WAIT;
	      st__conf_enabled <= 1'b1;
	      st__conf_color <= 8'b11100000;
	      st__conf_rect_x1 <= 10'd0;
	      st__conf_rect_x2 <= 10'd399;
	      st__conf_rect_y1 <= 10'd0;
	      st__conf_rect_y2 <= 10'd299;
	      vg__rect_index <= 6'b0;
	      vg__rect_write <= 1'b1;
	   end
	   STATE_TL_WAIT: begin
	      vg__rect_write <= 1'b0;	      
	      if (counter == 27'b0)
		state <= STATE_BR_START;
	   end
	   STATE_BR_START: begin
	      state <= STATE_BR_WAIT;
	      st__conf_enabled <= 1'b1;
	      st__conf_color <= 8'b00000011;
	      st__conf_rect_x1 <= 10'd400;
	      st__conf_rect_x2 <= 10'd799;
	      st__conf_rect_y1 <= 10'd300;
	      st__conf_rect_y2 <= 10'd599;
	      vg__rect_index <= 6'b0;
	      vg__rect_write <= 1'b1;
	   end
	   STATE_BR_WAIT: begin
	      vg__rect_write <= 1'b0;
	      if (counter == 27'b0)
		state <= STATE_TL_START;
	   end
	 endcase
      end
   end

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
   Video(/*AUTOINST*/
	 // Outputs
	 .vg__color			(vg__color[COLORBITS-1:0]),
	 // Inputs
	 .clk				(clk),
	 .rst_b				(rst_b),
	 .st__conf_color		(st__conf_color[COLORBITS-1:0]),
	 .st__conf_enabled		(st__conf_enabled),
	 .st__conf_rect_x1		(st__conf_rect_x1[WIDTHBITS-1:0]),
	 .st__conf_rect_x2		(st__conf_rect_x2[WIDTHBITS-1:0]),
	 .st__conf_rect_y1		(st__conf_rect_y1[HEIGHTBITS-1:0]),
	 .st__conf_rect_y2		(st__conf_rect_y2[HEIGHTBITS-1:0]),
	 .vg__rect_index		(vg__rect_index[RECTBITS-1:0]),
	 .vg__rect_write		(vg__rect_write),
	 .vg__stall			(vg__stall));
endmodule
