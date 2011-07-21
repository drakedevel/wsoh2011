module cpu_fetch(/*AUTOARG*/
   // Outputs
   instruction_1a, pc_1a, hatch_address,
   // Inputs
   stall_2a, clk, rst_b, hatch_instruction
   );

   /// PIPELINE INTERFACE ///

   input             stall_2a;
   output reg [47:0] instruction_1a;
   output [31:0]     pc_1a;

   /// WORLD INTERFACE ///

   output [31:0]     hatch_address;
   input 	     clk, rst_b;
   input [47:0]      hatch_instruction;

   /// INTERNAL SIGNALS ///

   reg [31:0] 	 pc;
   
   /// COMBINATIONAL LOGIC ///

   assign hatch_address = pc;
   assign pc_1a = pc;
   
   /// SEQUENTIAL LOGIC ///
   
   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 instruction_1a <= 48'h0;
	 pc <= 32'h0;
	 // End of automatics
      end else begin
	 if (!stall_2a) begin
	    pc <= pc + 4;
	    instruction_1a <= hatch_instruction;
	 end
      end
   end
endmodule