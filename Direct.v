module Direct (
    input wire clk_100mhz,
    input wire[3:0] BTN,
    output reg[2:0] direct,
    output reg moving
    );

parameter LEFT = 3'b000;
parameter RIGHT = 3'b001;
parameter UP = 3'b010;
parameter DOWN = 3'b011;

reg[31:0] cnt;
reg[4:0] BTN_tmp;
wire[4:0] button = {~RSTN, ~BTN[3:0]};

always @(posedge clk_100mhz) begin
    BTN_tmp <= button;
    if (BTN_tmp != button) begin
        cnt <= 32'h0;
        
    end
    case (BTN)
    4'b0001:
	 begin
        moving <= 1'b1;
        direct <= LEFT;
	 end
    4'b0010:
	 begin
        moving <= 1'b1;
        direct <= RIGHT;
	 end
    4'b0100:
	 begin
        moving <= 1'b1;
        direct <= UP;
	 end
    4'b1000:
	 begin
        moving <= 1'b1;
        direct <= DOWN;
	 end
    default:
	 begin
        moving <= 1'b0;
		  direct <= direct;
	 end
    endcase
end

endmodule