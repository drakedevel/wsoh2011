`include "iobus.vh"

module iobus(/*AUTOARG*/
   // Outputs
   vgaRed, vgaGreen, vgaBlue, Vsync, Hsync, bus__rddata_4a, leds,
   // Inputs
   clk, rst_b, bus__rdstrobe_3a, bus__wrstrobe_3a, bus__address_3a,
   bus__wrdata_3a, switches
   );

    input             clk, rst_b;
    input             bus__rdstrobe_3a;
    input             bus__wrstrobe_3a;
    input      [ 7:0] bus__address_3a;
    input      [31:0] bus__wrdata_3a;
    output reg [31:0] bus__rddata_4a = {32{1'bx}};

    output reg [ 7:0] leds = 0;
    input      [ 7:0] switches;
    
    parameter RECTBITS = 6;
    
    /*AUTOOUTPUT*/
    // Beginning of automatic outputs (from unused autoinst outputs)
    output		Hsync;			// From vu of vga_unit.v
    output		Vsync;			// From vu of vga_unit.v
    output [2:3]	vgaBlue;		// From vu of vga_unit.v
    output [1:3]	vgaGreen;		// From vu of vga_unit.v
    output [1:3]	vgaRed;			// From vu of vga_unit.v
    // End of automatics
    
    // Bus write logic
    reg  [RECTBITS:0] vg__addr = {(RECTBITS+1){1'bx}};
    wire [      31:0] vg__data = bus__wrdata_3a;
    wire              vg__write = bus__wrstrobe_3a && (bus__address_3a == `BUS_VGADATA);
    
    always @(posedge clk or negedge rst_b)
        if (!rst_b)
            vg__addr <= {(RECTBITS+1){1'bx}};
        else if (bus__wrstrobe_3a && (bus__address_3a == `BUS_VGAADDR))
            vg__addr <= bus__wrdata_3a[RECTBITS:0];
    
    always @(posedge clk or negedge rst_b)
        if (!rst_b)
            leds <= 8'h00;
        else if (bus__wrstrobe_3a && (bus__address_3a == `BUS_LEDS))
            leds <= bus__wrdata_3a[7:0];
    
    always @(posedge clk or negedge rst_b)
        if (!rst_b)
            bus__rddata_4a <= {32{1'bx}};
        else
            case (bus__address_3a)
            `BUS_LEDS: bus__rddata_4a <= leds;
            `BUS_SWITCHES: bus__rddata_4a <= switches;
            `BUS_VGAADDR: bus__rddata_4a <= vg__addr;
            `BUS_VGADATA: bus__rddata_4a <= 32'h1EA75417;
            default: bus__rddata_4a <= {32{1'bx}};
            endcase
    
    // Submodule instantiations
    
    vga_unit vu(/*AUTOINST*/
		// Outputs
		.Hsync			(Hsync),
		.Vsync			(Vsync),
		.vgaRed			(vgaRed[1:3]),
		.vgaGreen		(vgaGreen[1:3]),
		.vgaBlue		(vgaBlue[2:3]),
		// Inputs
		.clk			(clk),
		.rst_b			(rst_b),
		.vg__data		(vg__data[31:0]),
		.vg__addr		(vg__addr[RECTBITS:0]),
		.vg__write		(vg__write));

endmodule

/*
Local Variables:
verilog-library-directories:("." "../../vga/rtl")
End:
*/
