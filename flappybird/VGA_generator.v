`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:30 11/24/2018 
// Design Name: 
// Module Name:    VGA_generator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGA_generator(RGB_in, vga_r, vga_g, vga_b);
    input wire [7: 0] RGB_in;
    output wire [2: 0] vga_r, vga_g;
    output wire [1: 0] vga_b;
	 
    assign vga_r = RGB_in[7: 5];
    assign vga_g = RGB_in[4: 2];
    assign vga_b = RGB_in[1: 0];

endmodule

