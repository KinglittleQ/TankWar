module Direct (
    input wire clk,
    input wire[7:0] ascii,
    input wire press,
    output reg[2:0] direct,
    output reg moving
    );

parameter LEFT = 3'b000;
parameter RIGHT = 3'b001;
parameter UP = 3'b010;
parameter DOWN = 3'b011;


always @(posedge clk) begin
    if (1'b1) begin
        moving <= 1'b1;
        case (ascii)
            8'h61: direct <= LEFT;
            8'h64: direct <= RIGHT;
            8'h77: direct <= UP;
            8'h73: direct <= DOWN;
            default: direct <= RIGHT;
        endcase
    end
    else begin
        moving <= 1'b0;
    end
end

endmodule