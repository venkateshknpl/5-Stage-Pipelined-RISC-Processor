module reg_e2m(clk,enable,clr,pc_exe_16,instr_exe_16,cw_exe_8,in_exe_16,ra_exe_16,dest_exe_3,pc_mem_16,instr_mem_16,cw_mem_8,in_mem_16,ra_mem_16,dest_mem_3);
input clk,enable,clr;
input [15:0] pc_exe_16,instr_exe_16,in_exe_16,ra_exe_16;
input [2:0] dest_exe_3;
input [7:0] cw_exe_8;
output reg [15:0] pc_mem_16,instr_mem_16,in_mem_16,ra_mem_16;
output reg [7:0] cw_mem_8;
output reg [2:0] dest_mem_3;
always@(posedge clk)
begin
if (clr)
	begin
	 pc_mem_16<=16'h0000;
	 instr_mem_16<=16'h0000;
	 in_mem_16<=16'h0000;
	 ra_mem_16<=16'h0000;
	 dest_mem_3<=3'b000;
	 cw_mem_8<=8'h00;
	end
else if(enable)
	begin
	pc_mem_16<=pc_exe_16;
	 instr_mem_16<=instr_exe_16;
	 in_mem_16<=in_exe_16;
	 
	 ra_mem_16<=ra_exe_16;
	 dest_mem_3<=dest_exe_3;
	 cw_mem_8<=cw_exe_8;
	end
end
endmodule
//Test_bench-working
//`timescale 1 ns/1 ps
//module tb_reg_e2m;
//reg tb_clk,tb_enable,tb_clr;
//reg [15:0] tb_pc_exe_16,tb_instr_exe_16,tb_in_exe_16,tb_ra_exe_16;
//reg [2:0] tb_dest_exe_3;
//reg [7:0] tb_cw_exe_8;
//wire [15:0] tb_pc_mem_16,tb_instr_mem_16,tb_in_mem_16,tb_ra_mem_16;
//wire [7:0] tb_cw_mem_8;
//wire [2:0] tb_dest_mem_3;
//reg_e2m R3(tb_clk,tb_enable,tb_clr,tb_pc_exe_16,tb_instr_exe_16,tb_cw_exe_8,tb_in_exe_16,tb_ra_exe_16,tb_dest_exe_3,tb_pc_mem_16,tb_instr_mem_16,tb_cw_mem_8,tb_in_mem_16,tb_ra_mem_16,tb_dest_mem_3);
//
//initial 
//begin
//tb_clk=1'b0;
//tb_enable=0;
//tb_clr=0;
//tb_pc_exe_16=16'h1234;
//tb_instr_exe_16=16'habcd;
//tb_in_exe_16=16'haaaa;
//
//tb_ra_exe_16=16'h0101;
//tb_dest_exe_3=3'b101;
//tb_cw_exe_8=8'h21;
//#15;
//tb_enable=1;
//tb_pc_exe_16=16'h1234;
//tb_instr_exe_16=16'habcd;
//tb_in_exe_16=16'haaaa;
//
//tb_ra_exe_16=16'h0101;
//tb_dest_exe_3=3'b101;
//tb_cw_exe_8=8'h21;
//#20;
//tb_clr=1;
//#20;
//tb_pc_exe_16=16'h1dd4;
//tb_instr_exe_16=16'habdd;
//tb_in_exe_16=16'hdaaa;
//
//tb_ra_exe_16=16'h0d01;
//tb_dest_exe_3=3'b001;
//tb_cw_exe_8=8'hd1;
//#20;
//tb_clr=0;
//end
//
//always
//begin
//#10;
//tb_clk<=~tb_clk;
//end
//
//
//endmodule