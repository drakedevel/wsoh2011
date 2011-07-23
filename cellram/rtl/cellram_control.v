module cellram_control(/*AUTOARG*/
   // Outputs
   cr__data_out, cr__wait, addr, adv_n, cre, ce_n, oe_n, we_n, lb_n,
   ub_n,
   // Inouts
   dq,
   // Inputs
   clk, rst_b, cr__addr, cr__data_in, cr__read, cr__write, o_wait
   );
   /// INTERFACE ///

   // Control interface
   output reg [15:0] cr__data_out;
   output 	     cr__wait;
   input 	     clk, rst_b;
   input [23:0]      cr__addr;
   input [15:0]      cr__data_in;
   input 	     cr__read;
   input 	     cr__write;

   // Device interface
   output [23:1]     addr;
   output 	     adv_n;
   output 	     cre;
   output 	     ce_n;
   output 	     oe_n;
   output 	     we_n;
   output 	     lb_n;
   output 	     ub_n;
   inout [15:0]      dq;
   input 	     o_wait;

   /// INERNAL SIGNALS ///

   wire [15:0] 	     async_dq;
   wire [15:0] 	     disconnected_dq;
   wire 	     mode_async;
   wire [15:0]	     sync_dq;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [23:1]		async_addr;		// From Async of cellram_control_async.v
   wire			async_adv_n;		// From Async of cellram_control_async.v
   wire			async_ce_n;		// From Async of cellram_control_async.v
   wire			async_cr__wait;		// From Async of cellram_control_async.v
   wire			async_cre;		// From Async of cellram_control_async.v
   wire			async_lb_n;		// From Async of cellram_control_async.v
   wire			async_oe_n;		// From Async of cellram_control_async.v
   wire			async_ub_n;		// From Async of cellram_control_async.v
   wire			async_we_n;		// From Async of cellram_control_async.v
   wire [23:1]		sync_addr;		// From Sync of cellram_control_sync.v
   wire			sync_adv_n;		// From Sync of cellram_control_sync.v
   wire			sync_ce_n;		// From Sync of cellram_control_sync.v
   wire			sync_cre;		// From Sync of cellram_control_sync.v
   wire			sync_lb_n;		// From Sync of cellram_control_sync.v
   wire			sync_oe_n;		// From Sync of cellram_control_sync.v
   wire			sync_ub_n;		// From Sync of cellram_control_sync.v
   wire			sync_we_n;		// From Sync of cellram_control_sync.v
   // End of automatics
   /// LOGIC ///

   always @(posedge clk) begin
      cr__data_out <= dq;
   end
   
   /// MODE MULTIPLEXING ///

   assign mode_async = 1'b1; // TODO: Implement synchronous mode.

   assign cr__wait = mode_async ? async_cr__wait : 1'b0;
   
   assign addr = mode_async ? async_addr : sync_addr;
   assign adv_n = mode_async ? async_adv_n : sync_adv_n;
   assign cre = mode_async ? async_cre : sync_cre;
   assign ce_n = mode_async ? async_ce_n : sync_ce_n;
   assign oe_n = mode_async ? async_oe_n : sync_oe_n;
   assign we_n = mode_async ? async_we_n : sync_we_n;
   assign lb_n = mode_async ? async_lb_n : sync_lb_n;
   assign ub_n = mode_async ? async_ub_n : sync_ub_n;

   /// MODULE INSTANTIATIONS ///

   cellram_control_async Async(/*AUTOINST*/
			       // Outputs
			       .async_cr__wait	(async_cr__wait),
			       .async_addr	(async_addr[23:1]),
			       .async_adv_n	(async_adv_n),
			       .async_cre	(async_cre),
			       .async_ce_n	(async_ce_n),
			       .async_oe_n	(async_oe_n),
			       .async_we_n	(async_we_n),
			       .async_lb_n	(async_lb_n),
			       .async_ub_n	(async_ub_n),
			       // Inouts
			       .dq		(dq[15:0]),
			       // Inputs
			       .clk		(clk),
			       .rst_b		(rst_b),
			       .cr__addr	(cr__addr[23:0]),
			       .cr__data_in	(cr__data_in[15:0]),
			       .cr__read	(cr__read),
			       .cr__write	(cr__write),
			       .o_wait		(o_wait));

   cellram_control_sync Sync(/*AUTOINST*/
			     // Outputs
			     .sync_addr		(sync_addr[23:1]),
			     .sync_adv_n	(sync_adv_n),
			     .sync_cre		(sync_cre),
			     .sync_ce_n		(sync_ce_n),
			     .sync_oe_n		(sync_oe_n),
			     .sync_we_n		(sync_we_n),
			     .sync_lb_n		(sync_lb_n),
			     .sync_ub_n		(sync_ub_n),
			     // Inouts
			     .dq		(dq[15:0]),
			     // Inputs
			     .clk		(clk),
			     .rst_b		(rst_b),
			     .o_wait		(o_wait));
   
endmodule