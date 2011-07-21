module toptb();

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [0:7]		Led;			// From DUT of top.v
   wire [23:1]		MemAdr;			// From DUT of top.v
   wire [15:0]		MemDB;			// To/From DUT of top.v
   wire			MemOE;			// From DUT of top.v
   wire			MemWR;			// From DUT of top.v
   wire			RamAdv;			// From DUT of top.v
   wire			RamCRE;			// From DUT of top.v
   wire			RamCS;			// From DUT of top.v
   wire			RamClk;			// From DUT of top.v
   wire			RamLB;			// From DUT of top.v
   wire			RamUB;			// From DUT of top.v
   wire [0:3]		an;			// From DUT of top.v
   wire			dp;			// From DUT of top.v
   wire [0:6]		seg;			// From DUT of top.v
   // End of automatics

   reg 			clk;
   always begin
      clk <= 1'b0;
      #10;
      clk <= 1'b1;
      #10;
   end

   initial begin
      $monitor($stime,, "CS=%b Adr=%x", RamCS, MemAdr);
      wait (Led[5:7] == 3'd5) $finish();
   end
   
   
   top DUT(/*AUTOINST*/
	   // Outputs
	   .Led				(Led[0:7]),
	   .MemAdr			(MemAdr[23:1]),
	   .MemOE			(MemOE),
	   .MemWR			(MemWR),
	   .RamAdv			(RamAdv),
	   .RamCRE			(RamCRE),
	   .RamCS			(RamCS),
	   .RamClk			(RamClk),
	   .RamLB			(RamLB),
	   .RamUB			(RamUB),
	   .an				(an[0:3]),
	   .dp				(dp),
	   .seg				(seg[0:6]),
	   // Inouts
	   .MemDB			(MemDB[15:0]),
	   // Inputs
	   .RamWait			(RamWait),
	   .clk				(clk));

   cellram RAM(.o_wait(RamWait),
	       .dq(MemDB),
	       .clk(RamClk),
	       .adv_n(RamAdv),
	       .cre(RamCRE),
	       .ce_n(RamCS),
	       .oe_n(MemOE),
	       .we_n(MemWR),
	       .lb_n(RamLB),
	       .ub_n(RamUB),
	       .addr(MemAdr));
endmodule
// Local Variables:
// verilog-library-flags:("-y ../rtl -y ../behav")
// End: