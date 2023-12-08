`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference book: "FPGA Prototyping by Verilog Examples"
//                      "Xilinx Spartan-3 Version"
// Written by: Dr. Pong P. Chu
// Published by: Wiley, 2008
//
// Adapted for Basys 3 by David J. Marion aka FPGA Dude
//
//////////////////////////////////////////////////////////////////////////////////


module pong_text(
    input clk,
    input [3:0] dig_left_1,dig_left_0,dig_right_1,dig_right_0,
    input [9:0] x, y,
    output [3:0] text_on,
    output reg [11:0] text_rgb
    );
    
    // signal declaration
    wire [10:0] rom_addr;
    reg [6:0] char_addr, char_addr_score_left, char_addr_score_right, char_addr_l;
    reg [3:0] row_addr;
    wire [3:0] row_addr_score_left, row_addr_score_right, row_addr_l;
    reg [2:0] bit_addr;
    wire [2:0] bit_addr_score_left, bit_addr_score_right, bit_addr_l;
    wire [7:0] ascii_word;
    wire ascii_bit, game_bg_on, score_ball_left_on, score_ball_right_on, logo_on;

    // instantiate ascii rom
    ascii_rom ascii_unit(.clk(clk), .addr(rom_addr), .data(ascii_word));
   
    //game_bg
    assign game_bg_on = (x>=55) && (x<=585) && (y>=117) && (y<=451);

    //score_left
    assign score_ball_left_on = (x>=15) && (x<=115) && (y>=40) && (y<=90);
    assign row_addr_score_left = y[6:3];
    assign bit_addr_score_left = x[5:3];
    always @*
        case(x[8:6])
            4'h6 : char_addr_score_left = {3'b011, dig_left_1};    // tens digit
            4'h7 : char_addr_score_left = {3'b011, dig_left_0};    // ones digit
        endcase

    //score_right
    assign score_ball_right_on = (x>=525) && (x<=625) && (y>=40) && (y<=90);
    assign row_addr_score_right = y[6:3];
    assign bit_addr_score_right = x[5:3];
    always @*
        case(x[8:6])
            4'h6 : char_addr_score_right = {3'b011, dig_right_1};    // tens digit
            4'h7 : char_addr_score_right = {3'b011, dig_right_0};    // ones digit
        endcase
   
   //logo
    assign logo_on = (y >= 35) && (y<=95) && (3 <= x[9:6]) && (x <= 200) && (x >= 440);
    assign row_addr_l = y[6:3];
    assign bit_addr_l = x[5:3];
    always @*
        case(x[8:6])
            3'o3 :    char_addr_l = 7'h50; // P
            3'o4 :    char_addr_l = 7'h4F; // O
            3'o5 :    char_addr_l = 7'h4E; // N
            default : char_addr_l = 7'h47; // G
        endcase
    
    // mux for ascii ROM addresses and rgb
    always @* begin
        text_rgb = 12'hFC1;     
        if(game_bg_on) begin
            text_rgb = 12'h12F;
        end
        if(score_ball_left_on) begin
            char_addr = char_addr_score_left;
            row_addr = row_addr_score_left;
            bit_addr = bit_addr_score_left;
            if(ascii_bit)
                text_rgb = 12'hFA1; 
        end

        else if(score_ball_right_on) begin
            char_addr = char_addr_score_right
            row_addr = row_addr_score_right;
            bit_addr = bit_addr_score_right;
            if(ascii_bit)
                text_rgb = 12'hFA1; 
        end
        
        else if(logo_on) begin
            char_addr = char_addr_l;
            row_addr = row_addr_l;
            bit_addr = bit_addr_l;
            if(ascii_bit)
                text_rgb = 12'hFA1; 
        end     
    end
    
    assign text_on = {game_bg_on, score_ball_left_on, score_ball_right_on, logo_on};
    
    // ascii ROM interface
    assign rom_addr = {char_addr, row_addr};
    assign ascii_bit = ascii_word[~bit_addr];
      
endmodule
