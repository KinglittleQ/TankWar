module TankWar (
    input wire clk,       // clock
    input wire RSTN,      // reset
    input wire BTN[3:0],  // 0 - left  1 - right  2 - up  3 - down
    input wire shoot_btn, // shoot


    output wire r,
    output wire g,
    output wire b,
    output wire hsync,
    output wire vsync
    );

parameter LEFT = 2'b00;
parameter RIGHT = 2'b01;
parameter UP = 2'b10;
parameter DOWN = 2'b11;

wire[9:0] pixel_x;
wire[9:0] pixel_y;
wire[2:0] direct;
wire shoot;

// get direction and judge if shoot or not
GET_OPERATOR M1 (

    );

wire[2:0] category; // the category of the pixel : None, Tank, Bullet, Wall...
wire[9:0] address;  // the pixel address in the picture which stores in RAM

// main module of the game
GAME_RUN M2 (
    .clk(clk),
    .RSTN(RSTN),
    .x(pixel_x),
    .y(pixel_y),

    .player_direct(direct),
    .shoot(shoot),

    .category(category),
    .address(address)
    );

// read RGB from RAM
GET_RGB M3 (
    .clk(clk),
    .category(category),
    .address(address),

    .r(r),
    .g(g),
    .b(b)
    );


endmodule