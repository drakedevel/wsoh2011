module cellram_control_sync(/*AUTOARG*/
   // Outputs
   sync_addr, sync_adv_n, sync_cre, sync_ce_n, sync_oe_n, sync_we_n,
   sync_lb_n, sync_ub_n,
   // Inouts
   dq,
   // Inputs
   clk, rst_b, o_wait
   );

   /// INTERFACE ///
   
   // Control interface
   input         clk, rst_b;

   // Pre-muxed device interface
   output [23:1] sync_addr;
   output 	 sync_adv_n;
   output 	 sync_cre;
   output 	 sync_ce_n;
   output 	 sync_oe_n;
   output 	 sync_we_n;
   output 	 sync_lb_n;
   output 	 sync_ub_n;
   inout [15:0]  dq;
   input 	 o_wait;

   assign dq = 16'bz;
   /*AUTOTIEOFF*/
   // Beginning of automatic tieoffs (for this module's unterminated outputs)
   wire [23:1]		sync_addr		= 23'h0;
   wire			sync_adv_n		= 1'h0;
   wire			sync_ce_n		= 1'h0;
   wire			sync_cre		= 1'h0;
   wire			sync_lb_n		= 1'h0;
   wire			sync_oe_n		= 1'h0;
   wire			sync_ub_n		= 1'h0;
   wire			sync_we_n		= 1'h0;
   // End of automatics
   
endmodule