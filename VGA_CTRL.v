//////////////////////////////
//
//
//   Not be tested yet !!!
//
//
/////////////////////////////




module VGA_CTRL (
    input wire clk, // 25mhz
    input wire RSTN,

    output wire hsync, // horizontal synchronization signal
    output wire vsync, // vertical synchronization signal

    output wire[9:0] pixel_x, // horizontal pos
    output wire[9:0] pixel_y  // vertical pos
    );


reg[9:0] x, y;

initial begin
	x <= 10'd0;
	y <= 10'd0;
end

always @(posedge clk or posedge RSTN) begin
    if (RSTN)
        x <= 10'd0;
    else begin
        if (x == 10'd799) begin
            x <= 10'd0;
        end
        else 
            x <= x + 10'd1;
    end
end

always @(posedge clk or posedge RSTN) begin
    if (RSTN)
        y <= 10'd0;
    else begin
        if (x == 10'd799)
            if (y == 10'd524)
                y <= 10'd0;
            else 
                y <= y + 10'd1;
    end
end


assign hsync = (x > 10'd95);
assign vsync = (y > 10'd1);

assign pixel_x = x - 10'd142;
assign pixel_y = y - 10'd35;


endmodule