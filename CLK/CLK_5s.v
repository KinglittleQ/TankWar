module CLK_5s (
    input wire clk_100mhz,
    output reg clk_5s
    ); 

wire clk_500ms;
reg[9:0] cnt;

initial begin
	cnt = 10'd0;
	clk_5s = 1'b0;
end

CLK_500ms M0 (
    .clk_100mhz(clk_100mhz),
    .clk_500ms(clk_500ms)
    );


always @(posedge clk_500ms) begin
    if (cnt != 10'd4) begin
        cnt <= cnt + 10'd1;
    end
    else begin
        cnt <= 10'd0;
        clk_5s <= ~clk_5s;
    end
end


endmodule