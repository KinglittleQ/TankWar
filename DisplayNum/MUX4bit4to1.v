////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 14.7
//  \   \         Application : sch2hdl
//  /   /         Filename : MUX4bit4to1.vf
// /___/   /\     Timestamp : 11/05/2017 18:14:51
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: sch2hdl -intstyle ise -family kintex7 -verilog D:/code/Xilinx-ISE/project/Exp07-MUX/MUX4bit4to1.vf -w D:/code/Xilinx-ISE/code/Exp07-MUX/MUX4bit4to1.sch
//Design Name: MUX4bit4to1
//Device: kintex7
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 1ns / 1ps

module MUX4bit4to1(I0, 
                   I1, 
                   I2, 
                   I3, 
                   s, 
                   o);

    input [3:0] I0;
    input [3:0] I1;
    input [3:0] I2;
    input [3:0] I3;
    input [1:0] s;
   output [3:0] o;
   
   wire XLXN_3;
   wire XLXN_5;
   wire XLXN_29;
   wire XLXN_30;
   wire XLXN_31;
   wire XLXN_32;
   wire XLXN_33;
   wire XLXN_34;
   wire XLXN_35;
   wire XLXN_36;
   wire XLXN_37;
   wire XLXN_38;
   wire XLXN_39;
   wire XLXN_40;
   wire XLXN_41;
   wire XLXN_42;
   wire XLXN_43;
   wire XLXN_44;
   wire XLXN_45;
   wire XLXN_46;
   wire XLXN_47;
   wire XLXN_48;
   
   INV  XLXI_1 (.I(s[1]), 
               .O(XLXN_3));
   INV  XLXI_2 (.I(s[0]), 
               .O(XLXN_5));
   AND2  XLXI_3 (.I0(XLXN_3), 
                .I1(XLXN_5), 
                .O(XLXN_46));
   AND2  XLXI_4 (.I0(s[0]), 
                .I1(XLXN_3), 
                .O(XLXN_47));
   AND2  XLXI_5 (.I0(XLXN_5), 
                .I1(s[1]), 
                .O(XLXN_48));
   AND2  XLXI_6 (.I0(s[0]), 
                .I1(s[1]), 
                .O(XLXN_29));
   AND2  XLXI_13 (.I0(I0[0]), 
                 .I1(XLXN_46), 
                 .O(XLXN_30));
   AND2  XLXI_14 (.I0(I1[0]), 
                 .I1(XLXN_47), 
                 .O(XLXN_31));
   AND2  XLXI_15 (.I0(I2[0]), 
                 .I1(XLXN_48), 
                 .O(XLXN_32));
   AND2  XLXI_16 (.I0(I3[0]), 
                 .I1(XLXN_29), 
                 .O(XLXN_33));
   OR4  XLXI_17 (.I0(XLXN_33), 
                .I1(XLXN_32), 
                .I2(XLXN_31), 
                .I3(XLXN_30), 
                .O(o[0]));
   AND2  XLXI_18 (.I0(I0[1]), 
                 .I1(XLXN_46), 
                 .O(XLXN_34));
   AND2  XLXI_19 (.I0(I1[1]), 
                 .I1(XLXN_47), 
                 .O(XLXN_35));
   AND2  XLXI_20 (.I0(I2[1]), 
                 .I1(XLXN_48), 
                 .O(XLXN_36));
   AND2  XLXI_21 (.I0(I3[1]), 
                 .I1(XLXN_29), 
                 .O(XLXN_37));
   OR4  XLXI_22 (.I0(XLXN_37), 
                .I1(XLXN_36), 
                .I2(XLXN_35), 
                .I3(XLXN_34), 
                .O(o[1]));
   AND2  XLXI_23 (.I0(I0[2]), 
                 .I1(XLXN_46), 
                 .O(XLXN_38));
   AND2  XLXI_24 (.I0(I1[2]), 
                 .I1(XLXN_47), 
                 .O(XLXN_39));
   AND2  XLXI_25 (.I0(I2[2]), 
                 .I1(XLXN_48), 
                 .O(XLXN_40));
   AND2  XLXI_26 (.I0(I3[2]), 
                 .I1(XLXN_29), 
                 .O(XLXN_41));
   OR4  XLXI_27 (.I0(XLXN_41), 
                .I1(XLXN_40), 
                .I2(XLXN_39), 
                .I3(XLXN_38), 
                .O(o[2]));
   AND2  XLXI_28 (.I0(I0[3]), 
                 .I1(XLXN_46), 
                 .O(XLXN_42));
   AND2  XLXI_29 (.I0(I1[3]), 
                 .I1(XLXN_47), 
                 .O(XLXN_43));
   AND2  XLXI_30 (.I0(I2[3]), 
                 .I1(XLXN_48), 
                 .O(XLXN_44));
   AND2  XLXI_31 (.I0(I3[3]), 
                 .I1(XLXN_29), 
                 .O(XLXN_45));
   OR4  XLXI_32 (.I0(XLXN_45), 
                .I1(XLXN_44), 
                .I2(XLXN_43), 
                .I3(XLXN_42), 
                .O(o[3]));
endmodule
