module cpu_fetch(/*AUTOARG*/
   // Outputs
   instruction_1a, pc_1a, hatch_address,
   // Inputs
   branch_target_4a, kill_4a, stall_2a, clk, rst_b, hatch_instruction
   );

   /// PIPELINE INTERFACE ///

   input [31:0]      branch_target_4a;
   input             kill_4a;
   input             stall_2a;
   output reg [47:0] instruction_1a;
   output reg [31:0] pc_1a;

   /// WORLD INTERFACE ///

   output [31:0]     hatch_address;
   input 	     clk, rst_b;
   input [47:0]      hatch_instruction;

   /// INTERNAL SIGNALS ///

   reg [31:0] 	 next_pc;
   
   /// COMBINATIONAL LOGIC ///
  
   assign hatch_address = kill_4a ? branch_target_4a : next_pc;
   
   /// SEQUENTIAL LOGIC ///
   
   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 instruction_1a <= 48'h0;
	 next_pc <= 32'h0;
	 pc_1a <= 32'h0;
	 // End of automatics
      end else begin
	 if (kill_4a) begin
	    next_pc <= branch_target_4a + 6;
	    pc_1a <= branch_target_4a;
	    instruction_1a <= hatch_instruction;
	 end else if (!stall_2a) begin
	    next_pc <= next_pc + 6;
	    pc_1a <= next_pc;
	    instruction_1a <= hatch_instruction;
	 end
      end
   end
endmodule