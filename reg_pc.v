module reg_pc(clk,enable,clr,pc_in_16,pc_out_16);
input clk,enable,clr;
input [15:0] pc_in_16;
output reg [15:0] pc_out_16;
always@(posedge clk)
begin
if (clr)
	begin
	
	 pc_out_16<=16'h0000;
	end
else if(enable)
	begin
	 
	 pc_out_16<=pc_in_16;
	
	end
end
endmodule
//Test_bench-working
//`timescale 1 ns/1 ps
//module tb_reg_pc;
//reg tclk,tenable,tclr;
//reg [15:0] tpc_in_16;
//wire [15:0] tpc_out_16;
//reg_pc R(tclk,tenable,tclr,tpc_in_16,tpc_out_16);
//initial 
//begin
//tclk=1'b0;
//tenable=0;
//tclr=0;
//tpc_in_16=16'b1100111100001111;
//#15;
//tenable=1;
//
//tpc_in_16=16'b1100111100001111;
//#20;
//tclr=1;
//#20;
//
//tpc_in_16=16'h1025;
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