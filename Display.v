module Display (
    input wire clk,
    input wire[3:0] category,

    output reg[3:0] red,
    output reg[3:0] green,
    output reg[3:0] blue
    );

parameter NONE = 4'd0;
parameter WALL = 4'd1;
parameter TANK = 4'd2;

always @(posedge clk) begin
    case (category)
    NONE:
	 begin
        red <= 4'h0;
        green <= 4'h0;
        blue <= 4'h0;
	 end
    WALL:
	 begin
        red <= 4'hf;
        green <= 4'hf;
        blue <= 4'hf;
	 end
    TANK:
	 begin
        red <= 4'hf;
        green <= 4'hf;
        blue <= 4'hf;
	 end
	 default:
	 begin
        red <= 4'h0;
        green <= 4'h0;
        blue <= 4'h0;
	 end
    endcase
end


endmodule