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
     STATE_TL_A0 = 3'd0,
     STATE_TL_A1 = 3'd1,
     STATE_TL_WAIT = 3'd2,
     STATE_BR_A0 = 3'd3,
     STATE_BR_A1 = 3'd4,
     STATE_BR_WAIT = 3'd5;
   
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

   reg [31:0]           vg__data;
   reg [RECTBITS:0] 	vg__addr;
   reg 			vg__rect_write;
   
   /*AUTOWIRE*/
 
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
	 state <= 2'h0;
	 vg__addr <= {(1+(RECTBITS)){1'b0}};
	 vg__data <= 32'h0;
	 vg__rect_write <= 1'h0;
	 // End of automatics
      end else begin
	 counter <= counter + 1;
	 case (state)
	   STATE_TL_A0: begin
	      state <= STATE_TL_A1;
                        // padding, enable, color, y1, x1
              vg__data <= { 3'h0, 1'b1, 8'b11100000, 10'd0, 10'd0 };
	      vg__addr <= 7'd0;
	      vg__rect_write <= 1'b1;
	   end
           STATE_TL_A1: begin
	      state <= STATE_TL_WAIT;
                        // padding, y2, x2
              vg__data <= { 12'h000, 10'd299, 10'd399 };
	      vg__addr <= 7'd1;
	      vg__rect_write <= 1'b1;
	   end
	   STATE_TL_WAIT: begin
	      vg__rect_write <= 1'b0;	      
	      if (counter == 27'b0)
		state <= STATE_BR_A0;
	   end
	   STATE_BR_A0: begin
	      state <= STATE_BR_A1;
                        // padding, enable, color, y1, x1
              vg__data <= { 3'h0, 1'b1, 8'b00000011, 10'd300, 10'd400 };
	      vg__addr <= 7'd2;
	      vg__rect_write <= 1'b1;
	   end
           STATE_BR_A1: begin
	      state <= STATE_BR_WAIT;
                        // padding, y2, x2
              vg__data <= { 12'h000, 10'd599, 10'd799 };
	      vg__addr <= 7'd3;
	      vg__rect_write <= 1'b1;
	   end
	   STATE_BR_WAIT: begin
	      vg__rect_write <= 1'b0;
	      if (counter == 27'b0)
		state <= STATE_TL_A0;
	   end
	 endcase
      end
   end

   /// MODULE INSTANCES ///

   vga_unit VGA(/*AUTOINST*/
		// Outputs
		.Hsync			(Hsync),
		.Vsync			(Vsync),
		.vgaRed			(vgaRed[1:3]),
		.vgaGreen		(vgaGreen[1:3]),
		.vgaBlue		(vgaBlue[2:3]),
		// Inputs
		.clk			(clk),
		.rst_b			(rst_b),
		.vg__data		(vg__data[31:0]),
		.vg__addr		(vg__addr[RECTBITS:0]),
		.vg__write		(vg__write));

endmodule
