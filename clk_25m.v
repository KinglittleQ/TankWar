//////////////////////////////
//
//
//   Note:  no simulation yet !!!
//
//
/////////////////////////////


module clk_25m (
    input wire clk_100mhz,
    output reg clk_25mhz
    );

reg[2:0] cnt;

initial begin
    cnt <= 2'b0;
    clk_25mhz <= 1'b0;
end

always @(posedge clk_100mhz) begin
    if (cnt < 2'b10) begin
        cnt <= cnt + 2'b01;        
    end
    else begin
        clk_25mhz = ~clk_25mhz;
        cnt <= 2'b00; 
    end
end

endmodule