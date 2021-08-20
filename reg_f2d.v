module reg_f2d(clk,enable,clr,instr_f_16,pc_f_16,instr_d_16,pc_d_16,history_in,history_out);//modified
input clk,enable,clr;
input history_in;
output reg history_out;
input [15:0] instr_f_16,pc_f_16;
output reg [15:0] instr_d_16,pc_d_16;
always@(posedge clk)
begin
if (clr)
	begin
	 instr_d_16<=16'h0000;
	 pc_d_16<=16'h0000;

	 history_out<=1'b0;
	end
else if(enable)
	begin
	 instr_d_16<=instr_f_16;
	 pc_d_16<=pc_f_16;

	 history_out<=history_in;
	
	end
end
endmodule
//Test_bench-working
//`timescale 1 ns/1 ps
//module tb_reg_f2d;
//reg tclk,tenable,tclr;
//reg [15:0] tinstr_f_16,tpc_f_16;
//wire [15:0] tinstr_d_16,tpc_d_16;
//reg_f2d R(tclk,tenable,tclr,tinstr_f_16,tpc_f_16,tinstr_d_16,tpc_d_16);
//initial 
//begin
//tclk=1'b0;
//tenable=0;
//tclr=0;
//tinstr_f_16=16'b1010101000000000;
//tpc_f_16=16'b1100111100001111;
//#15;
//tenable=1;
//tinstr_f_16=16'b1010101000000000;
//tpc_f_16=16'b1100111100001111;
//#20;
//tclr=1;
//#20;
//tinstr_f_16=16'h2145;
//tpc_f_16=16'h1025;
//
//end
//
//always
//begin
//#10;
//tclk<=~tclk;
//end
//
//
//endmodule