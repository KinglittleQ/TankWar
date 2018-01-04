module CLK_bullet (
    input clk_100mhz,
    output reg clk_bullet
    );

wire clk_1ms;
reg[31:0] cnt;

CLK_1ms CLK1 (
    .clk_100mhz(clk_100mhz),
    .clk_1ms(clk_1ms)
    );

always @(posedge clk_1ms) begin
    if (cnt < 32'd49) begin
        cnt <= cnt + 32'd1;
    end
    else begin
        cnt <= 32'd0;
        clk_bullet = ~clk_bullet;
    end
end

endmodule