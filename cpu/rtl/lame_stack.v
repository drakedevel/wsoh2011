module lame_stack(/*AUTOARG*/
   // Outputs
   st__top_0, st__top_1,
   // Inputs
   clk, rst_b, st__pop, st__push, st__to_pop, st__to_push
   );

   output reg [34:0] st__top_0;
   output reg [34:0] st__top_1;
   input 	     clk, rst_b;
   input 	     st__pop;
   input 	     st__push;
   input [10:0]      st__to_pop;
   input [34:0]      st__to_push;

   reg [34:0] 	 stack [0:2047];
   reg [10:0] 	 sp;

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 sp <= 11'h000;
      end else begin
	 st__top_0 <= stack[sp];
	 st__top_1 <= stack[sp-1];
	 if (st__pop) begin
	    sp <= sp - st__to_pop;
	 end else if (st__push) begin
	    stack[sp+1] <= st__to_push;
	    sp <= sp + 1;
	 end
      end
   end
   
endmodule