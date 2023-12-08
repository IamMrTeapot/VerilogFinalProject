`define START 2'b00
`define SERVE 2'b01
`define PLAY 2'b10
`define DONE 2'b11

`define PLAYING 2'b00
`define PLAYER1WIN 2'b01
`define PLAYER2WIN 2'b10

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
   input [2:0]score1,
   input [2:0]score2,
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue,
   output BouncingObject
   );
reg ball_inX;
reg ball_inY;

wire border =  ( y[8:3]==15) || ( y[8:3]==55);
wire paddle1 = ((x>=posX1+8) && (x<=posX1+18) &&( y>=posY1+8)&& ( y<=posY1+48));
wire paddle2 = ((x>=posX2+8) && (x<=posX2+18) &&( y>=posY2+8) && ( y<=posY2+48)) ;

assign  BouncingObject = border | paddle1 | paddle2 ; // active if the border or paddle is redrawing itself
always @(posedge clk)
if(ball_inX==0) ball_inX <= (x==ballX) & ball_inY; else ball_inX <= !(x == ballX+8);


always @(posedge clk)
if(ball_inY==0) ball_inY <= ( y==ballY); else ball_inY <= !( y==ballY+8);

wire ball = ball_inX & ball_inY;

always @(*) begin
if(valid && BouncingObject)
    {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
else if(valid && ball)
    {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
else 
    {vgaRed, vgaGreen, vgaBlue} = 12'hfa1;
end

endmodule