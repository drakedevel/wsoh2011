module cellram_control_async(/*AUTOARG*/
   // Outputs
   async_cr__wait, async_addr, async_adv_n, async_cre, async_ce_n,
   async_oe_n, async_we_n, async_lb_n, async_ub_n,
   // Inouts
   dq,
   // Inputs
   clk, rst_b, cr__addr, cr__data_in, cr__read, cr__write, o_wait
   );

   localparam [2:0]
     STATE_STANDBY = 3'd0,
     STATE_READ_INIT = 3'd1,
     STATE_READ_WAIT = 3'd2,
     STATE_WRITE_IDLE = 3'd3,
     STATE_WRITE_INIT = 3'd4,
     STATE_WRITE_WAIT = 3'd5,
     STATE_WRITE_END = 3'd6;
   
   /// INTERFACE ///

   // Control interface
   output reg        async_cr__wait;
   input             clk, rst_b;
   input [23:0]      cr__addr;
   input [15:0]      cr__data_in;
   input 	     cr__read;
   input 	     cr__write;

   // Pre-muxed device interface
   output reg [23:1] async_addr;
   output reg 	     async_adv_n;
   output reg 	     async_cre;
   output reg 	     async_ce_n;
   output reg 	     async_oe_n;
   output reg 	     async_we_n;
   output reg 	     async_lb_n;
   output reg 	     async_ub_n;
   inout [15:0]      dq;
   input 	     o_wait;

   /// INTERNAL SIGNALS ///

   reg [2:0] 	 state;
   reg [1:0] 	 wait_counter;
   reg [15:0] 	 dq_drv;

   /// LOGIC ///

   assign dq = dq_drv;

   always @* begin
      async_cr__wait = (state != STATE_STANDBY) || cr__read || cr__write;
   end
   
   always @(posedge clk or negedge rst_b) begin
      if (!rst_b) begin
	 state <= STATE_STANDBY;
	 wait_counter <= 2'd0;

	 async_adv_n <= 1'b0;
	 async_ce_n <= 1'b1;
	 async_cre <= 1'b0;
	 async_oe_n <= 1'b0;
	 async_lb_n <= 1'b0;
	 async_ub_n <= 1'b0;
      end else begin
	 case (state)
	   STATE_STANDBY: begin
	      if (cr__read) begin
		 state <= STATE_READ_INIT;
		 async_addr <= cr__addr[23:1];
	      end else if (cr__write) begin
		 state <= STATE_WRITE_IDLE;
		 async_addr <= cr__addr[23:1];
	      end

	      async_ce_n <= 1'b1;
	      async_we_n <= 1'b1;
	      dq_drv <= 16'bz;
	   end
	   STATE_READ_INIT: begin
	      state <= STATE_READ_WAIT;
	      async_ce_n <= 1'b0;
	      wait_counter <= 2'd0;
	   end
	   STATE_READ_WAIT: begin
	      wait_counter <= wait_counter + 1;
	      if (wait_counter == 2'd3)
		state <= STATE_STANDBY;
	   end
	   STATE_WRITE_IDLE: begin
	      state <= STATE_WRITE_INIT;
	      async_ce_n <= 1'b0;
	      dq_drv <= cr__data_in;
	   end
	   STATE_WRITE_INIT: begin
	      state <= STATE_WRITE_WAIT;
	      async_we_n <= 1'b0;
	      wait_counter <= 2'd0;
	   end
	   STATE_WRITE_WAIT: begin
	      wait_counter <= wait_counter + 1;
	      if (wait_counter == 2'd2)
		state <= STATE_WRITE_END;
	   end
	   STATE_WRITE_END: begin
	      state <= STATE_STANDBY;
	      async_ce_n <= 1'b1;
	      dq_drv <= 16'bz;
	   end
	 endcase
      end
   end
   
endmodule