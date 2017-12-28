module PS2 (
    input clk_100mhz, // 100mhz
    input ps2_data,
    input ps2_clk,

    output reg[7:0] ascii,
    output reg press // if key is pressed, ouput 1
    );

reg[7:0] clk_filter, data_filter;
reg clk, data;
reg[3:0] count;

reg[2:0] clk_sync;
reg[2:0] ready_sync;
reg ready;

reg[7:0] ready_data, prev_data;
reg[10:0] tmp_data;

initial begin
    clk = 1'b0;
    data = 1'b0;
    count = 4'b0;
    clk_sync = 3'b1;
    ready = 1'b0;
end

always @(posedge clk_100mhz) begin
    // clk_filter <= {ps2_clk, clk_filter[7:1]};
    // data_filter <= {ps2_data, data_filter[7:1]};

    // if (clk_filter == 8'b11111111) begin
    //     clk <= 1'b1;
    // end
    // else if (clk_filter == 8'b00000000) begin
    //     clk <= 1'b0;
    // end

    // if (data_filter == 8'b11111111) begin
    //     data <= 1'b1;
    // end
    // else if (data_filter == 8'b00000000) begin
    //     data <= 1'b0;
    // end

    // clk_sync <= {clk, clk_sync[2:1]};

    clk_sync <= {ps2_clk, clk_sync[2:1]};
    ready_sync <= {ready, ready_sync[2:1]};
end

assign neg_edge = (~clk_sync[1]) & clk_sync[0];

always @(posedge clk_100mhz) begin
    if (neg_edge || count == 4'd11) begin
        if (count == 4'd11) begin
            count <= 4'd0;
            ready <= 1'b1;
            prev_data <= ready_data;
            ready_data <= tmp_data[8:1];
        end
        else begin
            tmp_data[count] <= ps2_data;
            count <= count + 4'd1;
            ready <= 1'b0;
        end
    end
end

assign ready_edge = ~ready_sync[0] & ready_sync[1];

always @(posedge clk_100mhz) begin
    if (ready_edge) begin
        if (prev_data == 8'hF0) begin
            press <= 1'b0;
            ascii <= 8'h00;
        end
        else begin
            press <= 1'b1;
            case (ready_data)
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
end






endmodule