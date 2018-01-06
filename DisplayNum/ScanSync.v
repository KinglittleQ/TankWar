module ScanSync(
    input wire[1:0] Scan,
    input wire[15:0] Hexs,
    input wire[3:0] point,
    input wire[3:0] LES,
    output wire[3:0] Hex,
    output wire LE,
    output wire p,
    output wire[3:0] AN);

assign V5 = 1'b1;
assign G0 = 1'b0;

MUX4bit4to1 MUX1 (
    .I0({V5, V5, V5, G0}),
    .I1({V5, V5, G0, V5}),
    .I2({V5, G0, V5, V5}),
    .I3({G0, V5, V5, V5}),
    .s(Scan[1:0]),
    .o(AN[3:0])
    );

MUX4bit4to1 MUX2 (
    .I0(Hexs[3:0]),
    .I1(Hexs[7:4]),
    .I2(Hexs[11:8]),
    .I3(Hexs[15:12]),
    .s(Scan[1:0]),
    .o(Hex[3:0])
    );

wire[3:0] o;

MUX4bit4to1 MUX3 (
    .I0({LES[0], point[0], G0, G0}),
    .I1({LES[1], point[1], G0, G0}),
    .I2({LES[2], point[2], G0, G0}),
    .I3({LES[3], point[3], G0, G0}),
    .s(Scan[1:0]),
    .o(o[3:0])
    );

BUF buf1 (.I(o[3]), .O(LE));
BUF buf2 (.I(o[2]), .O(p));

endmodule