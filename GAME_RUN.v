module GAME_RUN (
    input wire clk,
    input wire RSTN,
    input wire[9:0] x,
    input wire[9:0] y,
    input wire[2:0] player_direct,
    input wire shoot,

    output wire[2:0] category,
    output wire[9:0] address
    )

parameter BLOCK_SIZE = 10;
parameter WIDTH = 550;
parameter HEIGHT = 450;

parameter TANK_SIZE = 3;
parameter BULLET_SIZE = 1;

parameter LEFT = 3'b000;
parameter RIGHT = 3'b001;
parameter UP = 3'b010;
parameter DOWN = 3'b011;
parameter STOP = 3'b100;

// enemies
reg [4:0] n_tanks;       // max = 31
reg [224:0] tanks_x;     // 32 (tanks num) * 7(maximum of x is 2^7 = 128)
reg [224:0] tanks_y;     // 32 * 7
reg [96:0] tanks_direct; // 32 * 3 (5 directions need 3 bits)

// player's tank
reg [7:0] player_x;   
reg [7:0] player_y;

// bullets
reg [6:0] n_bullets;
reg [699:0] bullets_x;    // 100 * 7
reg [699:0] bullets_y;
reg [200] bullets_direct;

reg flash;  // 2Hz

// player's life
reg[3:0] life;

initial begin
    n_tanks <= 3;    // 3 enemy tanks

    player_x <= 7'd0;   // left up corner
    player_y <= 7'd0;
    player_direct <= RIGHT;

    tanks_x[0:6] <= 7'd54;  // right up corner
    tanks_y[0:6] <= 7'd00;
    tanks_direct[2:0] <= DOWN;

    tanks_x[7:13] <= 7'd54; // right down corner
    tanks_y[7:12] <= 7'd44;
    tanks_direct[5:3] <= LEFT;

    tanks_x[14:20] <= 7'd00;  // left down corner
    tanks_y[14:20] <= 7'd44;
    tanks_direct[8:6] <= UP;

    life <= 2'b10;  // 2 lives at begin

    flash <= 1'b0;
end

clk_2Hz M1 ( .clk(clk), .flash(flash) );

integer i, j, k;
integer player_collide = 0;
integer tanks_collide = 0;

integer destroy = 0;

// move control
always @(posedge flash) begin

