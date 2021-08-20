module reg_m2w(clk,enable,clr,pc_mem_16,instr_mem_16,cw_mem_8,in_mem_16,k_mem_3,dest_mem_3,pc_wb_16,instr_wb_16,cw_wb_8,in_wb_16,k_wb_3,dest_wb_3);
input clk,enable,clr;
input [15:0] pc_mem_16,instr_mem_16,in_mem_16;
input [2:0] k_mem_3,dest_mem_3;
input [7:0] cw_mem_8;
output reg [15:0] pc_wb_16,instr_wb_16,in_wb_16;
output reg [7:0] cw_wb_8;
output reg [2:0] k_wb_3,dest_wb_3;
always@(posedge clk)
begin
if (clr)
	begin
	 pc_wb_16<=16'h0000;
	 instr_wb_16<=16'h0000;
	 in_wb_16<=16'h0000;
	 k_wb_3<=3'b000;
	 dest_wb_3<=3'b000;
	 cw_wb_8<=8'h00;
	end
else if(enable)
	begin
	pc_wb_16<=pc_mem_16;
	 instr_wb_16<=instr_mem_16;
	 in_wb_16<=in_mem_16;
	 k_wb_3<=k_mem_3;
	 dest_wb_3<=dest_mem_3;
	 cw_wb_8<=cw_mem_8;
	end
end
endmodule
//Test_bench-working
//`timescale 1 ns/1 ps
//module tb_reg_m2w;
//reg tb_clk,tb_enable,tb_clr;
//reg [15:0] tb_pc_mem_16,tb_instr_mem_16,tb_in_mem_16;
//reg [2:0] tb_dest_mem_3,tb_k_mem_3;
//reg [7:0] tb_cw_mem_8;
//wire [15:0] tb_pc_wb_16,tb_instr_wb_16,tb_in_wb_16;
//wire [7:0] tb_cw_wb_8;
//wire [2:0] tb_dest_wb_3,tb_k_wb_3;
//reg_m2w R4(tb_clk,tb_enable,tb_clr,tb_pc_mem_16,tb_instr_mem_16,tb_cw_mem_8,tb_in_mem_16,tb_k_mem_3,tb_dest_mem_3,tb_pc_wb_16,tb_instr_wb_16,tb_cw_wb_8,tb_in_wb_16,tb_k_wb_3,tb_dest_wb_3);
//
//initial 
//begin
//tb_clk=1'b0;
//tb_enable=0;
//tb_clr=0;
//tb_pc_mem_16=16'h1234;
//tb_instr_mem_16=16'habcd;
//tb_in_mem_16=16'haaaa;
//
//tb_k_mem_3=3'b111;
//tb_dest_mem_3=3'b101;
//tb_cw_mem_8=8'h21;
//#15;
//tb_enable=1;
//tb_pc_mem_16=16'h1234;
//tb_instr_mem_16=16'habcd;
//tb_in_mem_16=16'haaaa;
//
//tb_k_mem_3=3'b011;
//tb_dest_mem_3=3'b101;
//tb_cw_mem_8=8'h21;
//#20;
//tb_clr=1;
//#20;
//tb_pc_mem_16=16'h1dd4;
//tb_instr_mem_16=16'habdd;
//tb_in_mem_16=16'hdaaa;
//
//tb_k_mem_3=3'b010;
//tb_dest_mem_3=3'b001;
//tb_cw_mem_8=8'hd1;
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