module controller(instr_decode_4,cw_decode_8);
input [3:0] instr_decode_4;
output [7:0] cw_decode_8;
reg [7:0] temp;
assign cw_decode_8=temp;
always@(instr_decode_4)
begin
case(instr_decode_4)
4'b0001: temp=8'b00000001;//ADD
4'b0010: temp=8'b00000001;//NAND
4'b0000: temp=8'b00000101;//ADI
4'b0011: temp=8'b00011001;//LWI
4'b1001: temp=8'b01010001;//JAL
4'b1011: temp=8'b00000000;//JRI
4'b1010: temp=8'b01010001;//JLR
4'b1000: temp=8'b00000000;//BEQ
4'b0100: temp=8'b10110001;//LW
4'b0101: temp=8'b10000010;//SW
4'b1110: temp=8'b00100001;//LA

4'b1111: temp=8'b00000010;//SA
4'b1100: temp=8'b00100001;//LM
4'b1101: temp=8'b00000010;//SM

default: temp=8'b00000000;//NOP

endcase
end
endmodule
////Testbench-working
//`timescale 1 ns/1 ps
//module tb_controller;
//
//reg [3:0] tb_instr_decode_4;
//wire [7:0] tb_cw_decode_8;
//controller c1(tb_instr_decode_4,tb_cw_decode_8);
//initial 
//begin
//tb_instr_decode_4=4'b1011;
//#15;
//tb_instr_decode_4=4'b1111;
//#15;
//tb_instr_decode_4=4'b0111;
//end
//
//
//endmodule
