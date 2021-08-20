//mno is 3 bits selector that will select any of the 5 instruction addresses.
module mux_pc(next_pc_normal,next_pc_jri,next_pc_jlr,next_pc_jal0,next_pc_beq01,next_pc_beq10,mno,pc_out);
	input [15:0] next_pc_normal,next_pc_jri,next_pc_jlr,next_pc_jal0,next_pc_beq01,next_pc_beq10;
	input [2:0] mno;
	output  reg [15:0] pc_out;
	always @(next_pc_normal,next_pc_jri,next_pc_jlr,mno,next_pc_jal0,next_pc_beq01,next_pc_beq10,mno)
		begin
			case(mno)

				3'b000: pc_out=next_pc_normal;
				3'b001: pc_out=next_pc_jri;
				3'b010: pc_out=next_pc_jlr;
				3'b011: pc_out=next_pc_jal0;
				3'b100: pc_out=next_pc_beq01;
				3'b101: pc_out=next_pc_beq10;
				
				default:pc_out=next_pc_normal;
			endcase
				

		end
	endmodule
//test_bench	
//working
//`timescale 1 ns/1 ps
//module tb_mux_pc;
//
//	reg [15:0] tb_next_pc_normal,tb_next_pc_beq,tb_next_pc_jri,tb_next_pc_jal,tb_next_pc_jlr;
//	reg [2:0] tb_mno;
//	wire [15:0] tb_pc_out;
//	mux_pc mpc0(tb_next_pc_normal,tb_next_pc_beq,tb_next_pc_jri,tb_next_pc_jal,tb_next_pc_jlr,tb_mno,tb_pc_out);
//initial 
//begin
//tb_next_pc_normal=16'h1234;
//tb_next_pc_beq=16'h2525;
//tb_next_pc_jri=16'hffef;
//tb_next_pc_jal=16'h1254;
//tb_next_pc_jlr=16'h2400;
//tb_mno=3'b000;
//#10;
//tb_mno=3'b001;
//#10;
//tb_mno=3'b011;
//#10;
//tb_mno=3'b010;
//#10;
//tb_mno=3'b100;
//#10;
//tb_mno=3'b101;
//#10;
//tb_mno=3'b110;
//#10;
//tb_mno=3'b111;
//#10;
//end
//
//
//endmodule