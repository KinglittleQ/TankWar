module DisplayScore (
    input wire clk,
    input wire[31:0] score,
    output reg[7:0] segment,
    output reg[3:0] AN
    );

reg[1:0] cnt;

wire[7:0] LED1, LED2, LED3, LED4;
MyMC14495 M0 (
    .D0(score[0]),
    .D1(score[1]),
    .D2(score[2]),
    .D3(score[3]),
    .LE(1'b1),
    .a(LED1[0]),
    .b(LED1[1]),
    .c(LED1[2]),
    .d(LED1[3]),
    .e(LED1[4]),
    .f(LED1[5]),
    .g(LED1[6]),
    .p(LED1[7])
    );

MyMC14495 M1 (
    .D0(score[4]),
    .D1(score[5]),
    .D2(score[6]),
    .D3(score[7]),
    .LE(1'b1),
    .a(LED2[0]),
    .b(LED2[1]),
    .c(LED2[2]),
    .d(LED2[3]),
    .e(LED2[4]),
    .f(LED2[5]),
    .g(LED2[6]),
    .p(LED2[7])
    );

MyMC14495 M2 (
    .D0(score[8]),
    .D1(score[9]),
    .D2(score[10]),
    .D3(score[11]),
    .LE(1'b1),
    .a(LED3[0]),
    .b(LED3[1]),
    .c(LED3[2]),
    .d(LED3[3]),
    .e(LED3[4]),
    .f(LED3[5]),
    .g(LED3[6]),
    .p(LED3[7])
    );

MyMC14495 M3 (
    .D0(score[12]),
    .D1(score[13]),
    .D2(score[14]),
    .D3(score[15]),
    .LE(1'b1),
    .a(LED4[0]),
    .b(LED4[1]),
    .c(LED4[2]),
    .d(LED4[3]),
    .e(LED4[4]),
    .f(LED4[5]),
    .g(LED4[6]),
    .p(LED4[7])
    );

always @(posedge clk) begin
    if (cnt != 2'b11) begin
        case (cnt)
        2'b00: begin
            AN <= 4'b0001;
            segment <= ~LED1;
        end
        2'b01: begin
            AN <= 4'b0010;
            segment <= ~LED2;
        end
        2'b10: begin
            AN <= 4'b0100;
            segment <= ~LED3;
        end
        endcase
        cnt <= cnt + 2'b01;
    end 
    else begin
        AN <= 4'b1000;
        segment <= ~LED4;
        cnt <= 2'b00;
    end
end




endmodule