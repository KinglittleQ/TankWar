module Display (
    input wire clk,
    input wire[3:0] category,
    input wire[9:0] addr,
    input wire[2:0] tank_direct,
    input wire alive,

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

always @(posedge clk) begin
    case (tank_direct)
        UP: tank_rgb <= down;
        DOWN: tank_rgb <= up;
        LEFT: tank_rgb <= left;
        RIGHT: tank_rgb <= right;
    endcase
end

always @(posedge clk) begin
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
        red <= 4'hf;
        blue <= 4'hf;
        green <= 4'hf;
    end
end


endmodule