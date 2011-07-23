module cpu(/*AUTOARG*/
   // Outputs
   hatch_address,
   // Inputs
   rst_b, hatch_instruction, clk
   );

   /// WORLD INTERFACE ///

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output [31:0]	hatch_address;		// From Fetch of cpu_fetch.v
   // End of automatics
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		clk;			// To Fetch of cpu_fetch.v, ...
   input [47:0]		hatch_instruction;	// To Fetch of cpu_fetch.v
   input		rst_b;			// To Fetch of cpu_fetch.v, ...
   // End of automatics

   /// INTERNAL SIGNALS ///

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			alu__cond_3a;		// From Execute of cpu_execute.v
   wire [4:0]		alu__op_2a;		// From Decode of cpu_decode.v
   wire [31:0]		alu__out_3a;		// From Execute of cpu_execute.v
   wire [31:0]		branch_target_4a;	// From Memory of cpu_memory.v
   wire [1:0]		c__alu_left_2a;		// From Decode of cpu_decode.v
   wire [1:0]		c__alu_right_2a;	// From Decode of cpu_decode.v
   wire [1:0]		c__branch_2a;		// From Decode of cpu_decode.v
   wire [1:0]		c__branch_3a;		// From Execute of cpu_execute.v
   wire [1:0]		c__to_push_2a;		// From Decode of cpu_decode.v
   wire [1:0]		c__to_push_3a;		// From Execute of cpu_execute.v
   wire [1:0]		c__to_push_4a;		// From Memory of cpu_memory.v
   wire [47:0]		instruction_1a;		// From Fetch of cpu_fetch.v
   wire [47:0]		instruction_2a;		// From Decode of cpu_decode.v
   wire [47:0]		instruction_3a;		// From Execute of cpu_execute.v
   wire			kill_4a;		// From Memory of cpu_memory.v
   wire [31:0]		pc_1a;			// From Fetch of cpu_fetch.v
   wire [31:0]		pc_2a;			// From Decode of cpu_decode.v
   wire [31:0]		pc_3a;			// From Execute of cpu_execute.v
   wire [31:0]		pc_4a;			// From Memory of cpu_memory.v
   wire			st__pop_5a;		// From Writeback of cpu_writeback.v
   wire			st__push_5a;		// From Writeback of cpu_writeback.v
   wire [10:0]		st__to_pop_2a;		// From Decode of cpu_decode.v
   wire [10:0]		st__to_pop_3a;		// From Execute of cpu_execute.v
   wire [10:0]		st__to_pop_4a;		// From Memory of cpu_memory.v
   wire [10:0]		st__to_pop_5a;		// From Writeback of cpu_writeback.v
   wire [34:0]		st__to_push_4a;		// From Memory of cpu_memory.v
   wire [34:0]		st__to_push_5a;		// From Writeback of cpu_writeback.v
   wire [34:0]		st__top_0_2a;		// From Decode of cpu_decode.v
   wire [34:0]		st__top_1_2a;		// From Decode of cpu_decode.v
   wire			stall_2a;		// From Decode of cpu_decode.v
   // End of automatics

   /// PIPELINE STAGES ///

   cpu_fetch Fetch(/*AUTOINST*/
		   // Outputs
		   .instruction_1a	(instruction_1a[47:0]),
		   .pc_1a		(pc_1a[31:0]),
		   .hatch_address	(hatch_address[31:0]),
		   // Inputs
		   .branch_target_4a	(branch_target_4a[31:0]),
		   .kill_4a		(kill_4a),
		   .stall_2a		(stall_2a),
		   .clk			(clk),
		   .rst_b		(rst_b),
		   .hatch_instruction	(hatch_instruction[47:0]));

   cpu_decode Decode(/*AUTOINST*/
		     // Outputs
		     .alu__op_2a	(alu__op_2a[4:0]),
		     .c__alu_left_2a	(c__alu_left_2a[1:0]),
		     .c__alu_right_2a	(c__alu_right_2a[1:0]),
		     .c__branch_2a	(c__branch_2a[1:0]),
		     .c__to_push_2a	(c__to_push_2a[1:0]),
		     .instruction_2a	(instruction_2a[47:0]),
		     .pc_2a		(pc_2a[31:0]),
		     .stall_2a		(stall_2a),
		     .st__top_0_2a	(st__top_0_2a[34:0]),
		     .st__top_1_2a	(st__top_1_2a[34:0]),
		     .st__to_pop_2a	(st__to_pop_2a[10:0]),
		     // Inputs
		     .instruction_1a	(instruction_1a[47:0]),
		     .kill_4a		(kill_4a),
		     .pc_1a		(pc_1a[31:0]),
		     .st__pop_5a	(st__pop_5a),
		     .st__push_5a	(st__push_5a),
		     .st__to_pop_5a	(st__to_pop_5a[10:0]),
		     .st__to_push_5a	(st__to_push_5a[34:0]),
		     .c__to_push_3a	(c__to_push_3a[1:0]),
		     .c__to_push_4a	(c__to_push_4a[1:0]),
		     .st__to_pop_3a	(st__to_pop_3a[10:0]),
		     .st__to_pop_4a	(st__to_pop_4a[10:0]),
		     .clk		(clk),
		     .rst_b		(rst_b));
   
   cpu_execute Execute(/*AUTOINST*/
		       // Outputs
		       .alu__cond_3a	(alu__cond_3a),
		       .alu__out_3a	(alu__out_3a[31:0]),
		       .c__branch_3a	(c__branch_3a[1:0]),
		       .c__to_push_3a	(c__to_push_3a[1:0]),
		       .instruction_3a	(instruction_3a[47:0]),
		       .pc_3a		(pc_3a[31:0]),
		       .st__to_pop_3a	(st__to_pop_3a[10:0]),
		       // Inputs
		       .alu__op_2a	(alu__op_2a[4:0]),
		       .c__alu_left_2a	(c__alu_left_2a[1:0]),
		       .c__alu_right_2a	(c__alu_right_2a[1:0]),
		       .c__branch_2a	(c__branch_2a[1:0]),
		       .c__to_push_2a	(c__to_push_2a[1:0]),
		       .instruction_2a	(instruction_2a[47:0]),
		       .kill_4a		(kill_4a),
		       .pc_2a		(pc_2a[31:0]),
		       .st__top_0_2a	(st__top_0_2a[34:0]),
		       .st__top_1_2a	(st__top_1_2a[34:0]),
		       .st__to_pop_2a	(st__to_pop_2a[10:0]),
		       .clk		(clk),
		       .rst_b		(rst_b));

   cpu_memory Memory(/*AUTOINST*/
		     // Outputs
		     .branch_target_4a	(branch_target_4a[31:0]),
		     .c__to_push_4a	(c__to_push_4a[1:0]),
		     .kill_4a		(kill_4a),
		     .pc_4a		(pc_4a[31:0]),
		     .st__to_pop_4a	(st__to_pop_4a[10:0]),
		     .st__to_push_4a	(st__to_push_4a[34:0]),
		     // Inputs
		     .alu__cond_3a	(alu__cond_3a),
		     .alu__out_3a	(alu__out_3a[31:0]),
		     .c__branch_3a	(c__branch_3a[1:0]),
		     .c__to_push_3a	(c__to_push_3a[1:0]),
		     .instruction_3a	(instruction_3a[47:0]),
		     .pc_3a		(pc_3a[31:0]),
		     .st__to_pop_3a	(st__to_pop_3a[10:0]),
		     .clk		(clk),
		     .rst_b		(rst_b));

   cpu_writeback Writeback(/*AUTOINST*/
			   // Outputs
			   .st__pop_5a		(st__pop_5a),
			   .st__push_5a		(st__push_5a),
			   .st__to_pop_5a	(st__to_pop_5a[10:0]),
			   .st__to_push_5a	(st__to_push_5a[34:0]),
			   // Inputs
			   .pc_4a		(pc_4a[31:0]),
			   .c__to_push_4a	(c__to_push_4a[1:0]),
			   .st__to_pop_4a	(st__to_pop_4a[10:0]),
			   .st__to_push_4a	(st__to_push_4a[34:0]),
			   .clk			(clk),
			   .rst_b		(rst_b));
   
   // synthesis translate_off
   cpu_debug Debug(/*AUTOINST*/
		   // Inputs
		   .kill_4a		(kill_4a),
		   .pc_1a		(pc_1a[31:0]),
		   .pc_2a		(pc_2a[31:0]),
		   .pc_3a		(pc_3a[31:0]),
		   .pc_4a		(pc_4a[31:0]),
		   .stall_2a		(stall_2a),
		   .st__push_5a		(st__push_5a),
		   .st__to_push_5a	(st__to_push_5a[34:0]),
		   .clk			(clk),
		   .rst_b		(rst_b));
   // synthesis translate_on
endmodule