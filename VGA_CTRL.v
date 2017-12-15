module VGA_CTRL (
    input wire clk,
    input wire RSTN,

    output wire hsync, // horizontal synchronization signal
    output wire ysync, // vertical synchronization signal

    output wire pixel_x, // horizontal pos
    output wire pixel_y  // vertical pos
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


always @(posedge clk | posedge RSTN) begin
    if (RSTN)
        x <= 0;
    else begin
        if (x >= H_PIXELS) begin
            x <= 0;
        end
        else 
            x <= x + 1;
    end
end

always @(posedge clk | posedge RSTN) begin
    if (RSTN)
        y <= 0;
    else begin
        if (x >= H_PIXELS)
            if (y >= V_PIXELS)
                y <= 0;
            else 
                y <= y + 1;
    end
end


assign hsync = (x >= H_SYNC_END);
assign vsync = (y >= V_SYNC_END);

assign pixel_x = x - H_START;
assign pixel_y = y - V_START;


endmodule