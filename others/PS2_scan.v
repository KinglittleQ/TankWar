module ps2scan(clk,rst,ps2k_clk,ps2k_data,ps2_byte,ps2_state,led,wei,seg);

 input clk;
 input rst;
 input ps2k_clk;
 input ps2k_data;
 output [3:0] wei;
 output [7:0] seg;
 output led;
 output [7:0] ps2_byte;//ps2数据信号
 output ps2_state;//标注键盘当前状态，1表示有按键按下
 reg led;
 reg [15:0] count;
 integer num1,a,b;
 
 
 initial begin
  num1 = 0;
  a = 0;
  b = 0;
 end
 always @(posedge clk or negedge rst)
  if(!rst)
   count <= 16'b0;
  else begin
   count <= count+1'b1;
   if(count == 16'hffff)
    begin
     count <= 16'b0;
     num1 <= num1+1;
     if(num1 == 4)
      num1 <= 0;
    end
  end

 
 reg ps2k_clk_r0,ps2k_clk_r1,ps2k_clk_r2;//ps2k_clk状态寄存器
 wire neg_ps2k_clk;//ps2k_clk下沿标志位
 
 always @(posedge clk or negedge rst) begin
  if(!rst) begin
   ps2k_clk_r0 <= 1'b0;
   ps2k_clk_r1 <= 1'b0;
   ps2k_clk_r2 <= 1'b0;
  end
  else begin
   ps2k_clk_r0 <= ps2k_clk;//锁存状态,进行滤波
   ps2k_clk_r1 <= ps2k_clk_r0;
   ps2k_clk_r2 <= ps2k_clk_r1;
  end
 end
 
 assign neg_ps2k_clk = ~ps2k_clk_r1 & ps2k_clk_r2;
 reg [7:0] ps2_byte_r;//PC接收来自ps2的一个字节数据寄存器
 reg [7:0] temp_data;//当前接收数据寄存器
 reg [3:0] num;//计数寄存器
 
 always @(posedge clk or negedge rst) begin
  if(!rst) begin
   num <= 4'd0;
   temp_data <= 8'd0;
  end
  else if(neg_ps2k_clk) begin
   case(num)
    4'd0: num <= num+1'b1;
    4'd1: begin
       num <= num+1'b1;
       temp_data[0] <= ps2k_data;
      end
    4'd2: begin
       num <= num+1'b1;
       temp_data[1] <= ps2k_data;
      end
    4'd3: begin
       num <= num+1'b1;
       temp_data[2] <= ps2k_data;
      end
    4'd4: begin
       num <= num+1'b1;
       temp_data[3] <= ps2k_data;
      end
    4'd5: begin
       num <= num+1'b1;
       temp_data[4] <= ps2k_data;
      end
    4'd6: begin
       num <= num+1'b1;
       temp_data[5] <= ps2k_data;
      end
    4'd7: begin
       num <= num+1'b1;
       temp_data[6] <= ps2k_data;
      end
    4'd8: begin
       num <= num+1'b1;
       temp_data[7] <= ps2k_data;
      end
    4'd9: begin
       num <= num+1'b1;
      end
    4'd10: begin
       num <= 4'd0;
      end
    default: ;
    endcase
  end 
 end
 
 reg key_f0;//松键标志位，1表示收到数据8f0;
 reg ps2_state_r;//键盘当前状态，1表示按下
 
 always @(posedge clk or negedge rst) begin
  if(!rst) begin
   key_f0 <= 1'b0;
   ps2_state_r <= 1'b0;
  end
  else if(num==4'd10)//传送完一个字节
   begin
    if(temp_data == 8'hf0) begin
     key_f0 <= 1'b1;
     led <= 0;
     end
    else begin
     if(!key_f0) begin//
      ps2_state_r <= 1'b1;
      led <= 1;
      ps2_byte_r <= temp_data;
     end
     else begin
      ps2_state_r <= 1'b0;
      key_f0 <= 1'b0;
     end
    end
   end 
 end
 
 reg [7:0] ps2_asci;
 always @(ps2_byte_r) begin
  case(ps2_byte_r)
   8'h15: ps2_asci <= 8'h51;//Q
   8'h1d: ps2_asci <= 8'h57;//W
   8'h24: ps2_asci <= 8'h45;//E
   8'h2d: ps2_asci <= 8'h52;//R
   8'h2c: ps2_asci <= 8'h54;//T
   8'h35: ps2_asci <= 8'h59;//Y
   8'h3c: ps2_asci <= 8'h55;//U
   8'h43: ps2_asci <= 8'h49;//I
   8'h44: ps2_asci <= 8'h4f;//O
   8'h4d: ps2_asci <= 8'h50;//P
   8'h1c: ps2_asci <= 8'h41;//A
   8'h1b: ps2_asci <= 8'h53;//S
   8'h23: ps2_asci <= 8'h44;//D
   8'h2b: ps2_asci <= 8'h46;//F
   8'h34: ps2_asci <= 8'h47;//G
   8'h33: ps2_asci <= 8'h48;//H
   8'h3b: ps2_asci <= 8'h4a;//J
   8'h42: ps2_asci <= 8'h4b;//K
   8'h4b: ps2_asci <= 8'h4c;//L
   8'h1a: ps2_asci <= 8'h5a;//Z
   8'h22: ps2_asci <= 8'h58;//X
   8'h21: ps2_asci <= 8'h43;//C
   8'h2a: ps2_asci <= 8'h56;//V
   8'h32: ps2_asci <= 8'h42;//B
   8'h31: ps2_asci <= 8'h4e;//N
   8'h3a: ps2_asci <= 8'h4d;//M
   default:;
   endcase
 end

 assign ps2_byte = ps2_asci;
 assign ps2_state = ps2_state_r;
endmodule