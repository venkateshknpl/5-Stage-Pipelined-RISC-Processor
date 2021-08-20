//simple 4:1 mux; all inputs are 16 bits wide and selectline is of 2 bits
module mux_4to1(in1,in2,in3,in4,sel,out);
input [15:0] in1,in2,in3,in4;
input [1:0] sel;
output [15:0] out;
reg [15:0]temp;
assign out=temp;
always@(in1,in2,in3,in4,sel)
begin
case(sel)

2'b01: temp=in2;
2'b10: temp=in3;
2'b11: temp=in4;
default: temp=in1;
endcase
end
endmodule

//TEST bENCH-working
//`timescale 1 ns/1 ps
//module tb_mux;
//reg [15:0] tb_in1,tb_in2,tb_in3,tb_in4;
//reg [1:0] tb_sel;
//wire [15:0] tb_out;
//mux_4to1 m4_1_0(tb_in1,tb_in2,tb_in3,tb_in4,tb_sel,tb_out);
//initial 
//begin
//tb_in1=16'b1010101010101111;
//tb_in2=16'b1111111100000000;
//tb_in3=16'b0000000000000001;
//tb_in4=16'b1010101011111111;
//#10;
//tb_sel=2'b01;
//#10;
//tb_sel=2'b10;
//#10;
//tb_sel=2'b11;
//#10;
//tb_sel=2'b00;
//
//end
//
//
//endmodule