if (life > 0) begin // not dead

    case (player_direct)
    
    STOP :
        player_collide = 0;

    LEFT :
        if (player_x > 0) 
            for (i = 0; i < n_tanks; i = i + 1)
                if ( (player_x - 1 >= tanks_x[7*i+6 : 7*i]) && (player_x - 1 <= tanks_x[7*i+6 : 7*i] + 2) ) 
                    if ( (tanks_y[7*i+6 : 7*i] + 2 >= player_y) && (tanks_y[7*i+6 : 7*i] <= player_y + 2) )
                        player_collide = 1;

    RIGHT :
        if (player_x < WIDTH-1 -2)
            for (i = 0; i < n_tanks; i = i + 1) 
                if ( (player_x + 3 >= tanks_x[7*i+6 : 7*i]) && (player_x + 3 <= tanks_x[7*i+6 : 7*i] + 2) )
                    if ( (tanks_y[7*i+6 : 7*i] + 2 >= player_y) && (tanks_y[7*i+6 : 7*i] <= player_y + 2) )
                        player_collide = 1;

    UP :
        if (player_y > 0)
            for (i = 0; i < n_tanks; i = i + 1)
                if ( (player_y - 1 >= tanks_y[7*i+6 : 7*i]) && (player_y - 1 <= tanks_y[7*i+6 : 7*i] + 2) )
                    if ( (tanks_x[7*i+6 : 7*i] + 2 >= player_x) && (tanks_x[7*i+6 : 7*i] <= player_x + 2) )
                        player_collide = 1;

    DOWN :
        if (player_y < HEIGHT-1 -2)
            for (i = 0; i < n_tanks; i = i + 1) 
                if ( (player_y + 3 >= tanks_y[7*i+6 : 7*i]) && (player_y + 3 <= tanks_y[7*i+6 : 7*i] + 2) )
                    if ( (tanks_x[7*i+6 : 7*i] + 2 >= player_x) && (tanks_x[7*i+6 : 7*i] <= player_x + 2) )
                        player_collide = 1;

    endcase

    if (!player_collide) begin
        case (player_direct)
        LEFT: 
            player_x <= player_x - 1;
        RIGHT: 
            player_x <= player_x + 1;
        UP: 
            player_y <= player_y - 1;
        DOWN: 
            player_y <= player_y + 1; 
        endcase
    end

    player_direct <= STOP;
    player_collide = 0;

    // enemy tanks
    for (j = 0; j < n_tanks; j = j + 1) begin
        case (tanks_direct[3*j + 2 : 3*j])
        STOP :
            tanks_collide = 0;

        LEFT :
            if (tanks_x[7*j + 6 : 7*j] > 0) 
                for (i = 0; i < n_tanks; i = i + 1) 
                    if (i != j)
                        if ( (tanks_x[7*j + 6 : 7*j] - 1 >= tanks_x[7*i+6 : 7*i]) && (tanks_x[7*j + 6 : 7*j] - 1 <= tanks_x[7*i+6 : 7*i] + 2) ) 
                            if ( (tanks_y[7*i+6 : 7*i] + 2 >= tanks_y[7*j + 6 : 7*j]) && (tanks_y[7*i+6 : 7*i] <= tanks_y[7*j + 6 : 7*j] + 2) )
                                tanks_collide = 1;

        RIGHT :
            if (tanks_x[7*j + 6 : 7*j] < WIDTH-1 -2)
                for (i = 0; i < n_tanks; i = i + 1) 
                    if (i != j)
                        if ( (tanks_x[7*j + 6 : 7*j] + 3 >= tanks_x[7*i+6 : 7*i]) && (tanks_x[7*j + 6 : 7*j] + 3 <= tanks_x[7*i+6 : 7*i] + 2) )
                            if ( (tanks_y[7*i+6 : 7*i] + 2 >= tanks_y[7*j + 6 : 7*j]) && (tanks_y[7*i+6 : 7*i] <= tanks_y[7*j + 6 : 7*j] + 2) )
                                tanks_collide = 1;

        UP :
            if (tanks_y[7*j + 6 : 7*j] > 0)
                for (i = 0; i < n_tanks; i = i + 1)
                    if (i != j)
                        if ( (tanks_y[7*j + 6 : 7*j] - 1 >= tanks_y[7*i+6 : 7*i]) && (tanks_y[7*j + 6 : 7*j] - 1 <= tanks_y[7*i+6 : 7*i] + 2) )
                            if ( (tanks_x[7*i+6 : 7*i] + 2 >= tanks_x[7*j + 6 : 7*j]) && (tanks_x[7*i+6 : 7*i] <= tanks_x[7*j + 6 : 7*j] + 2) )
                                tanks_collide = 1;

        DOWN :
            if (tanks_y[7*j + 6 : 7*j] < HEIGHT-1 -2)
                for (i = 0; i < n_tanks; i = i + 1) 
                    if (i != j)
                        if ( (tanks_y[7*j + 6 : 7*j] + 3 >= tanks_y[7*i+6 : 7*i]) && (tanks_y[7*j + 6 : 7*j] + 3 <= tanks_y[7*i+6 : 7*i] + 2) )
                            if ( (tanks_x[7*i+6 : 7*i] + 2 >= tanks_x[7*j + 6 : 7*j]) && (tanks_x[7*i+6 : 7*i] <= tanks_x[7*j + 6 : 7*j] + 2) )
                                tanks_collide = 1;
        endcase

        if (tanks_collide) begin
            case (tanks_direct[3*j + 2 : 3*j])
            LEFT:
                tanks_x[7*j + 6 : 7*j] = tanks_x[7*j + 6 : 7*j] - 1;
            RIGHT:
                tanks_x[7*j + 6 : 7*j] = tanks_x[7*j + 6 : 7*j] + 1;
            UP:
                tanks_y[7*j + 6 : 7*j] = tanks_y[7*j + 6 : 7*j] - 1;
            DOWN:
                tanks_y[7*j + 6 : 7*j] = tanks_y[7*j + 6 : 7*j] + 1;
            endcase
        end

        tanks_direct[3*j + 2 : 3*j] = STOP;
        tanks_collide = 0;
    end

    // test if bullets are out of range
    for (j = 0; k < n_bullets; j = j + 1) begin
        case (bullets_direct[3*j + 2 : 3*j])
        LEFT:
            if (bullets_x[7*j+6 : 7*j] <= 0)
                destory = 1;
            else 
                bullets_x[7*j+6 : 7*j] = bullets_x[7*j+6 : 7*j] - 1;
        RIGHT:
            if (bullets_x[7*j+6 : 7*j] >= WIDTH)
                destory = 1;
            else
                bullets_x[7*j+6 : 7*j] = bullets_x[7*j+6 : 7*j] + 1;
        UP:
            if (bullets_y[7*j+6 : 7*j] <= 0)
                destory = 1;
            else 
                bullets_y[7*j+6 : 7*j] = bullets_y[7*j+6 : 7*j] - 1;
        DOWN:
            if (bullets_y[7*j+6 : 7*j] >= HEIGHT)
                destory = 1;
            else 
                bullets_y[7*j+6 : 7*j] = bullets_y[7*j+6 : 7*j] + 1;
     
        if (destroy) begin
            for (i = j; i + 1 < n_bullets; i = i + 1) begin
                bullets_x[7*i+6 : 7*i] = bullets_x[7*i+13 : 7*i+7];
                bullets_y[7*i+6 : 7*i] = bullets_y[7*i+13 : 7*i+7];
                bullets_direct[3*i+2 : 3*i] = bullets_direct[3*i+5 : 3*i+3];
            end
            n_bullets = n_bullets - 1;
            destroy = 0;
            j = j - 1; // !!!! do not forget to minus 1 
        end
    end

