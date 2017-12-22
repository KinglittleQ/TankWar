module Anti_jitter (
    input wire clk_100mhz,
    input wire RSTN,

    output reg rst
    );

reg[32:0] cnt;

initial begin
    cnt <= 32'd0;
    rst <= 1'b0;
end

always @(posedge clk_100mhz) begin
    if (RSTN) begin
        if (cnt < 32'd200000000) begin 
            cnt <= cnt + 32'd1;
        end
        else begin
            cnt <= 32'd0;
            rst <= 1'b1;
        end
    end
    else begin
        rst <= 1'b0;
        cnt <= 32'd0;
    end
end

endmodule