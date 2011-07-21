`include "opcode.vh"

module cpu_execute(/*AUTOARG*/
   // Outputs
   alu__cond_3a, alu__out_3a, c__to_push_3a, instruction_3a, pc_3a,
   st__to_pop_3a,
   // Inputs
   alu__op_2a, c__alu_left_2a, c__alu_right_2a, c__to_push_2a,
   instruction_2a, pc_2a, st__top_0_2a, st__top_1_2a, st__to_pop_2a,
   clk, rst_b
   );

   /// PIPELINE INTERFACE ///

   output reg        alu__cond_3a;
   output reg [31:0] alu__out_3a;
   output reg [1:0]  c__to_push_3a;
   output reg [47:0] instruction_3a;
   output reg [31:0] pc_3a;
   output reg [10:0] st__to_pop_3a;
   input [4:0] 	     alu__op_2a;
   input [1:0] 	     c__alu_left_2a;
   input [1:0] 	     c__alu_right_2a;
   input [1:0]	     c__to_push_2a;
   input [47:0]      instruction_2a;
   input [31:0]      pc_2a;
   input [34:0]      st__top_0_2a;
   input [34:0]      st__top_1_2a;
   input [10:0]      st__to_pop_2a;
   
   /// WORLD INTERFACE ///
   
   input 	     clk, rst_b;

   /// INTERNAL SIGNALS ///

   reg [31:0] 	     alu__left;
   reg [31:0] 	     alu__right;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			alu__cond;		// From ALU of alu.v
   wire [31:0]		alu__out;		// From ALU of alu.v
   // End of automatics

   /// COMBINATIONAL LOGIC ///

   always @* begin
      case (c__alu_left_2a)
	`UC_RIGHT_IMM:
	  alu__left = instruction_2a[31:0];
	`UC_RIGHT_STK0:
	  alu__left = st__top_0_2a[31:0];
	`UC_RIGHT_STK1:
	  alu__left = st__top_1_2a[31:0];
	default:
	  alu__left = 32'bx;
      endcase
      case (c__alu_right_2a)
	`UC_RIGHT_IMM:
	  alu__right = instruction_2a[31:0];
	`UC_RIGHT_STK0:
	  alu__right = st__top_0_2a[31:0];
	`UC_RIGHT_STK1:
	  alu__right = st__top_1_2a[31:0];
	default:
	  alu__right = 32'bx;
      endcase
   end
   
   /// SEQUENTIAL LOGIC ///

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 alu__cond_3a <= 1'h0;
	 alu__out_3a <= 32'h0;
	 c__to_push_3a <= 2'h0;
	 instruction_3a <= 48'h0;
	 pc_3a <= 32'h0;
	 st__to_pop_3a <= 11'h0;
	 // End of automatics
      end else begin
	 // Generated signals
	 alu__cond_3a <= alu__cond;
	 alu__out_3a <= alu__out;
	 c__to_push_3a <= c__to_push_2a;
	 st__to_pop_3a <= st__to_pop_2a;

	 // Pass through
	 instruction_3a <= instruction_2a;
	 pc_3a <= pc_2a;
      end
   end
   
   /// MODULE INSTANCES ///

   alu ALU(.alu__op(alu__op_2a),
	   /*AUTOINST*/
	   // Outputs
	   .alu__cond			(alu__cond),
	   .alu__out			(alu__out[31:0]),
	   // Inputs
	   .alu__left			(alu__left[31:0]),
	   .alu__right			(alu__right[31:0]));
   
endmodule