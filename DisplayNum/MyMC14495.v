////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 14.7
//  \   \         Application : sch2hdl
//  /   /         Filename : MyMC14495.vf
// /___/   /\     Timestamp : 12/18/2017 19:20:18
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: C:\Xilinx\14.7\ISE_DS\ISE\bin\nt64\unwrapped\sch2hdl.exe -intstyle ise -family kintex7 -verilog MyMC14495.vf -w D:/code/Xilinx-ISE/code/MyMC14495/MyMC14495.sch
//Design Name: MyMC14495
//Device: kintex7
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 1ns / 1ps

module MyMC14495(D0, 
                 D1, 
                 D2, 
                 D3, 
                 LE, 
                 point, 
                 a, 
                 b, 
                 c, 
                 d, 
                 e, 
                 f, 
                 g, 
                 p);

    input D0;
    input D1;
    input D2;
    input D3;
    input LE;
    input point;
   output a;
   output b;
   output c;
   output d;
   output e;
   output f;
   output g;
   output p;
   
   wire XLXN_14;
   wire XLXN_20;
   wire XLXN_46;
   wire XLXN_48;
   wire XLXN_49;
   wire XLXN_50;
   wire XLXN_51;
   wire XLXN_52;
   wire XLXN_53;
   wire XLXN_54;
   wire XLXN_55;
   wire XLXN_56;
   wire XLXN_57;
   wire XLXN_59;
   wire XLXN_60;
   wire XLXN_61;
   wire XLXN_62;
   wire XLXN_63;
   wire XLXN_64;
   wire XLXN_68;
   wire XLXN_69;
   wire XLXN_70;
   wire XLXN_80;
   wire XLXN_81;
   wire XLXN_82;
   wire XLXN_125;
   wire XLXN_126;
   wire XLXN_127;
   wire XLXN_128;
   wire XLXN_129;
   wire XLXN_130;
   wire XLXN_131;
   
   OR4  AND_A (.I0(XLXN_51), 
              .I1(XLXN_50), 
              .I2(XLXN_49), 
              .I3(XLXN_48), 
              .O(XLXN_131));
   OR4  AND_B (.I0(XLXN_55), 
              .I1(XLXN_54), 
              .I2(XLXN_53), 
              .I3(XLXN_52), 
              .O(XLXN_130));
   OR3  AND_C (.I0(XLXN_56), 
              .I1(XLXN_57), 
              .I2(XLXN_55), 
              .O(XLXN_129));
   OR4  AND_D (.I0(XLXN_60), 
              .I1(XLXN_59), 
              .I2(XLXN_50), 
              .I3(XLXN_51), 
              .O(XLXN_128));
   OR3  AND_E (.I0(XLXN_63), 
              .I1(XLXN_62), 
              .I2(XLXN_61), 
              .O(XLXN_127));
   OR4  AND_F (.I0(XLXN_70), 
              .I1(XLXN_69), 
              .I2(XLXN_68), 
              .I3(XLXN_48), 
              .O(XLXN_126));
   OR3  AND_G (.I0(XLXN_82), 
              .I1(XLXN_81), 
              .I2(XLXN_80), 
              .O(XLXN_125));
   AND3  B3 (.I0(XLXN_46), 
            .I1(D2), 
            .I2(D3), 
            .O(XLXN_55));
   INV  XILINX_INV (.I(D0), 
                   .O(XLXN_46));
   INV  XLXI_2 (.I(D1), 
               .O(XLXN_64));
   INV  XLXI_3 (.I(D2), 
               .O(XLXN_14));
   INV  XLXI_5 (.I(D3), 
               .O(XLXN_20));
   AND4  XLXI_26 (.I0(XLXN_20), 
                 .I1(XLXN_14), 
                 .I2(XLXN_46), 
                 .I3(D1), 
                 .O(XLXN_57));
   AND4  XLXI_28 (.I0(XLXN_20), 
                 .I1(XLXN_64), 
                 .I2(D0), 
                 .I3(D2), 
                 .O(XLXN_54));
   AND4  XLXI_31 (.I0(XLXN_14), 
                 .I1(XLXN_20), 
                 .I2(XLXN_64), 
                 .I3(D0), 
                 .O(XLXN_51));
   AND4  XLXI_32 (.I0(D2), 
                 .I1(XLXN_46), 
                 .I2(XLXN_64), 
                 .I3(XLXN_20), 
                 .O(XLXN_50));
   AND4  XLXI_33 (.I0(XLXN_14), 
                 .I1(D0), 
                 .I2(D1), 
                 .I3(D3), 
                 .O(XLXN_49));
   AND4  XLXI_34 (.I0(XLXN_64), 
                 .I1(D0), 
                 .I2(D2), 
                 .I3(D3), 
                 .O(XLXN_48));
   AND3  XLXI_35 (.I0(XLXN_46), 
                 .I1(D1), 
                 .I2(D2), 
                 .O(XLXN_53));
   AND3  XLXI_36 (.I0(D3), 
                 .I1(D1), 
                 .I2(D0), 
                 .O(XLXN_52));
   AND3  XLXI_38 (.I0(D3), 
                 .I1(D2), 
                 .I2(D1), 
                 .O(XLXN_56));
   AND3  XLXI_43 (.I0(D2), 
                 .I1(D1), 
                 .I2(D0), 
                 .O(XLXN_59));
   AND3  XLXI_47 (.I0(D0), 
                 .I1(XLXN_64), 
                 .I2(XLXN_14), 
                 .O(XLXN_61));
   AND3  XLXI_48 (.I0(D2), 
                 .I1(XLXN_64), 
                 .I2(XLXN_20), 
                 .O(XLXN_62));
   AND2  XLXI_49 (.I0(D0), 
                 .I1(XLXN_20), 
                 .O(XLXN_63));
   AND3  XLXI_51 (.I0(XLXN_20), 
                 .I1(D0), 
                 .I2(D1), 
                 .O(XLXN_68));
   AND3  XLXI_52 (.I0(D1), 
                 .I1(XLXN_14), 
                 .I2(XLXN_20), 
                 .O(XLXN_69));
   AND3  XLXI_53 (.I0(D0), 
                 .I1(XLXN_14), 
                 .I2(XLXN_20), 
                 .O(XLXN_70));
   AND4  XLXI_55 (.I0(D3), 
                 .I1(D2), 
                 .I2(XLXN_64), 
                 .I3(XLXN_46), 
                 .O(XLXN_82));
   AND4  XLXI_56 (.I0(D2), 
                 .I1(D1), 
                 .I2(D0), 
                 .I3(XLXN_20), 
                 .O(XLXN_81));
   AND3  XLXI_57 (.I0(XLXN_20), 
                 .I1(XLXN_14), 
                 .I2(XLXN_64), 
                 .O(XLXN_80));
   OR2  XLXI_94 (.I0(LE), 
                .I1(XLXN_125), 
                .O(g));
   OR2  XLXI_95 (.I0(LE), 
                .I1(XLXN_126), 
                .O(f));
   OR2  XLXI_96 (.I0(LE), 
                .I1(XLXN_127), 
                .O(e));
   OR2  XLXI_97 (.I0(LE), 
                .I1(XLXN_128), 
                .O(d));
   OR2  XLXI_98 (.I0(LE), 
                .I1(XLXN_129), 
                .O(c));
   OR2  XLXI_99 (.I0(LE), 
                .I1(XLXN_130), 
                .O(b));
   OR2  XLXI_100 (.I0(LE), 
                 .I1(XLXN_131), 
                 .O(a));
   INV  XLXI_106 (.I(point), 
                 .O(p));
   AND4  XLXI_107 (.I0(XLXN_14), 
                  .I1(XLXN_46), 
                  .I2(D3), 
                  .I3(D1), 
                  .O(XLXN_60));
endmodule
