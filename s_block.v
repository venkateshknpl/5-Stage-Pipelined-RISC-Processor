module s_block(cw_mem_before_sblock,cw_mem_after_sblock,instr_mem,k_mem);
input [7:0] cw_mem_before_sblock;
output [7:0] cw_mem_after_sblock;
input [15:0] instr_mem;
input [2:0] k_mem;
wire signal;
wire [6:0] immediate;
wire [3:0] opcode;
assign immediate=instr_mem[6:0];
assign opcode=instr_mem[15:12];
assign signal=(immediate[3'b110-k_mem]==1'b1)?1'b1:1'b0;
assign cw_mem_after_sblock=((opcode==4'b1100)||(opcode==4'b1101))?cw_mem_before_sblock&{6'b111111,signal,signal}:cw_mem_before_sblock;
endmodule

//TESTBENCH-working
//`timescale 1 ns/1 ps
//module tb_s_block;
//reg [7:0] tb_cw_mem_before_sblock;
//wire [7:0] tb_cw_mem_after_sblock;
//reg [15:0] tb_instr_mem;
//reg [2:0] tb_k_mem;
//s_block sb0(tb_cw_mem_before_sblock,tb_cw_mem_after_sblock,tb_instr_mem,tb_k_mem);
//initial
//begin
//tb_cw_mem_before_sblock=8'b10101011;
//#10;
//tb_instr_mem=16'b1100101001010011;
//tb_k_mem=3'b000;
//#10;
//tb_k_mem=3'b001;
//#10;
//tb_k_mem=3'b010;
//#10;
//tb_k_mem=3'b011;
//#10;
//tb_k_mem=3'b100;
//#10;
//tb_k_mem=3'b101;
//#10;
//tb_k_mem=3'b110;
//#10;
//tb_instr_mem=16'b1010101001010011;
//#10;
//tb_k_mem=3'b000;
//#10;
//tb_k_mem=3'b001;
//#10;
//tb_k_mem=3'b010;
//#10;
//tb_k_mem=3'b011;
//#10;
//tb_k_mem=3'b100;
//#10;
//tb_k_mem=3'b101;
//#10;
//tb_k_mem=3'b110;
//#10;
//end
//
//endmodule
//

