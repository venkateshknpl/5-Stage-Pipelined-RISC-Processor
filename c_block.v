//c_block helps to determine the destination of the current instruction-instruction_x.Apart from destination register address(3 bits), it also gives a valid bit
module c_block(instruction_x,dest_address,valid_bit);
input [15:0] instruction_x;
output [2:0] dest_address;
output  valid_bit;
reg [2:0] temp=3'b000;
reg temp_bit=1'b0;
assign dest_address=temp;
assign valid_bit=temp_bit;
always@(instruction_x)
begin
if(instruction_x[15:12]==4'b0001 || instruction_x[15:12]==4'b0010)//ADD or NAND
	begin
	temp=instruction_x[5:3];//@RC
	temp_bit=1'b1;
	end
else if(instruction_x[15:12]==4'b0000)//ADI
	begin
	temp=instruction_x[8:6];//@RB
	temp_bit=1'b1;
	end
else if((instruction_x[15:12]==4'b0011)||(instruction_x[15:12]==4'b1001)||(instruction_x[15:12]==4'b1010)/*||(instruction_x[15:12]==4'b0100)*/)//LWI,JAL,JLR,LW
	begin
	temp=instruction_x[11:9];//@RA
	temp_bit=1'b1;
	end
	
	//THIS IS FOR C_BLOCK IN MEM STAGE
//else if(instruction_x[15:12]==4'b1110 ||instruction_x[15:12]==4'b1100)//LA or LM
//	begin
//	temp=k_m;
//	temp_bit=1'b1;
//	end
 else
	begin
	temp=instruction_x[11:9];//Dont care about this as temp_bit is 0
	temp_bit=1'b0;
	end
end
endmodule
//TEST BENCH-working

`timescale 1 ns/1 ps
module tb_c_block;

reg [15:0] tb_instruction;
wire [2:0] tb_dest_address;
wire tb_valid_bit;

c_block c4(tb_instruction,tb_dest_address,tb_valid_bit);
initial 
begin
#5;
tb_instruction=16'b0001101110001001;
#10;
tb_instruction=16'b0010101110001001;
#10;
tb_instruction=16'b0000101110001001;
#10;
tb_instruction=16'b0011101110001001;
#10;
tb_instruction=16'b1001101110001001;
#10

tb_instruction=16'b1010101110001001;
#10

tb_instruction=16'b1000101110001001;
#10

tb_instruction=16'b0100101110001001;

end
endmodule
