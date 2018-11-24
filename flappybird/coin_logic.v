`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:41:34 04/10/2014 
// Design Name: 
// Module Name:    flappy 
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
//	Handles the logic of game states (whether flappy hits a pole).
//////////////////////////////////////////////////////////////////////////////////
module coin_logic(
	Clk,reset,
	get_Zero,
	Start, Ack, 
	X_Coin_OO_L,
	X_Coin_OO_R,
	Y_Coin_00,
	Bird_X_L, Bird_X_R, Bird_Y_T, Bird_Y_B,
	Score
	);

	// INPUTS //
	input 	Clk, reset, Start, Ack;
	input [9:0] Bird_X_L; // flappy's x
	input [9:0] Bird_Y_T; // flappy's y
	input [9:0] Bird_X_R; // flappy's x
	input [9:0] Bird_Y_B; // flappy's y
	input [9:0] X_Coin_OO_L; // 10-bit x edge of current coin (left edge)
	input [9:0] X_Coin_OO_R; // 10-bit x edge of current coin (right edge)
	input [9:0] Y_Coin_00;


	// OUTPUTS //
	output [1:0] get_Zero;
	output [9:0] Score;


	reg [1:0] get_Zero;
	reg [1:0] pre_Get_Zero;
	reg [9:0] Score;

	parameter COIN_HEIGHT = 20;

	initial get_Zero = 0;
	initial pre_Get_Zero = 0;

	always @ (posedge Clk, posedge reset)
	begin
		if(reset)
		begin
			Score = 0;
		end
		else begin
		
			if(((Bird_Y_B >= Y_Coin_00 && Bird_Y_B <= Y_Coin_00+COIN_HEIGHT) || (Bird_Y_T <= Y_Coin_00+COIN_HEIGHT && Bird_Y_T >= Y_Coin_00))
				&& (Bird_X_R > X_Coin_OO_L && Bird_X_L < X_Coin_OO_R))
				begin
					pre_Get_Zero = get_Zero;
					get_Zero = 1;
				end
			else 
			begin	
				pre_Get_Zero = get_Zero;
				get_Zero = 0;
			end
			// Add 1 Score once collected 1 coin
			if (!pre_Get_Zero && get_Zero)
				Score = Score + 4'd1;
		end
	end

	// TODO work out how to keep score as the bird passes pipes. 
	// Still need to work out logic to move from one pipe in scope to the next. That logic should go in the same place as the score so we know that when we increment the pipe,
	// we should increment the score.

endmodule
