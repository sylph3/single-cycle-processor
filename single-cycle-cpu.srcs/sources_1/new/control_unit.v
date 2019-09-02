`timescale 1ns / 1ps
`include "instruction_head.v"

/* Module: Control Unit
 */

module control_unit(
           input wire      clk,
           input wire      rst,
           input wire[5:0] opcode,
           input wire[4:0] sa,
           input wire[5:0] func,
           input wire      zero, // For instruction BEQ, determining the result of rs-rt

           output wire[`ALU_OP_LENGTH - 1:0]  alu_op,
           output wire                        reg_dst,
           output wire                        reg_write,
           output wire                        alu_src,
           output wire                        mem_write,
           output wire[`REG_SRC_LENGTH - 1:0] reg_src,
           output wire                        ext_op,
           output wire                        npc_op
       );

wire type_r, lui, addiu, add, subu, lw, sw, beq, j;

// Whether instruction is R-Type
assign type_r    = (opcode == `INST_R_TYPE)       ? 1 : 0;
// R-Type instructions
assign add       = (type_r && func == `FUNC_ADD)  ? 1 : 0;
assign subu      = (type_r && func == `FUNC_SUBU) ? 1 : 0;

// I-Type Instructions
assign lui       = (opcode == `INST_LUI)          ? 1 : 0;
assign addiu     = (opcode == `INST_ADDIU)        ? 1 : 0;
assign lw        = (opcode == `INST_LW)           ? 1 : 0;
assign sw        = (opcode == `INST_SW)           ? 1 : 0;
assign beq       = (opcode == `INST_BEQ)          ? 1 : 0;

// J-Type Instructions
assign j         = (opcode == `INST_J)            ? 1 : 0;

// Determine ALUOp signal
assign alu_op    = (add || addiu || lw || sw) ? `ALU_OP_ADD :
       (subu || beq) ? `ALU_OP_SUB : `ALU_OP_DEFAULT;
// Determine RegWrite signal
assign reg_write = (type_r || add || subu) ? 1 : 0;
endmodule
