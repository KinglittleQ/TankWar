module GameLoop (
    input wire clk_100mhz,
    input wire[2:0] direct,
    input wire moving,
    input wire[9:0] pixel_x,
    input wire[9:0] pixel_y,

    output reg[3:0] category
    ); 

// 477  415
parameter MAX_TANKS = 6'd20;
parameter WIDTH = 10'd45;
parameter HEIGHT = 10'd30;
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

wire clk_500ms;

integer i, j, k;

initial begin
    tanks_x[0] <= 10'd0;
    tanks_y[0] <= 10'd0;
    tanks_direct[0] <= RIGHT;
    n_tanks <= 6'd1;
	 category <= NONE;
end

CLK_500ms M0 (
    .clk_100mhz(clk_100mhz),
    .clk_500ms(clk_500ms)
    );

always @(posedge clk_500ms or posedge moving) begin

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
    if (pixel_x >= 0 && pixel_x < WIDTH * BLOCK_SIZE + 2 * BOUNDARY_WIDTH && pixel_y >= 0 && pixel_y < HEIGHT * BLOCK_SIZE + 2 * BOUNDARY_WIDTH &&
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