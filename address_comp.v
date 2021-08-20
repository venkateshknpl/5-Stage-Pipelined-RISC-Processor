//Address comp_block
//lm is 2 bits used for selecting the data
module address_comp(source_address,dest_address_exe,dest_address_mem,dest_address_wb,v_exe,v_mem,v_wb,lm);
input [2:0] source_address,dest_address_exe,dest_address_mem,dest_address_wb;
input v_exe,v_mem,v_wb;
output [1:0] lm;
reg [1:0] select;
assign lm=select;
always@(source_address,dest_address_exe,dest_address_mem,dest_address_wb,v_exe,v_mem,v_wb)
	begin
	if (source_address==dest_address_exe && v_exe==1'b1)
		select=2'b01;
	else if (source_address==dest_address_mem && v_mem==1'b1)
		select=2'b10;
	else if (source_address==dest_address_wb && v_wb==1'b1)
		select=2'b11;
	else
		select=2'b00;
		
	end
endmodule
//Testbench
//working
//`timescale 1 ns/1 ps
//module tb_address_comp;
//reg [2:0] tb_source_address,tb_dest_address_exe,tb_dest_address_mem,tb_dest_address_wb;
//reg tb_v_exe,tb_v_mem,tb_v_wb;
//wire [1:0] tb_lm;
//address_comp ac (tb_source_address,tb_dest_address_exe,tb_dest_address_mem,tb_dest_address_wb,tb_v_exe,tb_v_mem,tb_v_wb,tb_lm);
//initial 
//begin
//tb_source_address=3'b101;
//tb_dest_address_exe=3'b101;
//tb_dest_address_mem=3'b101;
//tb_dest_address_wb=3'b101;
//tb_v_exe=1;
//tb_v_mem=1;
//tb_v_wb=1;
//#10;
//tb_source_address=3'b101;
//tb_dest_address_exe=3'b101;
//tb_dest_address_mem=3'b101;
//tb_dest_address_wb=3'b101;
//tb_v_exe=0;
//tb_v_mem=0;
//tb_v_wb=0;
//#10;
//tb_source_address=3'b101;
//tb_dest_address_exe=3'b101;
//tb_dest_address_mem=3'b101;
//tb_dest_address_wb=3'b101;
//tb_v_exe=0;
//tb_v_mem=1;
//tb_v_wb=0;
//#10;
//tb_source_address=3'b101;
//tb_dest_address_exe=3'b101;
//tb_dest_address_mem=3'b101;
//tb_dest_address_wb=3'b101;
//tb_v_exe=0;
//tb_v_mem=0;
//tb_v_wb=1;
//#10;
//tb_source_address=3'b101;
//tb_dest_address_exe=3'b101;
//tb_dest_address_mem=3'b101;
//tb_dest_address_wb=3'b101;
//tb_v_exe=0;
//tb_v_mem=1;
//tb_v_wb=1;
//#10;
//tb_source_address=3'b101;
//tb_dest_address_exe=3'b001;
//tb_dest_address_mem=3'b101;
//tb_dest_address_wb=3'b111;
//tb_v_exe=0;
//tb_v_mem=1;
//tb_v_wb=0;
//#10;
//tb_source_address=3'b101;
//tb_dest_address_exe=3'b100;
//tb_dest_address_mem=3'b101;
//tb_dest_address_wb=3'b101;
//tb_v_exe=0;
//tb_v_mem=0;
//tb_v_wb=1;
//#10;
//end
//
//
//endmodule