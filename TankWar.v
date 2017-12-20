module TankWar (
    input wire clk_100mhz,
    input wire[3:0] BTN,
    // input wire shoot,
    input wire RSTN,
    
    output wire hsync,
    output wire vsync,
    output wire[3:0] red,
    output wire[3:0] green,
    output wire[3:0] blue,
    output wire Buzzer,
    output wire[4:0] K_ROW
    );

wire clk_25mhz;
wire[9:0] pixel_x, pixel_y;
wire[3:0] category;
wire[2:0] moving_direct;
wire moving;
wire[3:0] BTN_OK;
wire rst;

assign Buzzer = 1'b1;
assign K_ROW = 4'b0000;

Anti_jitter M5 (
    .clk(clk_100mhz),
    .RSTN(RSTN),
    .K_COL(BTN),
    .SW(),
    .button_out(BTN_OK),
    .button_pulse(),
    .SW_OK(),
    .K_ROW(K_ROW),
    .CR(),
    .rst(rst)
    );

CLK_25m M0 (
    .clk_100mhz(clk_100mhz),
    .clk_25mhz(clk_25mhz)
    );

VGA_CTRL M1 (
    .clk(clk_25mhz),
    .RSTN(rst),

    .hsync(hsync),
    .vsync(vsync),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y)
    ); 

Direct M2 (
    .clk_100mhz(clk_25mhz),
    .BTN(BTN_OK),
    .direct(moving_direct),
    .moving(moving)
    );


GameLoop M3 (
    .clk_100mhz(clk_25mhz),
    .direct(moving_direct),
    .moving(moving),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),

    .category(category)
    );

Display M4 (
    .clk_100mhz(clk_25mhz),
    .category(category),
    .red(red),
    .green(green),
    .blue(blue)
    );

endmodule