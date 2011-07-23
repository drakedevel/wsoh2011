module cpu_decode(/*AUTOARG*/
   // Outputs
   alu__op_2a, c__alu_left_2a, c__alu_right_2a, c__branch_2a,
   c__to_push_2a, c__r0_2a, c__r1_2a, instruction_2a, pc_2a, stall_2a,
   st__top_0_2a, st__top_1_2a, st__to_pop_2a,
   // Inputs
   instruction_1a, kill_4a, pc_1a, st__push_5a, st__to_pop_5a,
   st__to_push_5a, c__to_push_3a, c__to_push_4a, st__to_pop_3a,
   st__to_pop_4a, clk, rst_b
   );

   /// PIPELINE INTERFACE ///

   output [4:0]      alu__op_2a;
   output [1:0]      c__alu_left_2a;
   output [1:0]      c__alu_right_2a;
   output [1:0]      c__branch_2a;
   output [2:0]      c__to_push_2a;
   output            c__r0_2a;
   output            c__r1_2a;
   output reg [47:0] instruction_2a;
   output reg [31:0] pc_2a;
   output 	     stall_2a;
   output [34:0]     st__top_0_2a;
   output [34:0]     st__top_1_2a;
   output [10:0]     st__to_pop_2a;
   input [47:0]      instruction_1a;
   input 	     kill_4a;
   input [31:0]      pc_1a;
   input 	     st__push_5a;
   input [10:0]	     st__to_pop_5a;
   input [34:0]      st__to_push_5a;

   input [2:0]	     c__to_push_3a;
   input [2:0] 	     c__to_push_4a;
   input [10:0]      st__to_pop_3a;
   input [10:0]      st__to_pop_4a;

   /// WORLD INTERFACE ///

   input 	     clk, rst_b;

   /// INTERNAL SIGNALS ///

   wire [7:0] 	     opcode;
   wire 	     mc__stall;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]		mc__control_2a;		// From Microcode of microcode.v
   wire			mc__more_2a;		// From Microcode of microcode.v
   // End of automatics
   
   /// COMBINATIONAL LOGIC ///

   assign mc__stall = c__to_push_2a || st__to_pop_2a ||
		      c__to_push_3a || st__to_pop_3a ||
		      c__to_push_4a || st__to_pop_4a ||
		      st__push_5a || st__to_pop_5a;
   assign stall_2a = mc__more_2a || mc__stall;

   assign js_mode = pc_1a[0];
   assign opcode = instruction_1a[47:40];

   assign alu__op_2a = mc__control_2a[5:1];
   assign st__to_pop_2a = { 9'b0, mc__control_2a[7:6] };
   assign c__to_push_2a = mc__control_2a[10:8];
   assign c__alu_right_2a = mc__control_2a[12:11];
   assign c__alu_left_2a = mc__control_2a[14:13];
   assign c__branch_2a = mc__control_2a[16:15];
   assign c__r0_2a = mc__control_2a[17];
   assign c__r1_2a = mc__control_2a[18];

   /// SEQUENTIAL LOGIC ///

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 instruction_2a <= 48'h0;
	 pc_2a <= 32'h0;
	 // End of automatics
      end else begin
	 if (!stall_2a) begin
	    // Generated signals
	    
	    // Pass-through
	    instruction_2a <= instruction_1a;
	    pc_2a <= pc_1a;
	 end
      end
   end
   
   /// MODULE INSTANCES ///

   microcode Microcode(/*AUTOINST*/
		       // Outputs
		       .mc__control_2a	(mc__control_2a[31:0]),
		       .mc__more_2a	(mc__more_2a),
		       // Inputs
		       .js_mode		(js_mode),
		       .mc__stall	(mc__stall),
		       .opcode		(opcode[7:0]),
		       .clk		(clk),
		       .rst_b		(rst_b));

   lame_stack Stack(.st__top_0(st__top_0_2a),
		    .st__top_1(st__top_1_2a),
		    .st__push(st__push_5a),
		    .st__to_pop(st__to_pop_5a),
		    .st__to_push(st__to_push_5a),
		    /*AUTOINST*/
		    // Inputs
		    .clk		(clk),
		    .rst_b		(rst_b));
   
endmodule
