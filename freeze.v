module freeze(instr_mem_4,k_mem_3,freeze1,source1_dec_address_3,source2_dec_address_3,dest_exe_address_3,cw_exe_bit5,freeze2,instr_exe);

input [3:0]instr_mem_4,instr_exe;
input [2:0] k_mem_3,source1_dec_address_3,source2_dec_address_3,dest_exe_address_3;
output freeze1,freeze2;
input cw_exe_bit5;
assign freeze1=(((k_mem_3>=3'b000 )&& (k_mem_3<=3'b101))&&((instr_mem_4==4'b1100) ||(instr_mem_4==4'b1101)||(instr_mem_4==4'b1110)||(instr_mem_4==4'b1111)))?1'b1:1'b0;
assign freeze2=((~(|(source1_dec_address_3 ^dest_exe_address_3))||(~(|(source2_dec_address_3 ^dest_exe_address_3))))&instr_exe==4'b0100)||instr_exe==4'b1100||instr_exe==4'b1110;//first condition dont satisfy LA or LM
endmodule

//testbench-working

//`timescale 1 ns/ 1 ps
//module tb_freeze;
//
//reg [3:0] tb_instr_mem_4;
//reg [2:0] tb_k_mem_3,tb_source1_dec_address_3,tb_source2_dec_address_3,tb_dest_exe_address_3;
//wire tb_freeze1,tb_freeze2;
//reg tb_cw_exe_bit5;
//freeze f1(tb_instr_mem_4,tb_k_mem_3,tb_freeze1,tb_source1_dec_address_3,tb_source2_dec_address_3,tb_dest_exe_address_3,tb_cw_exe_bit5,tb_freeze2);
//initial
//begin
//tb_instr_mem_4=4'b1001;
//tb_k_mem_3=3'b100;
//tb_source1_dec_address_3=3'b101;
//tb_source2_dec_address_3=3'b001;
//tb_dest_exe_address_3=3'b100;
//tb_cw_exe_bit5=1'b1;
//#20;
//tb_instr_mem_4=4'b1001;
//tb_k_mem_3=3'b100;
//tb_source1_dec_address_3=3'b101;
//tb_source2_dec_address_3=3'b001;
//tb_dest_exe_address_3=3'b101;
//tb_cw_exe_bit5=1'b1;
//#20;
//tb_instr_mem_4=4'b1100;
//tb_k_mem_3=3'b100;
//tb_source1_dec_address_3=3'b101;
//tb_source2_dec_address_3=3'b001;
//tb_dest_exe_address_3=3'b001;
//tb_cw_exe_bit5=1'b1;
//#20;
//tb_instr_mem_4=4'b1111;
//tb_k_mem_3=3'b100;
//tb_source1_dec_address_3=3'b101;
//tb_source2_dec_address_3=3'b100;
//tb_dest_exe_address_3=3'b100;
//tb_cw_exe_bit5=1'b0;
//#20;
//tb_instr_mem_4=4'b1111;
//tb_k_mem_3=3'b110;
//tb_source1_dec_address_3=3'b001;
//tb_source2_dec_address_3=3'b001;
//tb_dest_exe_address_3=3'b001;
//#20;
//end
//endmodule