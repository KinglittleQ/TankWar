module GameLoop (
    input wire clk_100mhz,
    input wire[2:0] direct,
    input wire moving,
    input wire shoot,
    input wire[9:0] pixel_x,
    input wire[9:0] pixel_y,
    input wire rst,
	 input wire press,

    output reg[3:0] category,
    output reg[9:0] addr,
    output reg[2:0] tank_direct,
    output reg alive,
    output reg start,
    output reg[15:0] score,
    output reg player_tank
    ); 

// 650 X 480
parameter MAX_TANKS = 6'd10;           //  for test !!!
parameter MAX_BULLETS = 7'd10;         //  for test !!!

parameter WIDTH = 10'd60;
parameter HEIGHT = 10'd45;
parameter BLOCK_SIZE = 10'd10;
parameter BOUNDARY_WIDTH = 10'd10;

parameter LEFT = 3'b000;
parameter RIGHT = 3'b001;
parameter UP = 3'b010;
parameter DOWN = 3'b011;

parameter NONE = 4'd0;
parameter WALL = 4'd1;
parameter TANK = 4'd2;
parameter BULLET = 4'd3;


reg[9:0] tanks_x[MAX_TANKS : 0];
reg[9:0] tanks_y[MAX_TANKS : 0];
reg[2:0] tanks_direct[MAX_TANKS : 0];
reg[5:0] n_tanks;

reg[9:0] bullets_x[MAX_BULLETS : 0];
reg[9:0] bullets_y[MAX_BULLETS : 0];
reg[2:0] bullets_direct[MAX_BULLETS : 0];
reg[6:0] n_bullets;

reg is_player[MAX_BULLETS : 0];

integer i, j, k, m, n;

wire clk_500ms, clk_250ms, clk_5s, clk_bullet;

reg[6:0] bullets_ptr;
reg[5:0] tanks_ptr;
reg[5:0] tanks_cnt;
reg[5:0] tanks_p;

reg bullets_go;
reg tanks_go;
reg tank_turn;

reg[4:0] random_pos;
reg[1:0] random_direct;

// reg map[WIDTH * HEIGHT : 0];  // map
// reg[6:0] ri; // map
// reg[11:0] bullets_addr; // map

initial begin
    tanks_x[0] = 10'd0;
    tanks_y[0] = 10'd0;
    tanks_direct[0] = RIGHT;
    n_tanks = 6'd1;

    tanks_ptr = 6'd1;
    tanks_go = 1'b0;
    tanks_cnt = 6'd1;
    tanks_p = 6'd1;
    n_bullets = 7'd0;
    bullets_ptr = 7'd0;
    bullets_go = 1'b0;
    tank_turn = 1'b0;

    k = 7'd0;
	category = NONE;
    tank_direct = RIGHT;
    addr = 10'b0;
    alive = 1'b1;
    start = 2'b0;
    score = 16'b0;
    player_tank = 1'b0;
end

CLK_500ms CLK1 (
    .clk_100mhz(clk_100mhz),
    .clk_500ms(clk_500ms)
    );

CLK_250ms CLK2 (
    .clk_100mhz(clk_100mhz),
    .clk_250ms(clk_250ms)
    );

CLK_5s CLK3 (
    .clk_100mhz(clk_100mhz),
    .clk_5s(clk_5s)
    );

CLK_bullet CLK4 (
    .clk_100mhz(clk_100mhz),
    .clk_bullet(clk_bullet)
    );

always @(posedge clk_100mhz) begin
    random_pos <= random_pos + 1'd1;
end

reg[2:0] moving_sync;
reg[2:0] clk500_sync;
reg[2:0] shoot_sync;
reg[2:0] clk250_sync;
reg[2:0] clk5s_sync;
reg[2:0] clkbullet_sync;

always @(posedge clk_100mhz) begin
    moving_sync <= {moving, moving_sync[2:1]};
    clk500_sync <= {clk_500ms, clk500_sync[2:1]};
    shoot_sync <= {shoot, shoot_sync[2:1]};
    clk250_sync <= {clk_250ms, clk250_sync[2:1]};
    clk5s_sync <= {clk_5s, clk5s_sync[2:1]};
    clkbullet_sync <= {clk_bullet, clkbullet_sync[2:1]};
end


