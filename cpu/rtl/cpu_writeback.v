`include "opcode.vh"

module cpu_writeback(/*AUTOARG*/
   // Outputs
   st__push_5a, st__to_pop_5a, st__to_push_5a,
   // Inputs
   pc_4a, c__to_push_4a, st__to_pop_4a, st__to_push_4a, clk, rst_b
   );

   /// PIPELINE INTERFACE ///
   
   output 	 st__push_5a;
   output [10:0] st__to_pop_5a;
   output [34:0] st__to_push_5a;
   input [31:0]  pc_4a;
   input [2:0]	 c__to_push_4a;
   input [10:0]  st__to_pop_4a;
   input [34:0]  st__to_push_4a;
   
   /// WORLD INTERFACE ///

   input 	     clk, rst_b;

   /// COMBINATIONAL LOGIC ///

   assign st__to_pop_5a = st__to_pop_4a;
   
   assign st__push_5a = (c__to_push_4a != `UC_NOPUSH);
   assign st__to_push_5a = st__to_push_4a;

endmodule
