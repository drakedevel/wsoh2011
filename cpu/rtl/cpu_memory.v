`include "opcode.vh"

module cpu_memory(/*AUTOARG*/
   // Outputs
   branch_target_4a, c__to_push_4a, kill_4a, pc_4a, st__to_pop_4a,
   st__to_push_4a,
   // Inputs
   alu__cond_3a, alu__out_3a, c__branch_3a, c__to_push_3a,
   instruction_3a, pc_3a, r0_3a, r1_3a, st__to_pop_3a, clk, rst_b
   );

   /// PIPELINE INTERFACE ///

   output reg [31:0] branch_target_4a;
   output reg [2:0]  c__to_push_4a;
   output reg 	     kill_4a;
   output reg [31:0] pc_4a;
   output reg [10:0] st__to_pop_4a;
   output reg [34:0] st__to_push_4a;
   input 	     alu__cond_3a;
   input [31:0]      alu__out_3a;
   input [1:0] 	     c__branch_3a;
   input [2:0] 	     c__to_push_3a;
   input [47:0]      instruction_3a;
   input [31:0]      pc_3a;
   input [34:0]      r0_3a;
   input [34:0]      r1_3a;
   input [10:0]      st__to_pop_3a;

   /// WORLD INTERFACE ///

   input 	     clk, rst_b;
   
   /// SEQUENTIAL LOGIC ///

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 branch_target_4a <= 32'h0;
	 c__to_push_4a <= 3'h0;
	 kill_4a <= 1'h0;
	 pc_4a <= 32'h0;
	 st__to_pop_4a <= 11'h0;
	 st__to_push_4a <= 35'h0;
	 // End of automatics
      end else begin
	 // Generated signals
	 c__to_push_4a <= c__to_push_3a;
	 st__to_pop_4a <= st__to_pop_3a;

	 case (c__to_push_3a)
	   `UC_PUSHALU:
	     st__to_push_4a <= { `TYPE_INTEGER, alu__out_3a };
	   `UC_PUSHIMM:
	     st__to_push_4a <= instruction_3a[34:0];
	   `UC_PUSHREG0:
	     st__to_push_4a <= r0_3a;
	   `UC_PUSHREG1:
	     st__to_push_4a <= r1_3a;
	   default:
	     st__to_push_4a <= 35'bx;
	 endcase

	 case (c__branch_3a)
	   `UC_BR_NONE:
	     kill_4a <= 1'b0;
	   `UC_BR_REL:
	     kill_4a <= 1'b1;
	   `UC_BR_REL_COND:
	     kill_4a <= alu__cond_3a;
	   default:
	     kill_4a <= 1'bx;
	 endcase

	 case (c__branch_3a)
	   `UC_BR_REL, `UC_BR_REL_COND:
	     branch_target_4a <= pc_3a + { {16{instruction_3a[15]}}, instruction_3a[15:0] };
	   default:
	     branch_target_4a <= 32'bx;
	 endcase
	 
	 // Pass through
	 pc_4a <= pc_3a; 
      end
   end
   
endmodule
