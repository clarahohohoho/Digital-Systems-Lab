`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:07:05 04/10/2014 
// Design Name: 
// Module Name:    X_RAM 
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
// This manages the storage of the moving pipe X coordinates. Pipes are preprogrammed.
//	Outputs the address of the current pipe in scope, so that the corresponding Y coordinates can be read
// from Y_ROM.
// I guess the clock would be at whatever rate ... not sure actually;
// Coordinate is the left edge of the pipe. Right edge is calculated in obstacle logic.
//////////////////////////////////////////////////////////////////////////////////
module X_RAM_NOREAD(clk,reset,Start, Stop, Ack, out_pipe, out_coin,
	X_Edge_OO_L,
	X_Edge_O1_L,
	X_Edge_O2_L,
	X_Edge_O3_L,
	X_Edge_O4_L,
	
	X_Edge_OO_R,
	X_Edge_O1_R,
	X_Edge_O2_R,
	X_Edge_O3_R,
	X_Edge_O4_R,
	
	X_Coin_OO_L,
	X_Coin_O1_L,
	X_Coin_O2_L,
	X_Coin_O3_L,
	X_Coin_O4_L,
	X_Coin_OO_R,
	X_Coin_O1_R,
	X_Coin_O2_R,
	X_Coin_O3_R,
	X_Coin_O4_R,
	
	shift_Coin,
	
	Q_Initial,
	Q_Count,
	Q_Stop);

 input clk,reset;
 input Start, Stop, Ack;
 
 output [9:0] X_Edge_OO_L;
 output [9:0] X_Edge_O1_L;
 output [9:0] X_Edge_O2_L;
 output [9:0] X_Edge_O3_L;
 output [9:0] X_Edge_O4_L;
 
 output [9:0] X_Edge_OO_R;
 output [9:0] X_Edge_O1_R;
 output [9:0] X_Edge_O2_R;
 output [9:0] X_Edge_O3_R;
 output [9:0] X_Edge_O4_R;
 
 output [9:0] X_Coin_OO_L;
 output [9:0] X_Coin_O1_L;
 output [9:0] X_Coin_O2_L;
 output [9:0] X_Coin_O3_L;
 output [9:0] X_Coin_O4_L;
 output [9:0] X_Coin_OO_R;
 output [9:0] X_Coin_O1_R;
 output [9:0] X_Coin_O2_R;
 output [9:0] X_Coin_O3_R;
 output [9:0] X_Coin_O4_R;
 
 output [1:0] shift_Coin;
 
 
 output	[2:0] out_pipe;
 output  [2:0] out_coin;
 output 	Q_Initial, Q_Count, Q_Stop;
 
 reg [9:0] array_X_Left [4:0]; // 2D array X to store five 10 bit pipes
 reg [9:0] array_X_Right [4:0]; // 2D array X to store five 10 bit pipes
 reg [9:0] array_X_Coin_Left [4:0]; // 2D array X to store five 10 bit coins
 reg [9:0] array_X_Coin_Right [4:0]; // 2D array X to store five 10 bit coins
 reg [2:0] out_pipe;
 reg [2:0] out_coin;
 
 reg shift_Coin;
 
 reg[2:0] state;
 
 parameter PIPE_WIDTH = 61;
 parameter COIN_WIDTH = 20;
 parameter INTERVAL = 142;
 
 localparam
			QInitial = 3'b001,
			QCount	= 3'b010,
			QStop = 3'b100,
			UNK		= 3'bXXX;
	
	assign {Q_Stop, Q_Count,
			Q_Initial } = state;
			
	parameter X0_init = 0;
	parameter X1_init = INTERVAL;
	parameter X2_init = 2*INTERVAL;
	parameter X3_init = 3*INTERVAL;
	parameter X4_init = 4*INTERVAL;
	
	parameter X0_init_2 = PIPE_WIDTH;
	parameter X1_init_2 = PIPE_WIDTH + INTERVAL;
	parameter X2_init_2 = PIPE_WIDTH + 2*INTERVAL;
	parameter X3_init_2 = PIPE_WIDTH + 3*INTERVAL;
	parameter X4_init_2 = PIPE_WIDTH + 4*INTERVAL;
	
	//coin
	parameter X0_init_coin = 0;
	parameter X1_init_coin = INTERVAL;
	parameter X2_init_coin = 2*INTERVAL;
	parameter X3_init_coin = 3*INTERVAL;
	parameter X4_init_coin = 4*INTERVAL;
	
	//coin
	parameter X0_init_coin_2 = COIN_WIDTH;
	parameter X1_init_coin_2 = COIN_WIDTH + INTERVAL;
	parameter X2_init_coin_2 = COIN_WIDTH + 2*INTERVAL;
	parameter X3_init_coin_2 = COIN_WIDTH + 3*INTERVAL;
	parameter X4_init_coin_2 = COIN_WIDTH + 4*INTERVAL;
	
	// pipe order
	//reg [1:0] out_temp_0; 
	reg [2:0] out_temp_1;
	reg [2:0] out_temp_2;
	reg [2:0] out_temp_3;
	reg [2:0] out_temp_4;
	
	// coin order
	//reg [1:0] out_coin_0; 
	reg [2:0] out_coin_1;
	reg [2:0] out_coin_2;
	reg [2:0] out_coin_3;
	reg [2:0] out_coin_4;

integer i;
 always @ (posedge clk, posedge reset)
	begin  : X_RAM_logic
		if(reset)
		begin
			state <= QInitial;
		end
		
		else
		begin
			case(state)	 
	 		
				QInitial:
				begin
				
						array_X_Left[0] <= X0_init;
						array_X_Left[1] <= X1_init;
						array_X_Left[2] <= X2_init;
						array_X_Left[3] <= X3_init;
						array_X_Left[4] <= X4_init;
						
						array_X_Right[0] <= X0_init_2;
						array_X_Right[1] <= X1_init_2;
						array_X_Right[2] <= X2_init_2;
						array_X_Right[3] <= X3_init_2;
						array_X_Right[4] <= X4_init_2;
						
						// Coins
						array_X_Coin_Left[0] <= X0_init_coin;
						array_X_Coin_Left[1] <= X1_init_coin;
						array_X_Coin_Left[2] <= X2_init_coin;
						array_X_Coin_Left[3] <= X3_init_coin;
						array_X_Coin_Left[4] <= X4_init_coin;
						
						array_X_Coin_Right[0] <= X0_init_coin_2;
						array_X_Coin_Right[1] <= X1_init_coin_2;
						array_X_Coin_Right[2] <= X2_init_coin_2;
						array_X_Coin_Right[3] <= X3_init_coin_2;
						array_X_Coin_Right[4] <= X4_init_coin_2;
						
						out_pipe <= 2; // The first pipe in scope is 2 because that's just to the right of the bird.
						out_temp_1 <= 3;
						out_temp_2 <= 4;
						out_temp_3 <= 0;
						out_temp_4 <= 1;
						
						out_coin <= 2; // The first coin in scope is 2 because that's just to the right of the bird.
						out_coin_1 <= 3;
						out_coin_2 <= 4;
						out_coin_3 <= 0;
						out_coin_4 <= 1;
						
					if(Start) // we're startin' folks
						state <= QCount;
				end	
			
				QCount:
				begin
					if(Stop)
					begin
						state <= QStop;
					end
						for(i = 0; i < 5; i = i + 1) // Then we shift each pipe by 1 pixel
						begin
							array_X_Left[i] <= array_X_Left[i]-10'd1;
							array_X_Right[i] <= array_X_Right[i]-10'd1;
							array_X_Coin_Left[i] <= array_X_Coin_Left[i]-10'd1;
							array_X_Coin_Right[i] <= array_X_Coin_Right[i]-10'd1;
							if(array_X_Left[i] == 0)
							begin
								array_X_Left[i] <= 0;
							end
								
							if(array_X_Right[i] == 0)
							begin
								array_X_Left[i] <= 10'd640;
								array_X_Right[i] <= 10'd640 + PIPE_WIDTH;
							end
							if(array_X_Coin_Left[i] == 0)
							begin
								array_X_Coin_Left[i] <= 0;
							end
							
							if(array_X_Coin_Right[i] == 0)
							begin
								array_X_Coin_Left[i] <= 10'd640 + PIPE_WIDTH - COIN_WIDTH;
								array_X_Coin_Right[i] <= 10'd640 + PIPE_WIDTH;
							end
							
						end
				
						if(array_X_Right[out_pipe] < 230) // if current pipe is going out of scope 
						begin // move on to the next pipe
							out_pipe <= out_pipe + 1;
							if(out_pipe == 4)
								out_pipe <= 0;
							
							out_temp_1 <= out_temp_1 + 1;
							if(out_temp_1 == 4)
								out_temp_1 <= 0;
								
							out_temp_2 <= out_temp_2 + 1;
							if(out_temp_2 == 4)
								out_temp_2 <= 0;
								
							out_temp_3 <= out_temp_3 + 1;
							if(out_temp_3 == 4)
								out_temp_3 <= 0;
								
							out_temp_4 <= out_temp_4 + 1;
							if(out_temp_4 == 4)
								out_temp_4 <= 0;	
							
						end
						
						// Coin
						if(array_X_Coin_Right[out_coin] < 230) // if current coin is going out of scope 
						begin // move on to the next coin
							out_coin <= out_coin + 1;
							if(out_coin == 4)
								out_coin <= 0;
							
							out_coin_1 <= out_coin_1 + 1;
							if(out_coin_1 == 4)
								out_coin_1 <= 0;
								
							out_coin_2 <= out_coin_2 + 1;
							if(out_coin_2 == 4)
								out_coin_2 <= 0;
								
							out_coin_3 <= out_coin_3 + 1;
							if(out_coin_3 == 4)
								out_coin_3 <= 0;
								
							out_coin_4 <= out_coin_4 + 1;
							if(out_coin_4 == 4)
								out_coin_4 <= 0;
						end
						
						if(array_X_Coin_Right[out_coin] == 230)
							// Give shift signal to coin
							shift_Coin <= 1;
						else shift_Coin <= 0;
				
				end // COUNT_EN
			
				QStop:
				begin
					if(Ack)
						state <= QInitial;
				end

				default:
					state <= UNK;
			endcase
		end
	end

 
 assign X_Edge_OO_L = array_X_Left[out_pipe];
 assign X_Edge_O1_L = array_X_Left[out_temp_1];
 assign X_Edge_O2_L = array_X_Left[out_temp_2];
 assign X_Edge_O3_L = array_X_Left[out_temp_3];
 assign X_Edge_O4_L = array_X_Left[out_temp_4];
 
 assign X_Edge_OO_R = array_X_Right[out_pipe];
 assign X_Edge_O1_R = array_X_Right[out_temp_1];
 assign X_Edge_O2_R = array_X_Right[out_temp_2];
 assign X_Edge_O3_R = array_X_Right[out_temp_3];
 assign X_Edge_O4_R = array_X_Right[out_temp_4];
 
 assign X_Coin_OO_L = array_X_Coin_Left[out_coin];
 assign X_Coin_O1_L = array_X_Coin_Left[out_coin_1];
 assign X_Coin_O2_L = array_X_Coin_Left[out_coin_2];
 assign X_Coin_O3_L = array_X_Coin_Left[out_coin_3];
 assign X_Coin_O4_L = array_X_Coin_Left[out_coin_4];
 
 assign X_Coin_OO_R = array_X_Coin_Right[out_coin];
 assign X_Coin_O1_R = array_X_Coin_Right[out_coin_1];
 assign X_Coin_O2_R = array_X_Coin_Right[out_coin_2];
 assign X_Coin_O3_R = array_X_Coin_Right[out_coin_3];
 assign X_Coin_O4_R = array_X_Coin_Right[out_coin_4];
 
endmodule
