`timescale 1ns / 1ps

`define BLACK 12'h000
`define WHITE 12'hfff
`define RED 12'hf23
`define YELLOW 12'hfc0
`define BLUE 12'h12f
`define PINK 12'hf58

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
    wire ascii_bit, score_ball_left_on, score_ball_right_on, logo_on;

    // instantiate ascii rom
    ascii_rom ascii_unit(.clk(clk), .addr(rom_addr), .data(ascii_word));

    //score_left
    assign score_ball_left_on = ((x>=3) && (x<=125) && (y>=10) && (y<=90));
    assign row_addr_score_left = y[6:3];
    assign bit_addr_score_left = x[5:3];
    always @*
        if (x>=3 && x<=59 && y>=10 && y<=90)
            char_addr_score_left = {3'b011, dig_left_1};    // tens digit
        else if (x>=62 && x<=125 && y>=10 && y<=90)
            char_addr_score_left = {3'b011, dig_left_0};    // ones digit

    //score_right
    assign score_ball_right_on = ((x>=513) && (x<=635) && (y>=10) && (y<=90));
    assign row_addr_score_right = y[6:3];
    assign bit_addr_score_right = x[5:3];
    always @*
        if ((x>=513) && (x<=573) && (y>=10) && (y<=90))
            char_addr_score_right = {3'b011, dig_right_1};    // tens digit
        else if ((x>=575) && (x<=635) && (y>=10) && (y<=90))
            char_addr_score_right = {3'b011, dig_right_0};    // ones digit
        
   
    //logo
    assign logo_on = ((x >= 195) && (x <= 445) && (y >= 5) && (y<=95));
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
        text_rgb = `YELLOW;

        if(logo_on) begin
            char_addr = char_addr_l;
            row_addr = row_addr_l;
            bit_addr = bit_addr_l-1;
            if(ascii_bit)
                text_rgb = `PINK; 
        end  

        else if(score_ball_left_on) begin
            char_addr = char_addr_score_left;
            row_addr = row_addr_score_left;
            bit_addr = bit_addr_score_left-1;
            if(ascii_bit)
                text_rgb = `PINK; 
        end

        else if(score_ball_right_on) begin
            char_addr = char_addr_score_right;
            row_addr = row_addr_score_right;
            bit_addr = bit_addr_score_right;
            if(ascii_bit)
                text_rgb = `PINK; 
        end

        else
            text_rgb = `YELLOW;
            
    end
    
    assign text_on = {score_ball_left_on, score_ball_right_on, logo_on};
    
    // ascii ROM interface
    assign rom_addr = {char_addr, row_addr};
    assign ascii_bit = ascii_word[~bit_addr];
      
endmodule