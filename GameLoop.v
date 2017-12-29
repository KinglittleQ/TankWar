module GameLoop (
    input wire clk_100mhz,
    input wire[2:0] direct,
    input wire moving,
    input wire shoot,
    input wire[9:0] pixel_x,
    input wire[9:0] pixel_y,

    output reg[3:0] category
    ); 

// 650 X 480
parameter MAX_TANKS = 6'd20;
parameter MAX_BULLETS = 7'd100;

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


integer i, j, k;


wire clk_500ms, clk_250ms;
reg[6:0] bullets_ptr;
reg go;

initial begin
    tanks_x[0] = 10'd0;
    tanks_y[0] = 10'd0;
    tanks_direct[0] = RIGHT;
    n_tanks = 6'd1;

    n_bullets = 7'd0;
    bullets_ptr = 7'd0;
    go = 1'b0;
    k = 7'd0;
	category = NONE;

    for (i = 1; i < MAX_BULLETS; i = i + 1) begin
        bullets_x[i] = 10'd100;
        bullets_y[i] = 10'd100;
    end

end

CLK_500ms M0 (
    .clk_100mhz(clk_100mhz),
    .clk_500ms(clk_500ms)
    );

CLK_250ms M2 (
    .clk_100mhz(clk_100mhz),
    .clk_250ms(clk_250ms)
    );

reg[2:0] moving_sync;
reg[2:0] clk500_sync;
reg[2:0] shoot_sync;
reg[2:0] clk250_sync;

always @(posedge clk_100mhz) begin
    moving_sync <= {moving, moving_sync[2:1]};
    clk500_sync <= {clk_500ms, clk500_sync[2:1]};
    shoot_sync <= {shoot, shoot_sync[2:1]};
    clk250_sync <= {clk_250ms, clk250_sync[2:1]};
end


assign moving_edge = ~moving_sync[0] & moving_sync[1];
assign clk500_edge = ~clk500_sync[0] & clk500_sync[1];
assign shoot_edge = ~shoot_sync[0] & shoot_sync[1];
assign clk250_edge = ~clk250_sync[0] & clk250_sync[1];

// shoot
always @(posedge clk_100mhz) begin
    if (shoot_edge) begin
        case (tanks_direct[0])
        LEFT: begin
            if (tanks_x[0] > 10'd0) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0] - 10'd1;
                bullets_y[n_bullets] <= tanks_y[0];
                bullets_direct[n_bullets] <= tanks_direct[0];
            end
        end
        RIGHT: begin
            if (tanks_x[0] < WIDTH - 1) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0] + 10'd1;
                bullets_y[n_bullets] <= tanks_y[0];
                bullets_direct[n_bullets] <= tanks_direct[0];
            end
        end
        UP: begin
            if (tanks_y[0] > 10'd0) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0];
                bullets_y[n_bullets] <= tanks_y[0] - 10'd1;
                bullets_direct[n_bullets] <= tanks_direct[0];
            end
        end
        DOWN: begin
            if (tanks_y[0] < HEIGHT - 1) begin
                n_bullets <= n_bullets + 7'd1;
                bullets_x[n_bullets] <= tanks_x[0];
                bullets_y[n_bullets] <= tanks_y[0] + 10'd1;
                bullets_direct[n_bullets] <= tanks_direct[0];
            end
        end
        endcase
    end
    else if (clk250_edge | go) begin
        if (clk250_edge & ~go) begin
            go <= 1'b1;
        end

        if (bullets_ptr != n_bullets) begin
            // delete bullets
            if (bullets_x[bullets_ptr] < 0 | bullets_x[bullets_ptr] > WIDTH | bullets_y[bullets_ptr] < 0 | bullets_y[bullets_ptr] > HEIGHT) begin
                n_bullets <= n_bullets - 7'd1;
                if (n_bullets != 7'd0) begin
                    bullets_x[bullets_ptr] <= bullets_x[n_bullets - 7'd1];
                    bullets_y[bullets_ptr] <= bullets_y[n_bullets - 7'd1];
                    bullets_direct[bullets_ptr] <= bullets_direct[n_bullets - 7'd1];

                    bullets_x[n_bullets - 7'd1] <= 10'd100;
                    bullets_y[n_bullets - 7'd1] <= 10'd100;
                end
            end
            else begin
                case (bullets_direct[bullets_ptr])
                    LEFT: bullets_x[bullets_ptr] <= bullets_x[bullets_ptr] - 10'd1;
                    RIGHT: bullets_x[bullets_ptr] <= bullets_x[bullets_ptr] + 10'd1;
                    UP: bullets_y[bullets_ptr] <= bullets_y[bullets_ptr] - 10'd1;
                    DOWN: bullets_y[bullets_ptr] <= bullets_y[bullets_ptr] + 10'd1;
                endcase
                bullets_ptr <= bullets_ptr + 7'd1;
            end
        end
        else begin
            bullets_ptr <= 7'd0;
            go <= 1'b0;
        end
    end
end


// tanks move
always @(posedge clk_100mhz) begin
if (moving_edge | clk500_edge) begin
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
end



// reg[6:0] k;
integer m = 0, n = 0;

always @(posedge clk_100mhz) begin
    j = 0;

    // WALL
    if (pixel_x >= 0 && pixel_x < (WIDTH - 1) * BLOCK_SIZE + 2 * BOUNDARY_WIDTH && pixel_y >= 0 && pixel_y < (HEIGHT - 1) * BLOCK_SIZE + 2 * BOUNDARY_WIDTH &&
        (pixel_x < BOUNDARY_WIDTH || pixel_x >= (WIDTH - 1) * BLOCK_SIZE + BOUNDARY_WIDTH || pixel_y < BOUNDARY_WIDTH || pixel_y >= (HEIGHT - 1) * BLOCK_SIZE + BOUNDARY_WIDTH)) begin
        j = 1;   
    end

    // TANK
    for (i = 0; i < n_tanks; i = i + 1) begin
        if (pixel_x >= tanks_x[i] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_x < (tanks_x[i] + 10'd3) * BLOCK_SIZE + BOUNDARY_WIDTH &&
            pixel_y >= tanks_y[i] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_y < (tanks_y[i] + 10'd3) * BLOCK_SIZE + BOUNDARY_WIDTH) begin
            j = 2;
        end
	end


    for (k = 0; k < MAX_BULLETS; k = k + 1) begin
        if (k < n_bullets) begin
            if (pixel_x >= bullets_x[k] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_x < (bullets_x[k] + 10'd1) * BLOCK_SIZE + BOUNDARY_WIDTH &&
                pixel_y >= bullets_y[k] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_y < (bullets_y[k] + 10'd1) * BLOCK_SIZE + BOUNDARY_WIDTH) begin
                j = 3;
            end            
        end
    end


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

end


endmodule