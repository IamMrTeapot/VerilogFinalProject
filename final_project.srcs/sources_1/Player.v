`define START 2'b00
`define SERVE 2'b01
`define PLAY 2'b10
`define DONE 2'b11

module Player(clk, rst, state, keyboard, player, posX, posY);
    input clk, rst, player;
    input [1:0] state;
    input [1:0] keyboard;
    output wire [9:0] posX;
    output reg [9:0] posY;
    
    reg [18:0] counter, next_counter;
    reg [9:0] nextPosY;
    
    assign posX = (player == 1'b1) ? 10'd573: 10'd57;
    
    always @(posedge clk) begin
        if(rst==1'b1) begin
            posY <= 10'd232;
            counter <= 19'd0;
        end
        else begin
            posY <= nextPosY;
            counter <= next_counter;
        end
    end
    
    always @(*) begin
        case(state) 
            `START: begin
                nextPosY = 10'd232;
                next_counter =19'd0;
            end
            `DONE: begin
                nextPosY = 10'd232;
                next_counter = 19'd0;
            end
            default: begin
                next_counter = counter + 1'b1;
                if(counter==19'b111_1111_1111_1111_1111) begin
                    if(keyboard==2'b01 && posY < 10'd404) begin
                        nextPosY = posY + 1'b1;
                    end
                    else if(keyboard==2'b10 && posY > 10'd124) begin
                        nextPosY = posY - 1'b1;
                    end
                    else begin
                        nextPosY = posY;
                    end
                end
                else begin
                    nextPosY = posY;
                end
            end
        endcase
    end
endmodule
