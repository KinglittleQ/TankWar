module VGA_CTRL (
    input wire clk,
    input wire RSTN,

    output wire hsync, // horizontal synchronization signal
    output wire vsync, // vertical synchronization signal

    output wire[9:0] pixel_x, // horizontal pos
    output wire[9:0] pixel_y  // vertical pos
    );

parameter WIDTH = 640;
parameter HEIGHT = 480;
parameter H_SYNC_END = 96;
parameter V_SYNC_END = 2;
parameter H_PIXELS = 800;
parameter V_PIXELS = 525;
parameter H_START = 144;
parameter V_START = 35;

reg[9:0] x, y;

initial begin
	x <= 10'd0;
	y <= 10'd0;
end

always @(posedge clk or posedge RSTN) begin
    if (RSTN)
        x <= 10'd0;
    else begin
        if (x == 10'd700) begin
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
        if (x == 10'd700)
            if (y == 10'd450)
                y <= 10'd0;
            else 
                y <= y + 10'd1;
    end
end


assign hsync = (x > 10'd95);
assign vsync = (y > 10'd1);

assign pixel_x = x - 10'd223;
assign pixel_y = y - 10'd35;


endmodule