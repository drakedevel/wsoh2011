module lame_stack(/*AUTOARG*/
   // Outputs
   st__top_0, st__top_n, st__sp,
   // Inputs
   clk, rst_b, st__push, st__to_pop, st__top_n_offset, st__to_push
   );

   output reg [34:0] st__top_0;
   output reg [34:0] st__top_n;
   output reg [10:0] st__sp;
   input 	     clk, rst_b;
   input 	     st__push;
   input [10:0]      st__to_pop;
   input [10:0]      st__top_n_offset;
   input [34:0]      st__to_push;

   reg [34:0] 	 stack [0:2047];

   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 st__sp <= 11'h000;
      end else begin
	 st__top_0 <= stack[st__sp];
	 st__top_n <= stack[st__sp-st__top_n_offset];
         if (st__push) begin
	    stack[st__sp - st__to_pop + 1] <= st__to_push;
	    st__sp <= st__sp - st__to_pop + 1;
         end else begin
	    st__sp <= st__sp - st__to_pop;
         end
      end
   end
   
endmodule
