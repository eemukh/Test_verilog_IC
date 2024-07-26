/*
 * Copyright (c) 2024 Eehit Mukherjee
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_eemukh_ControlBlock (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  //assign uio_out = 0;
  assign uio_oe[3:0] = 0;
  assign uio_oe[7:4] = 1;

  //Inputs
  wire [5:0] OPcode; // Input 6 OPCode instruction bits
  wire [1:0] F5_4; //Last two funct. instruction bits

  //Outputs
  wire RegDst;
  wire ALUSrc;
  wire MemtoReg;
  wire RegWrite;
  wire MemRead;
  wire MemWrite;
  wire Branch;

  //6-bit Outputs
  wire Out1;
  wire Out2;
  wire Out3;
  wire Out4;

  //internal output (not outputed from circuit)
  wire [1:0] ALUOp;

  //Bidirectional Inputs
  wire [3:0] F3_0; //Only F6[3:0] are bidirectional inputs

  //Bidirectional Outputs
  wire Op0;
  wire Op1;
  wire Op2;
  wire Op3;

  //Assignments
  assign OPcode = ui_in[5:0];

  assign uo_out[6] = RegDst;
  assign uo_out[5] = ALUSrc;
  assign uo_out[4] = MemtoReg;
  assign uo_out[3] = RegWrite;
  assign uo_out[2] = MemRead;
  assign uo_out[1] = MemWrite;
  assign uo_out[0] = Branch;

  assign uo_out[7] = 0;

  assign F3_0[3:0] = uio_in[3:0];


  assign uio_out[0] = Op0;
  assign uio_out[1] = Op1;
  assign uio_out[2] = Op2;
  assign uio_out[3] = Op3;
  assign uio_out[7:4] = 0;

  //Main Control Unit

  //Variables to assign the outputs of the 4 6-input AND gates
  assign Out1 = ~OPcode[0] & ~OPcode[1] & ~OPcode[2] & ~OPcode[3] & ~OPcode[4] & ~OPcode[5];
  assign Out2 = OPcode[0] & OPcode[1] & ~OPcode[2] & ~OPcode[3] & ~OPcode[4] & OPcode[5];
  assign Out3 = OPcode[0] & OPcode[1] & ~OPcode[2] & OPcode[3] & ~OPcode[4] & OPcode[5];
  assign Out4 = ~OPcode[0] & ~OPcode[1] & OPcode[2] & ~OPcode[3] & ~OPcode[4] & ~OPcode[5];

  assign RegDst = Out1; 
  assign ALUSrc = Out2 | Out3;
  assign MemtoReg = Out2;
  assign RegWrite = Out1 | Out2;
  assign MemRead = Out2;
  assign MemWrite = Out3;
  assign Branch = Out4;
  assign ALUOp[0] = Out4;
  assign ALUOp[1] = Out1; 

  assign F5_4[1] = 1;
  assign F5_4[0] = 0;

  //ALU Control Unit
//______________________________________________
  assign Op3 = ALUOp[0] & ~ALUOp[0];
  assign Op2 = ALUOp[0] | (ALUOp[1] & F3_0[1]);
  assign Op1 = ~ALUOp[1] | ~F3_0[2];
  assign Op0 = ALUOp[1] & (F3_0[0] | F3_0[3]);          
//______________________________________________

  
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, 1'b0};

endmodule
