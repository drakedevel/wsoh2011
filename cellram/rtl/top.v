module top(/*AUTOARG*/
   // Outputs
   Led, MemAdr, MemOE, MemWR, RamAdv, RamCRE, RamCS, RamClk, RamLB,
   RamUB, an, dp, seg,
   // Inouts
   MemDB,
   // Inputs
   RamWait, clk
   );

   parameter [2:0]
     STATE_RESET = 3'd0,
     STATE_FILL = 3'd1,
     STATE_FILL_WAIT = 3'd2,
     STATE_SUM = 3'd3,
     STATE_SUM_WAIT = 3'd4,
     STATE_HALT = 3'd5;
   
   /// INTERFACE ///

   output [0:7]  Led;
   output [23:1] MemAdr;
   output 	 MemOE;
   output 	 MemWR;
   output 	 RamAdv;
   output 	 RamCRE;
   output 	 RamCS;
   output 	 RamClk;
   output 	 RamLB;
   output 	 RamUB;
   output [0:3]  an;
   output 	 dp;
   output [0:6]  seg;
   inout [15:0]  MemDB;
   input 	 RamWait;
   input 	 clk;

   /// INTERNAL SIGNALS ///

   reg [15:0] 	 counter;
   reg [12:0] 	 startwait = 13'h1fff;
   reg [2:0] 	 state;
   reg [15:0] 	 sum;
   reg 		 rst_b;

   wire [23:0] 	 cr__addr;
   wire [15:0] 	 cr__data_in;
   reg 		 cr__read;
   reg 		 cr__write;
   wire [15:0] 	 ss__value;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [15:0]		cr__data_out;		// From CellRAM of cellram_control.v
   wire			cr__wait;		// From CellRAM of cellram_control.v
   // End of automatics

   /// LOGIC ///

   assign Led = { rst_b, 4'b0, state };
   assign RamClk = 1'b0;

   assign cr__addr =  { 7'b0, counter, 1'b0 };
   assign cr__data_in = counter;
   assign ss__value = sum;

   always @(posedge clk) begin
      if (startwait) begin
	 startwait <= startwait - 1;
	 rst_b <= 1'b0;
      end else begin
	 rst_b <= 1'b1;
      end
   end

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 state <= STATE_RESET;
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 counter <= 16'h0;
	 cr__read <= 1'h0;
	 cr__write <= 1'h0;
	 sum <= 16'h0;
	 // End of automatics
      end else begin
	 case (state)
	   STATE_RESET: begin
	      state <= STATE_FILL;
	   end
	   STATE_FILL: begin
	      if (counter == 16'd32) begin
		 state <= STATE_SUM;
		 counter <= 16'd0;
	      end else begin
		 state <= STATE_FILL_WAIT;
		 counter <= counter + 1;
		 cr__write <= 1'b1;
	      end
	   end
	   STATE_FILL_WAIT: begin
	      cr__write <= 1'b0;
	      if (!cr__wait)
		state <= STATE_FILL;
	   end
	   STATE_SUM: begin
	      if (counter == 16'd32) begin
		 state <= STATE_HALT;
	      end else begin
		 state <= STATE_SUM_WAIT;
		 counter <= counter + 1;
		 cr__read <= 1'b1;
	      end
	   end
	   STATE_SUM_WAIT: begin
	      cr__read <= 1'b0;
	      if (!cr__wait) begin
		 state <= STATE_SUM;
		 sum <= sum + cr__data_out;
	      end
 	   end
	 endcase
      end
   end
   
   /// MODULE INSTANCES ///

   cellram_control CellRAM(.addr(MemAdr),
			   .adv_n(RamAdv),
			   .cre(RamCRE),
			   .ce_n(RamCS),
			   .oe_n(MemOE),
			   .we_n(MemWR),
			   .lb_n(RamLB),
			   .ub_n(RamUB),
			   .dq(MemDB),
			   .o_wait(RamWait),
			   /*AUTOINST*/
			   // Outputs
			   .cr__data_out	(cr__data_out[15:0]),
			   .cr__wait		(cr__wait),
			   // Inputs
			   .clk			(clk),
			   .rst_b		(rst_b),
			   .cr__addr		(cr__addr[23:0]),
			   .cr__data_in		(cr__data_in[15:0]),
			   .cr__read		(cr__read),
			   .cr__write		(cr__write));
   
   seven_seg_control SevenSeg(/*AUTOINST*/
			      // Outputs
			      .an		(an[0:3]),
			      .seg		(seg[0:6]),
			      .dp		(dp),
			      // Inputs
			      .clk		(clk),
			      .rst_b		(rst_b),
			      .ss__value	(ss__value[15:0]));
endmodule