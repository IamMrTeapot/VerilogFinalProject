`define START 2'b00
`define SERVE 2'b01
`define PLAY 2'b10
`define DONE 2'b11

`define PLAYING 2'b00
`define PLAYER1WIN 2'b01
`define PLAYER2WIN 2'b10

`define BLACK 12'h000
`define WHITE 12'hfff
`define RED 12'hf23
`define YELLOW 12'hfc0
`define BLUE 12'h12f
`define PINK 12'hf58

module pixel_gen(
   input [9:0] x,
   input clk,
   input valid,
   input [9:0] y,
   input [9:0]ballX,
   input [9:0]ballY,
   input [9:0]posX1,
   input [9:0]posX2,
   input [8:0]posY1,
   input [8:0]posY2,
   input [3:0]num3,
   input [3:0]num2,
   input [3:0]num1,
   input [3:0]num0, 
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue,
   output BouncingObject
   );
reg ball_inX;
reg ball_inY;

parameter border_width = 5;

wire game_area = (x >= 55 && x <= 640-55) && (y >= 117 && y <= 480-29);
wire border =  game_area && (y >= 117 && y <= 117 + border_width ) || ( y <= 451 && y >= 451 - border_width);
wire paddle1 = ((x>=posX1+8) && (x<=posX1+18) &&( y>=posY1+8)&& ( y<=posY1+48));
wire paddle2 = ((x>=posX2+8) && (x<=posX2+18) &&( y>=posY2+8) && ( y<=posY2+48));

wire [11:0] text_rgb;
wire [3:0] text_on;

pong_text text_show(
    .clk(clk),
    .dig_left_1(num3),
    .dig_left_0(num2),
    .dig_right_1(num1),
    .dig_right_0(num0),
    .x(h_cnt),
    .y(v_cnt),
    .text_on(text_on),
    .text_rgb(text_rgb)
);

assign  BouncingObject = border | paddle1 | paddle2 ; // active if the border or paddle is redrawing itself
always @(posedge clk)
if(ball_inX==0) ball_inX <= (x==ballX) & ball_inY; else ball_inX <= !(x == ballX+8);


always @(posedge clk)
if(ball_inY==0) ball_inY <= ( y==ballY); else ball_inY <= !( y==ballY+8);

wire ball = ball_inX & ball_inY;

always @(*) begin
if (valid)
    if(text_on!=4'b0000)
        {vgaRed, vgaGreen, vgaBlue} = `WHITE;
    else if(border)
        {vgaRed, vgaGreen, vgaBlue} = `RED;
    else if(paddle1|| paddle2)
        {vgaRed, vgaGreen, vgaBlue} = `WHITE;
    else if(ball)
        {vgaRed, vgaGreen, vgaBlue} = `PINK;
    else if(game_area)
        {vgaRed, vgaGreen, vgaBlue} = `BLUE;
    else
        {vgaRed, vgaGreen, vgaBlue} = `YELLOW;
else 
    {vgaRed, vgaGreen, vgaBlue} = `BLACK;
end

endmodule