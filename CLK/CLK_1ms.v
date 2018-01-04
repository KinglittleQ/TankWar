/////////////////////////
//
//  No simulation yet !!!
//
////////////////////////

module CLK_1ms (
    input clk_100mhz,
    output reg clk_1ms
    );

reg[31:0] cnt;

initial begin
    cnt <= 32'b0;
    clk_1ms <= 1'b0;
end


always @(posedge clk_100mhz) begin
    if (cnt < 32'd49999) begin
        cnt <= cnt + 32'd1;
    end
    else begin
        cnt <= 32'd0;
        clk_1ms <= ~clk_1ms;
    end
end

endmodule 