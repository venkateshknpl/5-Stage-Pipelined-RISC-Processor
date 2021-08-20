module k_block_address_mux(instr_mem_4,immediate_7,clk,data_from_exe_16,address_16,k);
input [3:0]instr_mem_4;
input [6:0] immediate_7;
input clk;
input [15:0] data_from_exe_16;
output [15:0] address_16;
output [2:0]k;
wire [2:0] l_wire,k_wire,mux_out;
wire [15:0] out;
assign k=k_wire;
assign address_16=out;
k_block C3(instr_mem_4,immediate_7,clk,k_wire,l_wire);
assign mux_out=((instr_mem_4==4'b1100) || (instr_mem_4==4'b1101))?l_wire:k_wire;
assign out={13'b0000000000000,mux_out}+data_from_exe_16;
endmodule

//instr_mem_4--->@ mem stage instr[15:12]
//immediate_7--->@mem stage instr[6:0]
//k is a 3 bit counter 
//l is also a 3 bit counter with smaller mod
module k_block(instr_mem_4,immediate_7,clk,k,l);
input [3:0] instr_mem_4;
input [6:0] immediate_7;
input clk;
output [2:0] k,l;
reg [2:0] k_count=0;
reg [2:0] l_count=0;
assign k=k_count;
assign l=l_count;
always@(posedge clk)
begin
 if(k_count>=3'b110)
		begin
		k_count<=3'b000;
		l_count<=3'b000;
		end
 else if((instr_mem_4==4'b1110)||(instr_mem_4==4'b1111))//LA or SA
		begin
		k_count<=k_count+3'b001;
		end
 else if((instr_mem_4==4'b1100)||(instr_mem_4==4'b1101))//LM or SM
		begin
		if(immediate_7[6-k]==1'b1)
			l_count<=l_count+3'b001;
		
		k_count<=k_count+3'b001;
		end
end
endmodule

//working
//`timescale 1 ns/1 ps
//module tb_kblock;
//reg [15:0] tb_data_from_exe_16;
//reg [3:0] tb_instr_mem_4;
//reg [6:0] tb_immediate_7;
//reg tb_clk;
//wire [2:0] tb_k;
//wire [15:0] tb_address_16;
//k_block_address_mux c4(tb_instr_mem_4,tb_immediate_7,tb_clk,tb_data_from_exe_16,tb_address_16,tb_k);
//
//
//initial 
//begin
//tb_data_from_exe_16=16'b011100000001111;
//tb_clk=1'b0;
//tb_instr_mem_4=4'b1110;
//tb_immediate_7=7'b0000000;
//#15;
//tb_immediate_7=7'b1010101;
//end
//always
//begin
//#10;
//tb_clk<=~tb_clk;
//end
//
//initial
//begin
//#140
//tb_instr_mem_4=4'b1100;
//end
//
//endmodule
