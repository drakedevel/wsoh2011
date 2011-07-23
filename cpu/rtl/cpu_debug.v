module cpu_debug(/*AUTOARG*/
   // Inputs
   hatch_instruction, kill_4a, pc_1a, pc_2a, pc_3a, pc_4a, stall_2a,
   st__push_5a, st__to_push_5a, st__top_0_2a, st__top_n_2a, clk,
   rst_b
   );

   /// PIPELINE INTERFACE ///

   input [47:0] hatch_instruction;
   input        kill_4a;
   input [31:0] pc_1a, pc_2a, pc_3a, pc_4a;
   input        stall_2a; 
   input        st__push_5a;
   input [34:0] st__to_push_5a;
   input [34:0] st__top_0_2a;
   input [34:0] st__top_n_2a;

   /// WORLD INTERFACE ///

   input clk, rst_b;

   /// DEBUG SPAM ///

   always @(posedge clk) begin
      if (rst_b) begin
	 $display("======================== Time %6d ========================", $stime);
	 $display("Insn: %x", hatch_instruction);
	 $display("Branch %b", kill_4a);
	 $display("MicroStall=%b", stall_2a);
	 $display("Push %b=%x", st__push_5a, st__to_push_5a);
	 $display("Stack: ... %x %x", st__top_n_2a, st__top_0_2a);
	 $display("PC1=%x PC2=%x PC3=%x PC4=%x", pc_1a, pc_2a, pc_3a, pc_4a);
      end
   end
endmodule
