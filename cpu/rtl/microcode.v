`include "jsopcode.vh"
`include "opcode.vh"
`include "microprogramoffsets.vh"

module microcode(/*AUTOARG*/
   // Outputs
   mc__control_2a, mc__more_2a,
   // Inputs
   js_mode, kill_4a, mc__stall, opcode, clk, rst_b
   );
`include "microprogram.vh"

   output [31:0] mc__control_2a;
   output 	 mc__more_2a;
   input 	 js_mode;
   input 	 kill_4a;
   input 	 mc__stall;
   input [7:0] 	 opcode;
   input 	 clk, rst_b;

   /// INTERNAL SIGNALS ///

   wire 	 killed;
   wire [10:0]	 microprogram_label_value;
   wire [31:0] 	 next_micro_op_hack;
   reg [9:0] 	 next_micro_pc;
   reg 		 next_micro_valid;
   reg [31:0] 	 micro_op_hack;
   reg [9:0] 	 micro_pc;

   /// COMBINATIONAL LOGIC ///

   assign killed = kill_4a;
   assign microprogram_label_value = microprogram_label[{ js_mode, opcode }];
   assign next_micro_op_hack = microprogram[next_micro_pc];
   
   // Output
   assign mc__control_2a = killed ? 32'b0 : micro_op_hack;

   // Decode
   assign mc__more_2a = micro_op_hack[0];

   // Next PC
   always @* begin
      if (mc__more_2a && !killed) begin
	 next_micro_valid = 1'b1;
	 next_micro_pc = micro_pc + 1;
      end else begin
	 { next_micro_valid, next_micro_pc } = microprogram_label_value;
      end
   end

   /// SEQUENTIAL LOGIC ///

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 micro_op_hack <= 32'h0;
	 micro_pc <= 10'h0;
	 // End of automatics
      end else begin
	 if (mc__stall && !killed) begin
	    micro_op_hack[31:1] <= 31'b0;
	 end else begin
	    micro_op_hack <= next_micro_op_hack;
	    micro_pc <= next_micro_pc;
	 end
      end
   end
   
endmodule
