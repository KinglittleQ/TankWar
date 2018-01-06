module Seg7_Dev16(
    input wire[1:0] Scan,
    input wire[15:0] Hexs,

    input wire[3:0] point,
    input wire[3:0] LES,
    output wire[3:0] AN,
    output wire[7:0] SEGMENT
    );


wire[3:0] Hex;
wire p;

ScanSync M2 (
    .Scan(Scan),
    .Hexs(Hexs),
    .point(point),
    .LES(LES),
    .Hex(Hex),
    .LE(LE_out),
    .p(p),
    .AN(AN)
    );

MyMC14495 M1 (
    .D0(Hex[0]),
    .D1(Hex[1]),
    .D2(Hex[2]),
    .D3(Hex[3]),
    .LE(LE_out),
    .point(p),
    .a(SEGMENT[0]),
    .b(SEGMENT[1]),
    .c(SEGMENT[2]),
    .d(SEGMENT[3]),
    .e(SEGMENT[4]),
    .f(SEGMENT[5]),
    .g(SEGMENT[6]),
    .p(SEGMENT[7])
    );

endmodule
