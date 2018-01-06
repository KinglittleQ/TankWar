module DisplayScore (
    input wire clk,
    input wire[15:0] score,
    output [7:0] segment,
    output [3:0] AN
    );


wire[31:0] div;
clkdiv M1 (
    .clk(clk),
    .rst(1'b0),
    .clkdiv(div)
);

Seg7_Dev16 M0 (
	.Scan(div[18:17]),
    .Hexs(score),
    .point(4'b1111),
    .LES(4'b0000),
    .AN(AN),
    .SEGMENT(segment)
);


endmodule