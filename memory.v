//memory -1 port 
//16x5000 bits
module memory(address,write_data,write_en,data_out,clk);
input [15:0] address,write_data;
input write_en,clk;
output wire [15:0] data_out;
//create memory and initialize everything inside with zero
reg [15:0] data_memory [0:999];//considering only first 1000 memory locations
initial
begin
data_memory[128]=13;
data_memory[129]=5;

data_memory[0]=0;
data_memory[1]=2;
data_memory[2]=4;
data_memory[3]=6;
data_memory[4]=8;
data_memory[5]=10;
data_memory[6]=12;
end

assign  data_out=data_memory[address];
always@(posedge clk)
	begin
		if(write_en==1'b1 )
			data_memory[address]<=write_data;
			
	end
endmodule
//working

//`timescale 1 ns/1 ps
//module t_memory;
//
//reg [15:0] t_address,t_write_data;
//reg t_write_en,t_clk;
//wire [15:0] t_data_out;
//
//memory m1(t_address,t_write_data,t_write_en,t_data_out,t_clk);
//initial 
//begin
//t_clk=1'b0;
//
//#5;
//t_address=16'b0000000000000010;
//t_write_data=16'b1111000011110000;
//t_write_en=1'b0;
//#20;
//t_address=16'b0000000000000010;
//t_write_data=16'b1111000011110000;
//t_write_en=1'b1;
//#20;
//t_address=16'b0000000000000011;
//t_write_data=16'b1111000011111111;
//t_write_en=1'b1;
//#20;
//t_address=16'b0000000000000100;
//t_write_data=16'b1111111111111111;
//t_write_en=1'b1;
//#20;
//t_address=16'b0000000000000010;
//
//t_write_en=1'b0;
//#20;
//t_address=16'b0000000000000011;
//
//t_write_en=1'b0;
//#20;
//t_address=16'b0000000000000100;
//
//t_write_en=1'b0;
//end
//always
//begin
//#10;
//t_clk<=~t_clk;
//end
//
//
//endmodule