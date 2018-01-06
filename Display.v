module Display (
    input wire clk,
    input wire[3:0] category,
    input wire[9:0] addr,
    input wire[2:0] tank_direct,
    input wire[9:0] pixel_x,
    input wire[9:0] pixel_y,
    input wire player_tank,
    input wire alive,
    input wire start,

    output reg[3:0] red,
    output reg[3:0] green,
    output reg[3:0] blue
    );

parameter NONE = 4'd0;
parameter WALL = 4'd1;
parameter TANK = 4'd2;
parameter BULLET = 4'd3;

parameter LEFT = 3'b000;
parameter RIGHT = 3'b001;
parameter UP = 3'b010;
parameter DOWN = 3'b011;

wire[11:0] up, down, right, left;
reg[11:0] tank_rgb;
reg[15:0] over_addr, start_addr;
wire[11:0] over_rgb, start_rgb;

TANK_UP M0 (
    .clka(clk), // input clka
    .wea(1'b0), // input [0 : 0] wea
    .addra(addr), // input [9 : 0] addra
    .dina(12'b0), // input [11 : 0] dina
    .douta(up) // output [11 : 0] douta
);

TANK_DOWN M1 (
    .clka(clk), // input clka
    .wea(1'b0), // input [0 : 0] wea
    .addra(addr), // input [9 : 0] addra
    .dina(12'b0), // input [11 : 0] dina
    .douta(down) // output [11 : 0] douta
);

TANK_RIGHT M2 (
    .clka(clk), // input clka
    .wea(1'b0), // input [0 : 0] wea
    .addra(addr), // input [9 : 0] addra
    .dina(12'b0), // input [11 : 0] dina
    .douta(right) // output [11 : 0] douta
);

TANK_LEFT M3 (
    .clka(clk), // input clka
    .wea(1'b0), // input [0 : 0] wea
    .addra(addr), // input [9 : 0] addra
    .dina(12'b0), // input [11 : 0] dina
    .douta(left) // output [11 : 0] douta
);

GameOver M4 (
    .clka(clk), // input clka
    .wea(1'b0), // input [0 : 0] wea
    .addra(over_addr), // input [15 : 0] addra
    .dina(12'b0), // input [11 : 0] dina
    .douta(over_rgb) // output [11 : 0] douta
);

GameStart M5 (
    .clka(clk), // input clka
    .wea(1'b0), // input [0 : 0] wea
    .addra(start_addr), // input [15 : 0] addra
    .dina(12'b0), // input [11 : 0] dina
    .douta(start_rgb) // output [11 : 0] douta
);

always @(posedge clk) begin
    case (tank_direct)
        UP: begin
            if (player_tank)
                tank_rgb <= {down[3:0], down[7:4], down[11:8]};
            else
                tank_rgb <= down;
        end
        DOWN: begin
            if (player_tank)
                tank_rgb <= {up[3:0], up[7:4], up[11:8]};
            else
                tank_rgb <= up;
        end
        LEFT: begin
            if (player_tank)
                tank_rgb <= {left[3:0], left[7:4], left[11:8]};
            else
                tank_rgb <= left;        
        end        
        RIGHT: begin
            if (player_tank)
                tank_rgb <= {right[3:0], right[7:4], right[11:8]};
            else
                tank_rgb <= right;            
        end
    endcase
end

always @(posedge clk) begin
if (start) begin
    if (alive) begin
        case (category)
        NONE:
    	begin
            red <= 4'h0;
            green <= 4'h0;
            blue <= 4'h0;
    	end
        WALL:
    	begin
            red <= 4'hf;
            green <= 4'hf;
            blue <= 4'hf;
    	end
        TANK:
    	begin
            red <= tank_rgb[11:8];
            green <= tank_rgb[7:4];
            blue <= tank_rgb[3:0];
    	end
        BULLET:
        begin
             red <= 4'h0;
             green <= 4'hf;
             blue <= 4'hf;
        end
    	default:
    	begin
            red <= 4'h0;
            green <= 4'h0;
            blue <= 4'h0;
    	end
        endcase
    end
    else begin
        if (pixel_x >= 10'd200 && pixel_x < 10'd440 && pixel_y >= 10'd150 && pixel_y < 10'd310) begin
            over_addr <= pixel_x - 10'd200 + (10'd309 - pixel_y) * 16'd240 + 16'd1;  // delay 1 clk
            red <= over_rgb[11:8];
            green <= over_rgb[7:4];
            blue <= over_rgb[3:0];
        end 
        else begin
            red <= 4'h0;
            green <= 4'h0;
            blue <= 4'h0;
        end
    end
end
else begin
    if (pixel_x >= 10'd200 && pixel_x < 10'd440 && pixel_y >= 10'd150 && pixel_y < 10'd310) begin
        start_addr <= pixel_x - 10'd200 + (pixel_y - 10'd150) * 16'd240 + 16'd1;  // delay 1 clk
        red <= start_rgb[11:8];
        green <= start_rgb[7:4];
        blue <= start_rgb[3:0];
    end 
    else begin
        red <= 4'h0;
        green <= 4'h0;
        blue <= 4'h0;
    end    
end
end


endmodule