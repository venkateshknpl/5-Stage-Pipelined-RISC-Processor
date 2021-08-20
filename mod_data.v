module mod_data(raw_data_112,dest_address_wb,data_wb,k_mem,data_out_16);
input [111:0] raw_data_112;
input [2:0] dest_address_wb,k_mem;
input [15:0] data_wb;
output [15:0] data_out_16;
reg [15:0]out_16;
assign data_out_16=out_16;
always@(raw_data_112,dest_address_wb,data_wb,k_mem)
begin
	if (k_mem==dest_address_wb)
		out_16=data_wb;
	else if (k_mem==3'b000)
		out_16=raw_data_112[15:0];
	else if (k_mem==3'b001)
		out_16=raw_data_112[31:16];
	else if (k_mem==3'b010)
		out_16=raw_data_112[47:32];
	else if (k_mem==3'b011)
		out_16=raw_data_112[63:48];
	else if (k_mem==3'b100)
		out_16=raw_data_112[79:64];
	else if (k_mem==3'b101)
		out_16=raw_data_112[95:80];
	else if (k_mem==3'b110)
		out_16=raw_data_112[111:96];
	else
		out_16=16'b0000000000000000;
end
endmodule

//testbench-working
//`timescale 1 ns/1 ps
//module tb_mod_data;
//reg [111:0] tb_raw_data_112;
//reg [2:0] tb_dest_address_wb,tb_k_mem;
//reg [15:0] tb_data_wb;
//wire [15:0] tb_data_out_16;
//mod_data c2(tb_raw_data_112,tb_dest_address_wb,tb_data_wb,tb_k_mem,tb_data_out_16);
//initial 
//begin
//tb_raw_data_112=112'b1111111111111111000000000000000010101010101010100101010101010101111100001111000000000000111111111111111100001111;
//tb_dest_address_wb=3'b101;
//tb_data_wb=16'b0000000111111110;
//tb_k_mem=3'b000;
//end
//
//
//initial
//begin
//#20;
//tb_k_mem=3'b001;
//#20;
//tb_k_mem=3'b010;
//#20;
//tb_k_mem=3'b011;
//#20;
//tb_k_mem=3'b100;
//#20;
//tb_k_mem=3'b101;
//#20;
//tb_k_mem=3'b110;
//#20;
//tb_k_mem=3'b001;
//#20;
//tb_k_mem=3'b010;
//#20;
//tb_k_mem=3'b011;
//#20;
//tb_k_mem=3'b101;
//end
//
//endmodule
