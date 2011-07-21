module cpu_debug(/*AUTOARG*/
   // Inputs
   stall_2a, st__push_5a, st__to_push_5a, clk, rst_b
   );

   /// PIPELINE INTERFACE ///

   input        stall_2a; 
   input        st__push_5a;
   input [34:0] st__to_push_5a;

   /// WORLD INTERFACE ///

   input clk, rst_b;

   /// DEBUG SPAM ///

   always @(posedge clk) begin
      if (rst_b) begin
	 $display("======================== Time %6d ========================", $stime);
	 $display("MicroStall=%b", stall_2a);
	 $display("Push %b=%x", st__push_5a, st__to_push_5a);
      end
   end
endmodule