end // if (life > 0)

end


// judge whether tanks are shooted
always @(posedge clk) begin
    for (i = 0; i < n_bullets; i = i + 1) begin
        if ( bullets_x[7*i+6 : 7*i] >= player_x && bullets_x[7*i+6 : 7*i] <= player_x + 2
                && bullets_y[7*i+6 : 7*i] >= player_y && bullets_y[7*i+6 : 7*i] <= player_y + 2 ) begin
            if (life > 0)
                life <= life - 1;
        end
    end

    for (j = 0; j < n_tanks; j = j + 1) begin
        for (i = 0; i < n_bullets; i = i + 1) begin
            if ( bullets_x[7*i+6 : 7*i] >= tanks_x[7*j+6 : 7*j] && bullets_x[7*i+6 : 7*i] <= tanks_x[7*j+6 : 7*j] + 2
                    && bullets_y[7*i+6 : 7*i] >= tanks_y[7*j+6 : 7*j] && bullets_y[7*i+6 : 7*i] <= tanks_y[7*j+6 : 7*j] + 2 ) begin          
                for (k = j; k + 1 < n_tanks; k = k + 1) begin
                    tanks_x[7*k+6 : 7*k] = tanks_x[7*k+13 : 7*k + 7];
                    tanks_y[7*k+6 : 7*k] = tanks_y[7*k+13 : 7*k + 7];
                    tanks_direct[3*k+2 : 3*k] = tanks_direct[3*k+5 : 3*k+3];
                end
                n_tanks = n_tanks - 1;
                j = j - 1; // !!!! do not forget to minus 1 
            end
        end
    end

end



// shoot
// always @(posedge shoot) begin
// if (life > 0) begin
//     case (player_direct)

//     LEFT:
        

//     endcase


end // if (life > 0)
end

endmodule