module seven_seg_control(/*AUTOARG*/
   // Outputs
   an, seg, dp,
   // Inputs
   clk, rst_b, ss__value
   );

   /// INTERFACE ///

   // Control interface
   input clk, rst_b;
   input [15:0] ss__value;

   // Device interface
   output reg [0:3] an;
   output reg [0:6] seg;
   output reg	    dp;
   
   /// LOGIC ///

   reg [3:0] 	    current_digit;
   reg [15:0] 	    delay;

   always @* begin
      case (an)
	4'b0111:
	  current_digit = ss__value[3:0];
	4'b1011:
	  current_digit = ss__value[7:4];
	4'b1101:
	  current_digit = ss__value[11:8];
	4'b1110:
	  current_digit = ss__value[15:12];
	default:
	  current_digit = 4'bx;
      endcase
      seg = encode(current_digit);
      dp = 1'b1;
   end
   
   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 an <= 4'b0111;
	 dp <= 1'b1;
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 delay <= 16'h0;
	 // End of automatics
      end else begin
	 delay <= delay + 1;
	 if (!delay)
	   an <= { an[1:3], an[0] };
      end
   end

   /// FUNCTIONS ///

   function [6:0] encode(input [3:0] digit);
      case (digit)
	4'h0: encode = ~7'b1111110;
	4'h1: encode = ~7'b0110000;
	4'h2: encode = ~7'b1101101;
	4'h3: encode = ~7'b1111001;
	4'h4: encode = ~7'b0110011;
	4'h5: encode = ~7'b1011011;
	4'h6: encode = ~7'b1011111;
	4'h7: encode = ~7'b1110000;
	4'h8: encode = ~7'b1111111;
	4'h9: encode = ~7'b1111011;
	4'hA: encode = ~7'b1110111;
	4'hB: encode = ~7'b0011111;
	4'hC: encode = ~7'b1001110;
	4'hD: encode = ~7'b0111101;
	4'hE: encode = ~7'b1001111;
	4'hF: encode = ~7'b1000111;
      endcase
   endfunction
   
endmodule