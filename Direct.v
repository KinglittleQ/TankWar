module Direct (
    input wire clk,
    input wire[7:0] ascii,
    input wire press,
    output reg[2:0] direct,
    output reg moving,
    output reg shoot
    );

parameter LEFT = 3'b000;
parameter RIGHT = 3'b001;
parameter UP = 3'b010;
parameter DOWN = 3'b011;


always @(posedge clk) begin
    if (press) begin
        case (ascii)
            8'h61: begin
                direct <= LEFT;
                moving <= 1'b1;
                shoot <= 1'b0;
            end 
            8'h64: begin
                direct <= RIGHT;
                moving <= 1'b1;
                shoot <= 1'b0;
            end 
            8'h77: begin
                direct <= UP;
                moving <= 1'b1;
                shoot <= 1'b0;
            end 
            8'h73: begin
                direct <= DOWN;
                moving <= 1'b1;
                shoot <= 1'b0;
            end
            8'h6A: begin
                shoot <= 1'b1;
                moving <= 1'b0;
                direct <= direct;
            end
            default: begin
                direct <= direct;
                moving <= 1'b0;
                shoot <= 1'b0;
            end
        endcase
    end
    else begin
        moving <= 1'b0;
        shoot <= 1'b0;
        direct <= direct;
    end
end

endmodule