module PS2 (
    input clk_100mhz,
    input ps2_clk,
    input ps2_data,
    output reg press,
    output reg[7:0] ascii
    );

wire[7:0] prev_data, data;
wire ready;
ps2_keyboard M0 (
    .clk(clk_100mhz),
    .clrn(1'b1),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .rdn(1'b0),
    .data(data),
    .prev_data(prev_data),
    .ready(ready),
    .overflow()
    );

always @(posedge clk_100mhz) begin
    if (ready) begin
        if (prev_data != 8'hF0) begin
            press <= 1'b1;
        end
        else begin
            press <= 1'b0;
        end
        
        case (data)
            8'h1c: ascii <= 8'h61; // a
            8'h32: ascii <= 8'h62; // b
            8'h21: ascii <= 8'h63; // c
            8'h23: ascii <= 8'h64; // d
            8'h24: ascii <= 8'h65; // e
            8'h2b: ascii <= 8'h66; // f
            8'h34: ascii <= 8'h67; // g
            8'h33: ascii <= 8'h68; // h
            8'h43: ascii <= 8'h69; // i
            8'h3b: ascii <= 8'h6A; // j
            8'h42: ascii <= 8'h6B; // k
            8'h4b: ascii <= 8'h6C; // l
            8'h3a: ascii <= 8'h6D; // m
            8'h31: ascii <= 8'h6E; // n
            8'h44: ascii <= 8'h6F; // o
            8'h4d: ascii <= 8'h70; // p
            8'h15: ascii <= 8'h71; // q
            8'h2d: ascii <= 8'h72; // r
            8'h1b: ascii <= 8'h73; // s
            8'h2c: ascii <= 8'h74; // t
            8'h3c: ascii <= 8'h75; // u
            8'h2a: ascii <= 8'h76; // v
            8'h1d: ascii <= 8'h77; // w
            8'h22: ascii <= 8'h78; // x
            8'h35: ascii <= 8'h79; // y
            8'h1a: ascii <= 8'h7A; // z
            8'h45: ascii <= 8'h30; // 0
            8'h16: ascii <= 8'h31; // 1
            8'h1e: ascii <= 8'h32; // 2
            8'h26: ascii <= 8'h33; // 3
            8'h25: ascii <= 8'h34; // 4
            8'h2e: ascii <= 8'h35; // 5
            8'h36: ascii <= 8'h36; // 6
            8'h3d: ascii <= 8'h37; // 7
            8'h3e: ascii <= 8'h38; // 8
            8'h46: ascii <= 8'h39; // 9
            8'h29: ascii <= 8'h20; // SPACE
            8'h66: ascii <= 8'h08; // BKSP
            8'h5a: ascii <= 8'h0D; // Enter
            default: ascii <= 8'h00;
        endcase
    end
end

endmodule