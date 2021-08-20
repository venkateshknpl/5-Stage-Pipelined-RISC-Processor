module reg_d2e(clk,enable,clr,pc_dec_16,instr_dec_16,cw_dec_8,in1_dec_16,in2_dec_16,ra_dec_16,dest_dec_3,pc_exe_16,instr_exe_16,cw_exe_8,in1_exe_16,in2_exe_16,ra_exe_16,dest_exe_3,history_in,history_out);
input clk,enable,clr,history_in;
output reg history_out;
input [15:0] pc_dec_16,instr_dec_16,in1_dec_16,in2_dec_16,ra_dec_16;
input [2:0] dest_dec_3;
input [7:0] cw_dec_8;
output reg [15:0] pc_exe_16,instr_exe_16,in1_exe_16,in2_exe_16,ra_exe_16;
output reg [7:0] cw_exe_8;
output reg [2:0] dest_exe_3;
always@(posedge clk)
begin
if (clr)
	begin
	 pc_exe_16<=16'h0000;
	 instr_exe_16<=16'h0000;
	 in1_exe_16<=16'h0000;
	 in2_exe_16<=16'h0000;
	 ra_exe_16<=16'h0000;
	 dest_exe_3<=3'b000;
	 cw_exe_8<=8'h00;
	 history_out<=1'b0;
	end
else if(enable)
	begin
	pc_exe_16<=pc_dec_16;
	 instr_exe_16<=instr_dec_16;
	 in1_exe_16<=in1_dec_16;
	 in2_exe_16<=in2_dec_16;
	 ra_exe_16<=ra_dec_16;
	 dest_exe_3<=dest_dec_3;
	 cw_exe_8<=cw_dec_8;
	
	 history_out<=history_in;
	end
end
endmodule
//Test_bench-working
//`timescale 1 ns/1 ps
//module tb_reg_d2e;
//reg tb_clk,tb_enable,tb_clr;
//reg [15:0] tb_pc_dec_16,tb_instr_dec_16,tb_in1_dec_16,tb_in2_dec_16,tb_ra_dec_16;
//reg [2:0] tb_dest_dec_3;
//reg [7:0] tb_cw_dec_8;
//wire [15:0] tb_pc_exe_16,tb_instr_exe_16,tb_in1_exe_16,tb_in2_exe_16,tb_ra_exe_16;
//wire [2:0] tb_dest_exe_3;
//wire [7:0] tb_cw_exe_8;
//reg_d2e r2(tb_clk,tb_enable,tb_clr,tb_pc_dec_16,tb_instr_dec_16,tb_cw_dec_8,tb_in1_dec_16,tb_in2_dec_16,tb_ra_dec_16,tb_dest_dec_3,tb_pc_exe_16,tb_instr_exe_16,tb_cw_exe_8,tb_in1_exe_16,tb_in2_exe_16,tb_ra_exe_16,tb_dest_exe_3);
//
//initial 
//begin
//tb_clk=1'b0;
//tb_enable=0;
//tb_clr=0;
//tb_pc_dec_16=16'h1234;
//tb_instr_dec_16=16'habcd;
//tb_in1_dec_16=16'haaaa;
//tb_in2_dec_16=16'h0001;
//tb_ra_dec_16=16'h0101;
//tb_dest_dec_3=3'b101;
//tb_cw_dec_8=8'h21;
//#15;
//tb_enable=1;
//tb_pc_dec_16=16'h1234;
//tb_instr_dec_16=16'habcd;
//tb_in1_dec_16=16'haaaa;
//tb_in2_dec_16=16'h0001;
//tb_ra_dec_16=16'h0101;
//tb_dest_dec_3=3'b101;
//tb_cw_dec_8=8'h21;
//#20;
//tb_clr=1;
//#20;
//tb_pc_dec_16=16'h1dd4;
//tb_instr_dec_16=16'habdd;
//tb_in1_dec_16=16'hdaaa;
//tb_in2_dec_16=16'hd001;
//tb_ra_dec_16=16'h0d01;
//tb_dest_dec_3=3'b001;
//tb_cw_dec_8=8'hd1;
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