assign moving_edge = ~moving_sync[0] & moving_sync[1];
assign clk500_edge = ~clk500_sync[0] & clk500_sync[1];
assign shoot_edge = ~shoot_sync[0] & shoot_sync[1];
assign clk250_edge = ~clk250_sync[0] & clk250_sync[1];
assign clk5s_edge = ~clk5s_sync[0] & clk5s_sync[1];
assign clkbullet_edge = ~clkbullet_sync[0] & clkbullet_sync[1];

// bullets
always @(posedge clk_100mhz) begin

if (start) begin //---------game start----------

if (rst) begin
    n_bullets <= 7'd0;
    bullets_ptr <= 7'd0;
    bullets_go <= 1'b0;
    tanks_cnt <= 6'd1;  
end
else begin
    // shoot
    if (shoot_edge && n_bullets < MAX_BULLETS) begin
        case (tanks_direct[0])
        LEFT: begin
            if (tanks_x[0] > 10'd0) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0] - 10'd1;
                bullets_y[n_bullets] <= tanks_y[0] + 10'd1;
                bullets_direct[n_bullets] <= tanks_direct[0];
                is_player[n_bullets] <= 1'b1;
                // map[tanks_x[0] - 10'd1 + (tanks_y[0] + 10'd1) * WIDTH] <= 1'b1;  // map
            end
        end
        RIGHT: begin
            if (tanks_x[0] < WIDTH - 1) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0] + 10'd3;
                bullets_y[n_bullets] <= tanks_y[0] + 10'd1;
                bullets_direct[n_bullets] <= tanks_direct[0];
                is_player[n_bullets] <= 1'b1;
                // map[tanks_x[0] + 10'd3 + (tanks_y[0] + 10'd1) * WIDTH] <= 1'b1; // map
            end
        end
        UP: begin
            if (tanks_y[0] > 10'd0) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0] + 10'd1;
                bullets_y[n_bullets] <= tanks_y[0] - 10'd1;
                bullets_direct[n_bullets] <= tanks_direct[0];
                is_player[n_bullets] <= 1'b1;
                // map[tanks_x[0] + 10'd1 + (tanks_y[0] - 10'd1) * WIDTH] <= 1'b1; // map                
            end
        end
        DOWN: begin
            if (tanks_y[0] < HEIGHT - 1) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0] + 10'd1;
                bullets_y[n_bullets] <= tanks_y[0] + 10'd3;
                bullets_direct[n_bullets] <= tanks_direct[0];
                is_player[n_bullets] <= 1'b1;
                // map[tanks_x[0] + 10'd1 + (tanks_y[0] + 10'd3) * WIDTH] <= 1'b1;  // map
            end
        end
        endcase
    end
    // bullets move
    else if (clkbullet_edge | bullets_go) begin
        if (clkbullet_edge & ~bullets_go) begin
            bullets_go <= 1'b1;
        end

        if (bullets_ptr < n_bullets) begin
            // delete bullets
            if (bullets_x[bullets_ptr] < 0 | bullets_x[bullets_ptr] > WIDTH | bullets_y[bullets_ptr] < 0 | bullets_y[bullets_ptr] > HEIGHT) begin
                n_bullets <= n_bullets - 7'd1;
                if (n_bullets != 7'd0) begin
                    bullets_x[bullets_ptr] <= bullets_x[n_bullets - 7'd1];
                    bullets_y[bullets_ptr] <= bullets_y[n_bullets - 7'd1];
                    bullets_direct[bullets_ptr] <= bullets_direct[n_bullets - 7'd1];
                    is_player[bullets_ptr] <= is_player[n_bullets - 7'd1];
                    // map[bullets_x[bullets_ptr] + bullets_y[bullets_ptr] * WIDTH] <= 1'b0; // map
                end
            end
            else begin
                // map[bullets_x[bullets_ptr] + bullets_y[bullets_ptr] * WIDTH] <= 1'b0; // map
                case (bullets_direct[bullets_ptr])
                    LEFT: begin
                        bullets_x[bullets_ptr] <= bullets_x[bullets_ptr] - 10'd1;
                        // map[bullets_x[bullets_ptr] - 1 + bullets_y[bullets_ptr] * WIDTH] <= 1'b1; // map
                    end
                    RIGHT: begin
                        bullets_x[bullets_ptr] <= bullets_x[bullets_ptr] + 10'd1;
                        // map[bullets_x[bullets_ptr] + 1 + bullets_y[bullets_ptr] * WIDTH] <= 1'b1; // map
                    end
                    UP: begin
                        bullets_y[bullets_ptr] <= bullets_y[bullets_ptr] - 10'd1;
                        // map[bullets_x[bullets_ptr] + (bullets_y[bullets_ptr] - 1) * WIDTH] <= 1'b1; // map
                    end
                    DOWN: begin
                        bullets_y[bullets_ptr] <= bullets_y[bullets_ptr] + 10'd1;
                        // map[bullets_x[bullets_ptr] + (bullets_y[bullets_ptr] + 1) * WIDTH] <= 1'b1; // map
                    end
                endcase
                bullets_ptr <= bullets_ptr + 7'd1;
            end
        end
        else begin
            bullets_ptr <= 7'd0;
            bullets_go <= 1'b0;
        end
    end
    else if (clk250_edge && n_bullets < MAX_BULLETS) begin
        if (tanks_cnt < n_tanks && tanks_cnt != 6'd0) begin
            case (tanks_direct[tanks_cnt])
            LEFT: begin
                if (tanks_x[tanks_cnt] > 10'd0) begin
                    n_bullets <= n_bullets + 7'd1;
                    bullets_x[n_bullets] <= tanks_x[tanks_cnt] - 10'd1;
                    bullets_y[n_bullets] <= tanks_y[tanks_cnt] + 10'd1;
                    bullets_direct[n_bullets] <= LEFT;
                    is_player[n_bullets] <= 1'b0;
                    // map[tanks_x[tanks_cnt] - 1 + (tanks_y[tanks_cnt] + 1) * WIDTH] <= 1'b1; // map
                end
            end
            RIGHT: begin
                if (tanks_x[tanks_cnt] < WIDTH - 1) begin
                    n_bullets <= n_bullets + 7'd1;
                    bullets_x[n_bullets] <= tanks_x[tanks_cnt] + 10'd3;
                    bullets_y[n_bullets] <= tanks_y[tanks_cnt] + 10'd1;
                    bullets_direct[n_bullets] <= RIGHT;
                    is_player[n_bullets] <= 1'b0;
                    // map[tanks_x[tanks_cnt] + 3 + (tanks_y[tanks_cnt] + 1) * WIDTH] <= 1'b1; // map
                end
            end
            UP: begin
                if (tanks_y[tanks_cnt] > 10'd0) begin
                    n_bullets <= n_bullets + 7'd1;
                    bullets_x[n_bullets] <= tanks_x[tanks_cnt] + 10'd1;
                    bullets_y[n_bullets] <= tanks_y[tanks_cnt] - 10'd1;
                    bullets_direct[n_bullets] <= UP;
                    is_player[n_bullets] <= 1'b0;
                    // map[tanks_x[tanks_cnt] + 1 + (tanks_y[tanks_cnt] - 1) * WIDTH] <= 1'b1; // map
                end
            end
            DOWN: begin
                if (tanks_y[tanks_cnt] < HEIGHT - 1) begin
                    n_bullets <= n_bullets + 7'd1;
                    bullets_x[n_bullets] <= tanks_x[tanks_cnt] + 10'd1;
                    bullets_y[n_bullets] <= tanks_y[tanks_cnt] + 10'd3;
                    bullets_direct[n_bullets] <= DOWN;
                    is_player[n_bullets] <= 1'b0;
                    // map[tanks_x[tanks_cnt] + 1 + (tanks_y[tanks_cnt] + 3) * WIDTH] <= 1'b1; // map
                end
            end
            endcase 
            tanks_cnt <= tanks_cnt + 6'd1;       
        end
        else begin
            tanks_cnt <= 6'd1;
        end
    end
end

end //---------game start----------

end


// tanks
always @(posedge clk_100mhz) begin

if (start) begin //---------game start----------

if (rst) begin
    tanks_x[0] <= 10'd0;
    tanks_y[0] <= 10'd0;
    tanks_direct[0] <= RIGHT;
    n_tanks <= 6'd1;

    tanks_ptr <= 6'd1;
    tanks_go <= 1'b0;
    score <= 16'b0;
end
else begin
    // generate tanks
    if (clk5s_edge && (n_tanks < MAX_TANKS)) begin
        n_tanks <= n_tanks + 6'd1;
        tanks_x[n_tanks] <= {5'b00, random_pos};
        tanks_y[n_tanks] <= {5'b00, random_pos};
        tanks_direct[n_tanks] <= {1'b0, random_direct};
        random_direct <= random_direct + 2'b01;
        // tanks_direct[n_tanks] <= RIGHT;
    end


    // player's tank move
    if (moving_edge | clk500_edge) begin // player move
        if (moving) begin
            if (tanks_x[0] >= 10'd0 && tanks_x[0] < WIDTH - 10'd2 && tanks_y[0] >= 0 && tanks_y[0] < HEIGHT - 10'd2) begin
                case (direct)
                LEFT:
                    if (tanks_x[0] > 10'd0) begin
                        tanks_x[0] <= tanks_x[0] - 10'd1;
                    end
                RIGHT:
                    if (tanks_x[0] < WIDTH - 10'd3) begin
                        tanks_x[0] <= tanks_x[0] + 10'd1;
                    end
                UP:
                    if (tanks_y[0] > 10'd0) begin
                        tanks_y[0] <= tanks_y[0] - 10'd1;
                    end
                DOWN:
                    if (tanks_y[0] < HEIGHT - 10'd3) begin
                        tanks_y[0] <= tanks_y[0] + 10'd1;
                    end
                endcase 
                tanks_direct[0] <= direct;
            end
        end
    end

    n = 0;
    // enemy tanks move
    if (clk250_edge | tanks_go) begin   // enemey move
        if (clk250_edge & ~tanks_go) begin
            tanks_go <= 1'b1;
        end

        if (tanks_ptr != n_tanks) begin
            for (m = 0; m < MAX_BULLETS; m = m + 1) begin
                if (m < n_bullets && is_player[m] == 1'b1) begin
                    if (bullets_x[m] >= tanks_x[tanks_ptr] && bullets_x[m] < tanks_x[tanks_ptr] + 10'd3 && 
                        bullets_y[m] >= tanks_y[tanks_ptr] && bullets_y[m] < tanks_y[tanks_ptr] + 10'd3) begin
                        n = 1;    
                    end
                end
            end
            if (n == 1) begin
                n_tanks <= n_tanks - 6'b1;
                tanks_x[tanks_ptr] <= tanks_x[n_tanks - 6'd1];
                tanks_y[tanks_ptr] <= tanks_y[n_tanks - 6'd1];
                tanks_direct[tanks_ptr] <= tanks_direct[n_tanks - 6'd1];
                if (score[3:0] < 4'b1001)
                    score[3:0] <= score[3:0] + 4'b0001;  //-----------------------add player's score
                else if (score[7:4] < 4'b1001) begin
                    score[7:4] <= score[7:4] + 4'b0001;
                    score[3:0] <= 4'b0000;
                end
                else if (score[11:8] < 4'b1001) begin
                    score[11:8] <= score[11:8] + 4'b0001;
                    score[7:4] <= 4'b0000;
                    score[3:0] <= 4'b0000;
                end
                else if (score[15:12] < 4'b1001) begin
                    score[15:12] <= score[15:12] + 4'b0001;
                    score[11:8] <= 4'b0000;
                    score[7:4] <= 4'b0000;
                    score[3:0] <= 4'b0000;                    
                end
            end
            else begin
                case (tanks_direct[tanks_ptr])
                LEFT:
                    if (tanks_x[tanks_ptr] > 10'd0) begin
                        tanks_x[tanks_ptr] <= tanks_x[tanks_ptr] - 10'd1;
                    end
                    else begin
                        tanks_direct[tanks_ptr] <= {1'b0, random_direct};
                        random_direct <= random_direct + 2'b01;
                    end
                RIGHT: begin
                    if (tanks_x[tanks_ptr] < WIDTH - 10'd3) begin
                        tanks_x[tanks_ptr] <= tanks_x[tanks_ptr] + 10'd1;
                    end
                    else begin
                        tanks_direct[tanks_ptr] <= {1'b0, random_direct};
                        random_direct <= random_direct + 2'b01;
                    end                    
                end
                UP:
                    if (tanks_y[tanks_ptr] > 10'd0) begin
                        tanks_y[tanks_ptr] <= tanks_y[tanks_ptr] - 10'd1;
                    end
                    else begin
                        tanks_direct[tanks_ptr] <= {1'b0, random_direct};
                        random_direct <= random_direct + 2'b01;
                    end                    
                DOWN:
                    if (tanks_y[tanks_ptr] < HEIGHT - 10'd3) begin
                        tanks_y[tanks_ptr] <= tanks_y[tanks_ptr] + 10'd1;
                    end
                    else begin
                        tanks_direct[tanks_ptr] <= {1'b0, random_direct};
                        random_direct <= random_direct + 2'b01;
                    end                    
                endcase
                tanks_ptr <= tanks_ptr + 6'd1;
            end
        end
        else begin
            tanks_ptr <= 6'd1;
            tanks_go <= 1'b0;
        end
    end

    if (clk5s_edge | tank_turn) begin
        if (clk5s_edge & ~tank_turn) begin
            tank_turn <= 1'b1;
        end
        if (tanks_p < n_tanks && tanks_p != 6'd0) begin
            tanks_direct[tanks_p] <= random_direct;
            random_direct <= random_direct + 2'b01;
            tanks_p <= tanks_p + 6'd1;
        end
        else begin
            tanks_p <= 6'd1;
            tank_turn <= 1'b0;
        end
    end
end

end //---------game start----------

end

// assign in_area = (pixel_x >= BOUNDARY_WIDTH && pixel_x < WIDTH * BLOCK_SIZE && pixel_y >= BOUNDARY_WIDTH && pixel_y < HEIGHT * BLOCK_SIZE);


// calculate category
always @(posedge clk_100mhz) begin
if (start) begin //---------game start----------

    j = 0;

    // WALL
    if (pixel_x >= 0 && pixel_x < (WIDTH) * BLOCK_SIZE + 2 * BOUNDARY_WIDTH && pixel_y >= 0 && pixel_y < (HEIGHT) * BLOCK_SIZE + 2 * BOUNDARY_WIDTH &&
        (pixel_x < BOUNDARY_WIDTH || pixel_x >= (WIDTH) * BLOCK_SIZE + BOUNDARY_WIDTH || pixel_y < BOUNDARY_WIDTH || pixel_y >= (HEIGHT) * BLOCK_SIZE + BOUNDARY_WIDTH)) begin
        j = 1;   
    end

    // TANK
    for (i = 0; i < MAX_TANKS; i = i + 1) begin
        if (i < n_tanks) begin
            if (pixel_x >= tanks_x[i] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_x < (tanks_x[i] + 10'd3) * BLOCK_SIZE + BOUNDARY_WIDTH &&
                pixel_y >= tanks_y[i] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_y < (tanks_y[i] + 10'd3) * BLOCK_SIZE + BOUNDARY_WIDTH) begin
                j = 2;
                addr <= (pixel_y - tanks_y[i] * BLOCK_SIZE - BOUNDARY_WIDTH) * 10'd30 + (pixel_x - tanks_x[i] * BLOCK_SIZE - BOUNDARY_WIDTH) + 10'b1;
                tank_direct <= tanks_direct[i];
                player_tank <= (i == 0) ? 1'b1 : 1'b0;
            end
        end
	end

    // BULLET
    for (k = 0; k < MAX_BULLETS; k = k + 1) begin
        if (k < n_bullets) begin
            if (pixel_x >= bullets_x[k] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_x < (bullets_x[k] + 10'd1) * BLOCK_SIZE + BOUNDARY_WIDTH &&
                pixel_y >= bullets_y[k] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_y < (bullets_y[k] + 10'd1) * BLOCK_SIZE + BOUNDARY_WIDTH) begin
                j = 3;
            end            
        end
    end
    // if (in_area) begin
    //     if (map[(pixel_x - BOUNDARY_WIDTH) / BLOCK_SIZE + (pixel_y - BOUNDARY_WIDTH) / BLOCK_SIZE * WIDTH] == 1'b1)
    //         j = 3;
    // end


    if (j == 0) begin
        category <= NONE;
    end 
    else if (j == 1) begin
        category <= WALL;
    end
    else if (j == 2) begin
        category <= TANK;
    end
    else if (j == 3) begin
        category <= BULLET;
    end
    else begin
        category <= NONE;
    end
end //---------game start----------
end

integer a, b, c;
always @(posedge clk_100mhz) begin
if (start) begin //---------game start----------

if (rst) begin
    alive <= 1'b1;
    start <= 1'b0;
end
else begin
    b = 0;
    for (a = 0; a < MAX_BULLETS; a = a + 1) begin
        if (a < n_bullets && is_player[a] == 1'b0) begin
            if (bullets_x[a] >= tanks_x[0] && bullets_x[a] < tanks_x[0] + 10'd3 && 
                bullets_y[a] >= tanks_y[0] && bullets_y[a] < tanks_y[0] + 10'd3) begin
                b = 1;    
            end            
        end
    end

    if (b == 1) begin
        alive <= 1'b0;    
    end
end

end //---------game start----------
else begin 
    if (alive && press) begin
        start <= 1'b1;
    end
end
end


endmodule