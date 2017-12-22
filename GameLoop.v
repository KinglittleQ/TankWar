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

reg[9:0] tanks_x[MAX_TANKS : 0];
reg[9:0] tanks_y[MAX_TANKS : 0];
reg[2:0] tanks_direct[MAX_TANKS : 0];
reg[5:0] n_tanks;

reg[9:0] bullets_x[MAX_BULLETS : 0];
reg[9:0] bullets_y[MAX_BULLETS : 0];
reg[2:0] bullets_direct[MAX_BULLETS : 0];
reg[6:0] n_bullets;

wire clk_500ms, clk_250ms;

integer i, j, k;

initial begin
    tanks_x[0] = 10'd0;
    tanks_y[0] = 10'd0;
    tanks_direct[0] = RIGHT;
    n_tanks = 6'd1;

    n_bullets = 7'd0;

    cnt_500ms = 32'd0;

	category <= NONE;
end


CLK_500ms M0 (
    .clk_100mhz(clk_100mhz),
    .clk_500ms(clk_500ms)
    );

CLK_250ms M1 (
    .clk_100mhz(clk_100mhz),
    .clk_250ms(CLK_250ms)
    );

reg[2:0] shoot_sync;
reg[31:0] cnt_500ms;
always @(posedge clk_100mhz) begin
    shoot_sync <= {shoot, shoot_sync[1:0]};
    if (cnt_500ms == )
end

assign shoot_up = ~shoot_sync[0] & shoot_sync[1];

always @(posedge clk_100mhz) begin
    if (shoot_up) begin
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

    for (i = 0; i < n_bullets; i = i + 1) begin
        case (bullets_direct[i])
        LEFT: bullets_x[i] <= bullets_x[i] - 10'd1;
        RIGHT: bullets_x[i] <= bullets_x[i] + 10'd1;
        UP: bullets_y[i] <= bullets_y[i] - 10'd1;
        DOWN: bullets_y[i] <= bullets_y[i] + 10'd1;
        endcase
    end


end


always @(posedge clk_250ms) begin
    
end


always @(posedge clk_500ms) begin

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
        end
		  
    end

end


always @(posedge clk_100mhz) begin
    j = 0;

    // WALL
    if (pixel_x >= 0 && pixel_x < (WIDTH - 1) * BLOCK_SIZE + 2 * BOUNDARY_WIDTH && pixel_y >= 0 && pixel_y < (HEIGHT - 1) * BLOCK_SIZE + 2 * BOUNDARY_WIDTH &&
        (pixel_x < BOUNDARY_WIDTH || pixel_x >= (WIDTH - 1) * BLOCK_SIZE + BOUNDARY_WIDTH || pixel_y < BOUNDARY_WIDTH || pixel_y >= (HEIGHT - 1) * BLOCK_SIZE + BOUNDARY_WIDTH)) begin
        j = 1;   
    end

    // TANK
    for (i = 0; i < n_tanks; i = i + 1) begin
        if (pixel_x >= tanks_x[i] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_x <= (tanks_x[i] + 10'd2) * BLOCK_SIZE + BOUNDARY_WIDTH &&
            pixel_y >= tanks_y[i] * BLOCK_SIZE + BOUNDARY_WIDTH && pixel_y <= (tanks_y[i] + 10'd2) * BLOCK_SIZE + BOUNDARY_WIDTH) begin
            j = 2;
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
    else begin
        category <= NONE;
    end

end


endmodule