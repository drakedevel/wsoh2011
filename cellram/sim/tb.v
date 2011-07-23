`timescale 1ns / 1ps
module tb();

   /// INTERNAL SIGNALS ///

   reg        clk, rst_b;
   reg [23:0] cr__addr;
   reg [15:0] cr__data_in;
   reg 	      cr__read;
   reg 	      cr__write;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [23:1]		addr;			// From DUT of cellram_control.v
   wire			adv_n;			// From DUT of cellram_control.v
   wire			ce_n;			// From DUT of cellram_control.v
   wire [15:0]		cr__data_out;		// From DUT of cellram_control.v
   wire			cr__wait;		// From DUT of cellram_control.v
   wire			cre;			// From DUT of cellram_control.v
   wire [15:0]		dq;			// To/From DUT of cellram_control.v
   wire			lb_n;			// From DUT of cellram_control.v
   wire			o_wait;			// From CellRAM of cellram.v
   wire			oe_n;			// From DUT of cellram_control.v
   wire			ub_n;			// From DUT of cellram_control.v
   wire			we_n;			// From DUT of cellram_control.v
   // End of automatics

   /// TEST BENCH ///

   always begin
      clk <= 1'b0;
      #10;
      clk <= 1'b1;
      #10;
   end

   initial begin
      // Wait for CellRAM to power up
      #150000;

      // Reset the DUT.
      #5;
      cr__addr = 24'b0;
      cr__read = 1'b0;
      rst_b = 1'b0;
      #20;
      rst_b = 1'b1;
      #20;

      $monitor($stime,,"W=%b DO=%x", cr__wait, cr__data_out);
      
      // Issue a write request
      cr__addr = 24'h1337;
      cr__data_in = 16'hD00D;
      cr__write = 1'b1;
      #20;
      cr__write = 1'b0;
      #200;
      
      // Issue a read request.
      cr__read = 1'b1;
      #20;
      cr__read = 1'b0;
      #200;

      $finish();
   end
   
   /// MODULE INSTANCES ///
   
   cellram CellRAM(.clk(1'b0),
		   .dq(dq),
		   .addr(addr),
		   /*AUTOINST*/
		   // Outputs
		   .o_wait		(o_wait),
		   // Inputs
		   .adv_n		(adv_n),
		   .cre			(cre),
		   .ce_n		(ce_n),
		   .oe_n		(oe_n),
		   .we_n		(we_n),
		   .lb_n		(lb_n),
		   .ub_n		(ub_n));

   cellram_control DUT(/*AUTOINST*/
		       // Outputs
		       .cr__data_out	(cr__data_out[15:0]),
		       .cr__wait	(cr__wait),
		       .addr		(addr[23:1]),
		       .adv_n		(adv_n),
		       .cre		(cre),
		       .ce_n		(ce_n),
		       .oe_n		(oe_n),
		       .we_n		(we_n),
		       .lb_n		(lb_n),
		       .ub_n		(ub_n),
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

endmodule
// Local Variables:
// verilog-library-flags:("-y ../rtl -y ../behav")
// End: