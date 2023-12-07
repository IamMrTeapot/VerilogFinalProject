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

wire border =  ( y[8:3]==0) || ( y[8:3]==59);
wire paddle1 = ((x>=posX1+8) && (x<=posX1+18) &&( y>=posY1+8)&& ( y<=posY1+48));
wire paddle2 = ((x>=posX2+8) && (x<=posX2+18) &&( y>=posY2+8) && ( y<=posY2+48)) ;

wire zero = ((x<=250)&&(x>=234)&& ( y>=200) &&( y<=204)) ||
            ((x<=250)&&(x>=234)&& ( y>=168)&& ( y<=172)) ||
            ((x>=254)&&(x<=258)&&( y<=192)&& ( y>=176)) ||
            ((x<=230)&&(x>=226)&&( y<=192)&& ( y>=176)) ;
wire zero2 = ((x>=366)&&(x<=382)&& ( y>=200) &&( y<=204)) || ((x>=366)&&(x<=382)&& ( y>=168)&& ( y<=172)) ||((x>=386)&&(x<=390)&&( y<=192)&& ( y>=176)) ||((x<=362)&&(x>=358)&&( y<=192)&& ( y>=176)) ;

wire one = (( y<=172)&&( y>=168)&&(x<=250)&&(x>=244)) ||(( y<=200)&&( y>=168)&&(x >=250)&&(x <=254));
wire one2 = (( y>=168)&&( y<=172)&&(x>=366)&&(x<=372)) ||(( y<=200)&&( y>=168)&&(x >=372)&&(x <=376));

wire two = ((x>=250)&&(x<=266)&&( y >=168)&&( y <=172)) ||((x >= 270) &&(x <= 274) && ( y >=176)&& ( y <=180)) || ((x<=266)&&(x>=258)&&( y>=184)&&( y<=188)) ||((x <= 254)&&(x >= 250)&&( y >= 192)&&( y <= 196)) || ((x>=250)&&(x<=274)&&( y >=200)&&( y <=204));
wire two2 = ((x>=366)&&(x<=382)&&( y >=168)&&( y <=172)) ||((x >= 386) &&(x <= 390) && ( y <= 180) &&( y >=176)) || ((x<=382)&&(x>=374)&&( y>=184)&&( y<=188)) ||((x <= 370)&&(x >= 366)&&( y >= 192)&&( y <= 196)) || ((x>=366)&&(x<=390)&&( y >=200)&&( y <=204));

wire three =((x>=250)&&(x<=266)&&( y>=168)&&( y<=172)) || ((x >= 270) &&(x <= 274) && ( y >= 176)&& ( y <= 180)) || ((x<=266) && (x>=258) &&( y >=184)&&( y <=188)) || ((x >=270) &&(x <=274) && ( y >= 192)&& ( y <= 196))||((x<=266) && (x>=250) && ( y >= 200)&& ( y <= 204));
wire three2 =((x>=366)&&(x<=382)&&( y>=168)&&( y<=172)) || ((x >= 386) &&(x <= 390) && ( y >= 176)&& ( y <= 180)) || ((x<=382) && (x>=374) &&( y >=184)&&( y <=188)) || ((x >= 386) &&(x <= 390) && ( y >= 192)&& ( y <= 196))||((x<=382) && (x>=366) && ( y >= 200)&& ( y <= 204));

wire four = ((x>=254) && (x<=258) && ( y<=192) && ( y>=176)) || // Vertical line on right
            ((x >= 226) && (x <= 258) && ( y >= 184) && ( y <= 188)) || // Horizontal line in middle
            ((x<=230) && (x>=226) && ( y<=192) && ( y>=184));   // Vertical line on left down
wire four2 = ((x>=370) && (x<=374) && ( y<=192) && ( y>=176)) || // Vertical line on right
            ((x >= 342) && (x <= 374) && ( y >= 184) && ( y <= 188)) || // Horizontal line in middle
            ((x<=346) && (x>=342) && ( y<=192) && ( y>=184));   // Vertical line on left down


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
else if(score1 == 3'd0)begin
     if(zero &&valid)
        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      else 
                {vgaRed, vgaGreen, vgaBlue} = 12'hfa1;
       if(score2 == 3'd0)begin
            if(zero2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b01)begin
            if(one2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b10)begin
            if(two2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b11)begin
            if(three2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else begin
            if(four2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
end
else if(score1 == 3'b01)begin
     if(one &&valid)
        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      else 
                {vgaRed, vgaGreen, vgaBlue} = 12'h000;
       if(score2 == 3'd0)begin
            if(zero2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b01)begin
            if(one2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b10)begin
            if(two2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b11)begin
            if(three2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else begin
            if(four2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
end
else if(score1 == 3'b10)begin
     if(two &&valid)
        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      else 
                {vgaRed, vgaGreen, vgaBlue} = 12'h000;
       if(score2 == 3'd0)begin
            if(zero2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b01)begin
            if(one2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b10)begin
            if(two2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b11)begin
            if(three2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else begin
            if(four2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
end
else if(score1 == 3'b11)begin
     if(three &&valid)
        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      else 
            {vgaRed, vgaGreen, vgaBlue} = 12'h000;
      if(score2 == 3'd0)begin
            if(zero2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b01)begin
            if(one2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b10)begin
            if(two2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b11)begin
            if(three2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else begin
            if(four2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
end
else if(score1 == 3'b100)begin
     if(four &&valid)
        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      else 
            {vgaRed, vgaGreen, vgaBlue} = 12'h000;
      if(score2 == 3'd0)begin
            if(zero2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b01)begin
            if(one2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b10)begin
            if(two2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else if(score2 == 3'b11)begin
            if(three2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
      else begin
            if(four2 &&valid)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
      end
end
else 
    {vgaRed, vgaGreen, vgaBlue} = 12'hfa1;
end

endmodule