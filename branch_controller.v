//mno is 3 bits selector that will select any of the 5 instruction addresses.

module branch_controller(instr_exe,instr_decode,pc_decode,pc_exe,history_exe,history_decode,new_history,mno,A,B,write_en,write_data);//removed alu_out
	input [15:0] instr_exe,instr_decode,pc_exe,pc_decode;
	input history_exe,new_history,history_decode;
	output reg [2:0] mno;
	output reg A,B,write_en;
	output reg [32:0] write_data;
	always @(instr_exe,instr_decode,history_exe,new_history,history_decode,pc_exe,pc_decode)
	
		begin
			if (instr_decode[15:12]==4'b1011)//JRI
				begin
				mno=3'b001;
				A=0;
				write_en=0;
				write_data=0;
				B=0;
				end
		
			else if (instr_decode[15:12]==4'b1010)//JLR
				begin
				mno=3'b010;
				A=0;
				write_en=0;
				write_data=0;
				B=0;
				end
			else if (instr_decode[15:12]==4'b1001 && history_decode==1'b0)//JAL and not in LUT
				begin
				mno=3'b011;//A and B
				A=1;
				write_en=1;
				write_data={pc_decode,{{7{instr_decode[8]}},instr_decode[8:0]},1'b1};
				B=0;
				end
			else if (instr_exe[15:12]==4'b1000 && history_exe==1'b0 && new_history==1'b1)//BEQ and new_hist=1 and old_hist=0
				begin
				mno=3'b100;
				A=1;
				write_en=1;
				write_data={pc_exe,{{10{instr_exe[5]}},instr_exe[5:0]},new_history};
				B=1;
				end
				
			else if (instr_exe[15:12]==4'b1000 && history_exe==1'b1 && new_history==1'b0)//BEQ and new_hist=0 and old_hist=1
				begin
				mno=3'b101;
				A=1;
				write_en=1;
				write_data={pc_exe,{{10{instr_exe[5]}},instr_exe[5:0]},new_history};
				B=1;
				end
			else
				begin
				mno=3'b000;
				A=0;
				write_en=0;
				write_data=0;
				B=0;
				end
			

		end
	endmodule
	
	
//working
//`timescale 1 ns/1 ps
//module tb_branch_controller;
//
//	reg [3:0] tb_instr_exe_4,tb_instr_decode_4;
//	reg [15:0] tb_alu_out;
//	wire [2:0] tb_mno;
//	branch_controller bc0(tb_instr_exe_4,tb_instr_decode_4,tb_alu_out,tb_mno);
//initial 
//begin
//tb_instr_exe_4=4'b1000;
//tb_instr_decode_4=4'b1001;
//tb_alu_out=16'b1000000011111111;
//#20;
//tb_instr_exe_4=4'b1000;
//tb_instr_decode_4=4'b1001;
//tb_alu_out=16'b0000000000000000;
//#20;
//tb_instr_exe_4=4'b1010;
//tb_instr_decode_4=4'b1011;
//tb_alu_out=16'b0000000000000000;
//#20;
//tb_instr_exe_4=4'b0011;
//tb_instr_decode_4=4'b0010;
//tb_alu_out=16'b0000000000000000;
//#20;
//end
//
//
//endmodule