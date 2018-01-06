module CLK_500ms (
    input wire clk_100mhz,
    output reg clk_500ms
    );

reg[31:0] cnt;
initial begin
	cnt = 32'd0;
	clk_500ms = 1'b0;
end

always @(posedge clk_100mhz) begin
    if (cnt >= 32'd25000000) begin
        cnt <= 32'd0;
        clk_500ms <= ~clk_500ms;
    end
    else begin
        cnt <= cnt + 32'd1;
    end
end

endmodule