module TankWar (
    input wire clk_100mhz,
    // input wire shoot,
    input wire RSTN,
    
    input wire ps2_clk,
    input wire ps2_data,

    output wire Buzzer,
    
    output wire hsync,
    output wire vsync,
    output wire[3:0] red,
    output wire[3:0] green,
    output wire[3:0] blue


    );

wire clk_25mhz;
wire[9:0] pixel_x, pixel_y;
wire[3:0] category;
wire[2:0] moving_direct;
wire moving;
wire[7:0] ascii;
wire press;
wire rst;
wire shoot;

assign Buzzer = 1'b1;


CLK_25mhz M0 (
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

// modify
Direct M2 (
    .clk(clk_100mhz),
    .ascii(ascii),
    .press(press),
    .direct(moving_direct),
    .moving(moving),
    .shoot(shoot)
    );


GameLoop M3 (
    .clk_100mhz(clk_100mhz),
    .direct(moving_direct),
    .moving(moving),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .shoot(shoot),
    .category(category)
    );

Display M4 (
    .clk(clk_100mhz),
    .category(category),
    .red(red),
    .green(green),
    .blue(blue)
    );

PS2 M5 (
    .clk_100mhz(clk_100mhz),
    .ps2_data(ps2_data),
    .ps2_clk(ps2_clk),
    .ascii(ascii),
    .press(press)
    );

// PS2_OTHER M5 (
//     .clk25(clk_25mhz),
//     .PS2C(ps2_clk),
//     .PS2D(ps2_data),
//     .press(press),
//     .ascii(ascii)
//     );

Anti_jitter M6 (
    .clk_100mhz(clk_100mhz),
    .RSTN(RSTN),
    .rst(rst)
    );

endmodule