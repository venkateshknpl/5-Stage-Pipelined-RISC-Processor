//instr_exe_6bits----->{instr[15:12],instr[1:0]} will decide what operation
//that the ALU will do.
//input
module alu(A_in,B_in,instr_exe_6bit,z_bit,c_bit,alu_out);
	input [15:0] A_in,B_in;
	input [5:0] instr_exe_6bit;
	output z_bit,c_bit;
	
	output [15:0] alu_out;
	reg zero_flag=0;
	reg carry_flag=0;
	reg [16:0]out=0;
	reg c=0;
	reg z=0;
	assign alu_out=out[15:0];
	assign c_bit=c;
	assign z_bit=z;
	always@(zero_flag,carry_flag,out)
		begin
		
			
		if(zero_flag)
			z=~(|out[15:0]);
		if(carry_flag)
			c=out[16];
	
		end
	always@(instr_exe_6bit,A_in,B_in,c,z)
		begin
			if (instr_exe_6bit[5:2]==4'b0001 )//ADD
				begin
					if (instr_exe_6bit[1:0]==2'b00 )
						begin
							out={1'b0,A_in}+{1'b0,B_in};
							zero_flag=1;
							carry_flag=1;
						end
					else if (instr_exe_6bit[1:0]==2'b01 )
						begin
							if (z)
								begin	
									out={1'b0,A_in}+{1'b0,B_in};
									zero_flag=1;
									carry_flag=1;
								end
							else
								begin
									zero_flag=0;
									carry_flag=0;
								end
						end
					else if (instr_exe_6bit[1:0]==2'b10 )
						begin
							if (c)
								begin	
									out={1'b0,A_in}+{1'b0,B_in};
									zero_flag=1;
									carry_flag=1;
								end
							else
								begin
									zero_flag=0;
									carry_flag=0;
								end
						end
					else if (instr_exe_6bit[1:0]==2'b11)
						begin
							
							out={1'b0,A_in}+{B_in,1'b0};
							zero_flag=1;
							carry_flag=1;
						end
				end
			else if (instr_exe_6bit[5:2]==4'b0010 )//NAND
				begin
					if (instr_exe_6bit[1:0]==2'b00 )
						begin
							out=~({1'b0,A_in}&{1'b0,B_in});
							zero_flag=1;
							carry_flag=0;
						end
					else if (instr_exe_6bit[1:0]==2'b01 )
						begin
							if (z)
								begin	
									out=~({1'b0,A_in}&{1'b0,B_in});
									zero_flag=1;
									carry_flag=0;
								end
							else
								begin
									zero_flag=0;
									carry_flag=0;
								end
						end
					else if (instr_exe_6bit[1:0]==2'b10 )
						begin
							if (c)
								begin	
									out=~({1'b0,A_in}&{1'b0,B_in});
									zero_flag=1;
									carry_flag=0;
								end
							else
								begin
									zero_flag=0;
									carry_flag=0;
								end
						end
					
				end
			else if (instr_exe_6bit[5:2]==4'b0011)//LWI
				begin
					out={1'b0,A_in};
					zero_flag=0;
					carry_flag=0;
					
				end
			else if (instr_exe_6bit[5:2]==4'b1000)//BEQ 
				begin
					out={1'b0,A_in} ^ {1'b0,B_in};//gives zero when both are equal else some value
					zero_flag=0;
					carry_flag=0;
					
				end
			else if ((instr_exe_6bit[5:2]==4'b0100) || (instr_exe_6bit[5:2]==4'b0101))//LW  or SW
				begin
					out={1'b0,A_in} +{1'b0,B_in};
					zero_flag=0;
					carry_flag=0;
					
				end
			else if ((instr_exe_6bit[5:2]==4'b1110)||(instr_exe_6bit[5:2]==4'b1111)||(instr_exe_6bit[5:2]==4'b1100)||(instr_exe_6bit[5:2]==4'b1101))//LA or SA or LM or SM
				begin
					out={1'b0,B_in};
					zero_flag=0;
					carry_flag=0;
					
				end
				
			else if (instr_exe_6bit[5:2]==4'b0000)//ADI
				begin
					out={1'b0,B_in}+{1'b0,A_in};
					zero_flag=1;
					carry_flag=1;
					
				end
			else//Any other combination, it does nothing specific and flags wont be modified 
				begin
					out=16'h0001;
					zero_flag=0;
					carry_flag=0;
				end
			end
		endmodule
		//TESTBENCH-ALU--working
//		`timescale 1 ns / 1 ps
//		module tb_alu;
//	reg [15:0] tb_A_in,tb_B_in;
//	reg [5:0] tb_instr_exe_6bit;
//	wire tb_z_bit,tb_c_bit;
//	wire [15:0] tb_alu_out;
//	alu c0 (tb_A_in,tb_B_in,tb_instr_exe_6bit,tb_z_bit,tb_c_bit,tb_alu_out);
//	initial
//	begin
//	#20;
//	tb_A_in=16'b1111111100000000;
//tb_B_in=16'b0000000100000000;
//	#10;
//	tb_instr_exe_6bit=6'b000100;
//	#10;
//	tb_instr_exe_6bit=6'b000101;
//	#10;
//	tb_instr_exe_6bit=6'b000110;
//	#10;
//	tb_instr_exe_6bit=6'b000111;
//	#10;
//	tb_instr_exe_6bit=6'b001000;
//	#10;
//	tb_instr_exe_6bit=6'b001001;
//	#10;
//	tb_instr_exe_6bit=6'b001010;
//	#10;
//	tb_instr_exe_6bit=6'b000000;
//	#10;
//	tb_instr_exe_6bit=6'b001100;
//	#10;
//	tb_instr_exe_6bit=6'b001000;
//	#10;
//	tb_instr_exe_6bit=6'b100100;
//	#10;
//	tb_instr_exe_6bit=6'b101100;
//	#10;
//	tb_instr_exe_6bit=6'b101000;
//	#10;
//	tb_instr_exe_6bit=6'b100000;
//	#10;
//	tb_instr_exe_6bit=6'b010100;
//	#10;
//	tb_instr_exe_6bit=6'b010000;
//	#10;
//	tb_instr_exe_6bit=6'b111000;
//	#10;
//	tb_instr_exe_6bit=6'b111100;
//	#10;
//	tb_instr_exe_6bit=6'b011100;
//	#10;
//	tb_instr_exe_6bit=6'b001010;
//
//	end
//	endmodule
			