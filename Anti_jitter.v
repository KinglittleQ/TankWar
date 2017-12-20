module Anti_jitter(
        input wire clk,
        input wire RSTN,
        input wire [3:0] K_COL,
        input wire [15:0] SW,
        output reg [3:0] button_out,
        output reg [3:0] button_pulse,
        output reg [15:0] SW_OK,
        output [4:0] K_ROW,
        output reg CR,
        output reg rst
    );

reg [31:0] counter, rst_counter;
reg [4:0] btn_temp;
reg [15:0] sw_temp;
reg pulse;

wire [4:0] button = {~RSTN, ~K_COL[3:0]};
assign K_ROW = 4'b0000;

always @(posedge clk) begin
    btn_temp <= button;
    sw_temp <= SW;
    if (btn_temp != button || sw_temp != SW) begin
        counter <= 32'h00000000;
        rst_counter <= 0;
        pulse <= 0;
    end
    else if (counter < 100000)
        counter <= counter + 1;
    else begin
        button_out <= button[3:0];
        CR <= ~RSTN;
        SW_OK = SW;
        pulse <= 1;
        if (!pulse)
            button_pulse <= button[3:0];
        else
            button_pulse <= 0;

        if (button[4] && rst_counter < 200000000)
            rst_counter <= rst_counter + 1;
        else
            rst <= RSTN;
    end
end

endmodule