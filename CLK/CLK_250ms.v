module CLK_250ms (
    input wire clk_100mhz,
    output reg clk_250ms
    );

reg[31:0] cnt;
initial begin
    cnt = 32'd0;
end

always @(posedge clk_100mhz) begin
    if (cnt == 32'd12500000) begin
        cnt <= 32'd0;
        clk_250ms <= ~clk_250ms;
    end
    else begin
        cnt <= cnt + 32'd1;
    end
end


endmodule