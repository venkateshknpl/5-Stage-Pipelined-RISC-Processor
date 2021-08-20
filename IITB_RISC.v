module IITB_RISC(clk,clr,z_flag_final,c_flag_final,R0,R1,R2,R3,R4,R5,R6,R7);

input clk,clr;
output z_flag_final,c_flag_final;
output [15:0] R0,R1,R2,R3,R4,R5,R6,R7;
wire [15:0] pc_decode,pc_exe,pc_mem,pc_wb,instr_fetch,instr_fetch_mod,instr_decode,instr_decode_mod,instr_exe,instr_mem,instr_wb;
wire [7:0] cw_decode,cw_decode_mod,cw_exe,cw_mem,cw_wb,cw_mem_;
wire [15:0] rb_final_decode,a_ex,ra_final_decode,b_ex,rb_decode_initial,ra_decode_initial,data_final;
wire [15:0] ra_decode,rb_decode,ra_ex,ra_mem;
wire [2:0] dest_decode,dest_ex,dest_mem;
//
wire enable,enable_bar;
//assign enable=freeze1;
wire [5:0] instr_exe_6bits;
//flags in top module;
wire [15:0] alu_output_exe,alu_output_mem,data_wb,data_memout_mem,data_mem,data_from_mod_data_16,data_tomem_mem;//16 bit final result of alu
wire [2:0] dest_address_exe,dest_address_mem,dest_address_wb,dest_address_wb_2,dest_address_final;//destination address for forwarding in execute stage; dest_address_wb_2 is from forwarding ckt, i dont know why, i have two of them, will handle it when i am done ??
wire valid_bit_exe,freeze_1,freeze_2,valid_bit_mem,valid_bit_wb;
wire [127:0] data_112_decode;
wire [3:0] instr_mem_opcode;
integer j;
wire [6:0] immediate_mem;
wire [15:0] address_mem;
wire [2:0] k_mem,k_wb;//source 1 and source 2 to be taken care
wire [1:0] lm_1,lm_2;
//toto
wire [2:0] mno;//select to pc mux
wire A,B;
wire write_en;
wire history_lut,history_dec,history_exe,history_new;//??
wire [32:0] data_lut;

wire [15:0] target;

reg [15:0] InstrMem [0:999];//assume that IM
//assign pcp1=pc_f+16'h0001;
//assign pci6_beq=pc_exe+ {{10{instr_exe[5]}},instr_exe[5:0]};
//assign pci9_jal=pc_decode+ {{7{instr_decode[8]}},instr_decode[8:0]};

assign history_new=(instr_exe[15:12]==4'b1000 && alu_output_exe==16'b0000)?1'b1:1'b0;


wire [15:0] rai9_jri,pc_out,pc_f,pc_jal0,pc_beq01,pc_beq10;//??
assign rai9_jri=ra_decode+{{7{instr_decode[8]}},instr_decode[8:0]};//?
assign pc_jal0=pc_decode+{{7{instr_decode[8]}},instr_decode[8:0]};//?
assign pc_beq01=pc_exe+{{10{instr_exe[5]}},instr_exe[5:0]};//?
assign pc_beq10=pc_exe+16'h0001;//?


assign instr_fetch=InstrMem[pc_f];
assign data_tomem_mem=((instr_mem[15:12]==4'b1101)||(instr_mem[15:12]==4'b1111))?data_from_mod_data_16:ra_mem;
assign dest_address_final=((instr_wb[15:12]==4'b1110)||(instr_wb[15:12]==4'b1100))?k_wb:dest_address_wb_2;
assign data_final=(cw_wb[6]==1'b1)?(pc_wb+16'h0001):data_wb;
assign cw_decode_mod=(B==1'b1)?8'h00:cw_decode;
assign instr_decode_mod=(B==1'b1)?16'h7000:instr_decode;
assign ra_final_decode=(cw_decode[7]==1'b1)?{{10{instr_exe[5]}},instr_decode[5:0]}:ra_decode;
assign instr_mem_opcode=instr_mem[15:12];//essential for k_block
assign immediate_mem=instr_mem[6:0];//essential for k_block
assign instr_exe_6bits={instr_exe[15:12],instr_exe[1:0]};
assign enable=~freeze_1;
assign enable_bar=~(freeze_1|freeze_2);
assign data_mem=(cw_mem[5]==1'b1)?data_memout_mem:alu_output_mem;
assign instr_fetch_mod=((A==1'b1)||(instr_decode[15:12]==4'b1011)||(instr_decode[15:12]==4'b1010))?16'h7000:instr_fetch;//0x7000--->NOP
assign dest_decode=3'b101;//to be removed

assign R0=data_112_decode[15:0];
assign R1=data_112_decode[31:16];
assign R2=data_112_decode[47:32];
assign R3=data_112_decode[63:48];
assign R4=data_112_decode[79:64];
assign R5=data_112_decode[95:80];
assign R6=data_112_decode[111:96];
assign R7=data_112_decode[127:112];
initial begin
        
//        $readmemb("instructions.mif", InstrMem);//lets not forget this
			
//				InstrMem[0]=16'b0011001000000001;-----TESTED
//				InstrMem[1]=16'b0000001010000100;
//				InstrMem[2]=16'b0010001010011000;
//
//			InstrMem[0]=16'b0001001110010000;----Rtype+forwarding--working
//			InstrMem[1]=16'b0001010100101000; 
//			
//InstrMem[0]=16'b0001001110010000;//R2<-7
//InstrMem[0]=16'b0101010110000001;// sw R2, R6, 1( R6=6)----working
				
//				InstrMem[0]=16'b0101010110000001;// sw R2, R6, 1( R6=6)
//				InstrMem[1]= 16'b0001010100101000; // ADD R5, R2, R4 
//				InstrMem[2]=16'b0100110101000001;// lw r6, r5,1  r6 - 2@R6
//				----working

 //InstrMem[0] <=      16'b1111001000000000; // SA R0;R0=0-------------> working
    
//            InstrMem[0] <=      16'b1111001000000000; // SA R0;R0=0  
//				InstrMem[1] <=      16'b1111110000000000; //SA R6 ;R6=6
//            InstrMem[2] <=      16'b1110101000000000; // LA R0
//-------------> working @12:52pm

//BEQ
//InstrMem[0]=16'b0011001000001010;//LHI R1 000001010
//InstrMem[1]=16'b0011010000001010;//LHI r2 000001010
//InstrMem[2]=16'b1000001010000100;//BEQ R1,R2,000100
//InstrMem[3]=16'b0011010000001100;//LHI R2 000001100
//InstrMem[4]=16'b0110000000000000;//NOP
//InstrMem[5]=16'b0110000000000000;//NOP
//InstrMem[6]=16'b0001001010011000; //ADD R1 R2 R3---R3<---R1+R2 //working @13:05
//expected result R3=101000000000

//InstrMem[0]=16'b0011001000001010;
//InstrMem[1]=16'b0011010000001011;//not equal case
//InstrMem[2]=16'b1000001010000100;
//InstrMem[3]=16'b0011010000001100;
//InstrMem[4]=16'b0110000000000000;
//InstrMem[5]=16'b0110000000000000;
//InstrMem[6]=16'b0001001010011000;  //working @13:10

//use of LWI

//InstrMem[0]=16'b0011001111111111;//LWI R1 111111111
//InstrMem[1]=16'b0011010000000001;//LWI R2 111111111
//InstrMem[2]=16'b0001001010011000;//R3<=R2+R1
//InstrMem[3]=16'b0001001011100001;//R4<=R3+R1 if z==1
//working 13:27


//use of JAL
//InstrMem[0]=16'b0011001111111111;//LWI R1 111111111
//InstrMem[1]=16'b0011010000000001;//LWI R2 111111111
//InstrMem[2]=16'b1001100000000010;//JAL R4 2
//InstrMem[3]=16'b0001001010100000;//R4<=R2+R1
//InstrMem[4]=16'b0110001010011000;//NOP
//working 13:39 expected that R4 contains 3


//use of  JLR

//
//InstrMem[0]=16'b1010010011000000;//JLR R2 R3  000000
//InstrMem[1]=16'b0001001010011000;//R3<=R2+R1
//InstrMem[2]=16'b0110001010011000;//NOP
//InstrMem[3]=16'b0001001011100000;//R4<=R3+R1
//working 14:07 expected r4<--4 got it

 //use of  JRI

//
//InstrMem[0]=16'b1011001000000001;//JRI R1 000000001
//InstrMem[1]=16'b0001001100011000;//R3<=R4+R1
//InstrMem[2]=16'b0001010011000000;//R0<=R3+R2
//
//working 14:15 expected r0<= 5 not 8;working


//use of LM
//
//InstrMem[0]=16'b1111000000000000;//SA R0
//InstrMem[1]=16'b1100001000001111;//LM r1 00 0001111
//15:56 working expected results attained

//Testing SM
//SM r0 00 0011001
//InstrMem[0]=16'b1101000000011001;//2 3 and 6 in memory 16:01
//

//demostrating the beq---a larger program
//expected to see memory location(0,1,2,3,4,5,6,7,8,9) to have values like 0,2,4,6,8,10,12,14,16,18
//InstrMem[0]=16'b0011100000000000;//LHI R4 000000000     R4<--0
//InstrMem[1]=16'b0000100110001010;//ADI R4,R6,001010     R6<----R4+10
//InstrMem[2]=16'b0011001000000000;//LHI R1 000000000     R1<--0
//InstrMem[3]=16'b0011010000000000;//LHI R2 000000000     R2<--0
//InstrMem[4]=16'b0011000000000000;//LHI R0 000000000     R0<--0
//InstrMem[5]=16'b0001001010011000;//ADD R1 R2 R3         R3<--R1+R2
//InstrMem[6]=16'b0101011100000000;//SW R3 R4(0)          TARGET<---R4+0   MEM[TARGET]<----R3
//InstrMem[7]=16'b0000100101000001;//ADDI R4 R5 1         R5<--R4+1
//InstrMem[8]=16'b0000101100000000;//ADDI R5 R4 0         R4<--R5+0
//InstrMem[9]=16'b0000001101000001;//ADDI R1 R5 1         R5<--R1+1
//InstrMem[10]=16'b0000101001000000;//ADDI R5 R1 0         R1<--R5+0
//InstrMem[11]=16'b0000010101000001;//ADDI R2 R5 1         R5<--R2+1
//InstrMem[12]=16'b0000101010000000;//ADDI R5 R2 0         R2<--R5+0
//InstrMem[13]=16'b1000110100000010;//BEQ R6 R4 2        JUMP TO PC+2 IF R6==R4 ELSE PC+1
//InstrMem[14]=16'b1011000000000101;//JRI R0 5				JUMP TO R0+5 
//InstrMem[15]=16'b1011000000001111;//JRI R0 15				JUMP TO R0+15 

//working--22:43 


//To see if -ve values of immediate allowed while branching
//InstrMem[0]=16'b0011000000000000;//LHI R0 000000000     R0<--0
//InstrMem[1]=16'b0000000001001010;//ADI R0,R1,001010     R1<----R0+10
//InstrMem[2]=16'b1000000001000100;//BEQ R0,R1,4    		JUMP TO PC+4 IF R1==R0 ELSE PC+1
//InstrMem[3]=16'b0000001101111111;//ADI R1,R5,111111    R5<----R1-1
//InstrMem[4]=16'b0000101001000000;//ADI R5,R1,000000    R1<----R5
//InstrMem[5]=16'b1001100111111101;//JAL R4 -3           PC_new<--PC_old+-3 and R4<--PC_old+1
//InstrMem[6]=16'b1001100000000000;//JAL R4 0          PC_new<--PC_old and R4<--PC_old+1
////working--results in R1 being 0 #note oscillation in R7


//instruction that uses carryflag and zeroflag
//
//InstrMem[0]=16'b0011100000000001;//LHI R4 000000001    R4<--b10000000
//InstrMem[1]=16'b0011000000000000;//LHI R0 000000000     R0<--0
//InstrMem[2]=16'b0000000001000101;//ADI R0,R1,000101    R1<----R0+5=5
//InstrMem[3]=16'b0000000010000001;//ADI R0,R2,000001    R2<----R0+1=1
//InstrMem[4]=16'b0000000011111111;//ADI R0,R3,-1    R3<----R0-1=-1
//InstrMem[5]=16'b0001010011100010;//ADC R2,R3,R4    if c==1 then R4<----R2+R3
//InstrMem[6]=16'b0001010011100000;//ADD R2 R3 R4         R4<--R3+R2//sets zero flag when this instr is at execute stage
//InstrMem[7]=16'b0001010100000001;//ADZ R2,R4,R0   if z==0 then R0<----R4+R2

//Done R0=1 00:59----done2

//NANDs
//InstrMem[0]=16'b0010000001011000;//NDU R0,R1,R3
//InstrMem[1]=16'b0010000001100000;//NDU R0,R1,R4
//InstrMem[2]=16'b0010100011101000;//NDU R4,R3,R5
//InstrMem[3]=16'b0010101000010001;//NDZ R5,R0,R2
//InstrMem[4]=16'b0001010001011000;//ADD R2,R1,R3   
//InstrMem[5]=16'b0010011010001010;//NDC R3,R2,R1   
//1:48 correct ,r1=FFFF

//multiply two numbers stored at mem locations 128 and 129 ;store the result in 130
//uses dependencies of load, load & store instructions
//InstrMem[0]=16'b0011000000000000;//LHI R0 000000000      ;R0<=0
//InstrMem[1]=16'b0011011000000000;//LHI R3 000000000      ;R3<=0
//InstrMem[2]=16'b0011010000000001;//LHI R2 000000001      ;R2<=0128
//InstrMem[3]=16'b0100100010000001;//LW R4 R2(000001)      ;R4<===MEM[R2+1]
//InstrMem[4]=16'b0100001010000000;//LW R1 R2(000000)      ;R1<===MEM[R2]z
//InstrMem[5]=16'b0001000001101000;//ADD R0 R1 R5          ;R5<===R1+R0
//InstrMem[6]=16'b0000101000000000;//ADI R5 R0 000000      ;R0<===R5+0
//InstrMem[7]=16'b0000100110111111;//ADI R4 R6 -1         ;R6<=== -1+R4
//InstrMem[8]=16'b0000110100000000;//ADI R6 R4 -1         ;R4<=== R6
//InstrMem[9]=16'b1000100011000010;//BEQ R4 R3 2         ;JUMP TO PC+2 IF R3==R4 ELSE PC+1
//InstrMem[10]=16'b1001110111111011;//JAL R6 -5         ;JUMP TO PC-5 AND  STORE PC+1 IN R6
//InstrMem[11]=16'b0101101010000010;//SW R5 R2 2         ;MEM[R2+2]<==R5
//InstrMem[12]=16'b1001110000000000;//JAL R6 0         ;JUMP TO PC AND  STORE PC+1 IN R6

//working -with branch prediction
//mem location 128 and 129 contains 21 and 10 respectively ,after computation the result is stored in 129 
//12:47  


//demonstrating the use of SA and LA -with dependencies

//InstrMem[0]=16'b1110000000000000;//LW R0 000000000      ;load contents from mem location starting from  address=[R0]
//InstrMem[1]=16'b0001001010000000;//ADD R1 R2 R0         ;R0<=R1+R2
//InstrMem[2]=16'b0001011100001000;//ADD R3 R4 R1         ;R1<=R3+R4
//InstrMem[3]=16'b0001101110010000;//ADD R5 R6 R2        ;R2<=R5+R6
//InstrMem[4]=16'b0001000001011000;//ADD R0 R1 R3       ;R3<=R1+R0
//InstrMem[5]=16'b0001010011100000;//ADD R2 R3 R4       ;R4<=R3+R2
//InstrMem[6]=16'b0000100000000000;//ADI R4 R0 000000      ;R0<===R4+0
//InstrMem[7]=16'b0000100001000000;//ADI R4 R1 000000      ;R1<===R4+0
//InstrMem[8]=16'b0000100010000000;//ADI R4 R2 000000      ;R2<===R4+0
//InstrMem[9]=16'b0000100011000000;//ADI R4 R3 000000      ;R3<===R4+0
//InstrMem[10]=16'b0000100101000000;//ADI R4 R5 000000      ;R5<===R4+0
//InstrMem[11]=16'b0000100110000000;//ADI R4 R6 000000      ;R0<===R4+0
//InstrMem[12]=16'b1111000000000000;//SA R0    ;STORE CONTENT OF ALL REGISTERS IN MEM AT ADDRESS STARTING FROMM [R0]
//InstrMem[13]=16'b1001110000000000;//JAL R6 0         ;JUMP TO PC AND  STORE PC+1 IN R6
//working -result-7mem  locations starting from 42 will hold 42  14:25

//demonstrating the use of SM and LM -with dependencies

InstrMem[0]=16'b1100000001010101;//LM R0 001010101      ;
InstrMem[1]=16'b0001001010000000;//ADD R1 R2 R0         ;R0<=R1+R2
InstrMem[2]=16'b0001011100001000;//ADD R3 R4 R1         ;R1<=R3+R4
InstrMem[3]=16'b0001101110010000;//ADD R5 R6 R2        ;R2<=R5+R6
InstrMem[4]=16'b0001000001011000;//ADD R0 R1 R3       ;R3<=R1+R0
InstrMem[5]=16'b0001010011100000;//ADD R2 R3 R4       ;R4<=R3+R2
InstrMem[6]=16'b0000100000000000;//ADI R4 R0 000000      ;R0<===R4+0
InstrMem[7]=16'b0000100001000000;//ADI R4 R1 000000      ;R1<===R4+0
InstrMem[8]=16'b0000100010000000;//ADI R4 R2 000000      ;R2<===R4+0
InstrMem[9]=16'b0000100011000000;//ADI R4 R3 000000      ;R3<===R4+0
InstrMem[10]=16'b0000100101000000;//ADI R4 R5 000000      ;R5<===R4+0
InstrMem[11]=16'b0000100110000000;//ADI R4 R6 000000      ;R0<===R4+0
InstrMem[12]=16'b1101000001010101;//SM R0    001010101
InstrMem[13]=16'b1001110000000000;//JAL R6 0         ;JUMP TO PC AND  STORE PC+1 IN R6
//working -14:38 mem location starting from 21 will hold 21 (4 of them)
   end

alu ALU0(.A_in(a_ex),.B_in(b_ex),.instr_exe_6bit(instr_exe_6bits),.z_bit(z_flag_final),.c_bit(c_flag_final),.alu_out(alu_output_exe));
c_block C_EXE(.instruction_x(instr_exe),.dest_address(dest_address_exe),.valid_bit(valid_bit_exe));
reg_e2m Reg3(.clk(clk),.enable(enable),.clr(clr),.pc_exe_16(pc_exe),.instr_exe_16(instr_exe),.cw_exe_8(cw_exe),.in_exe_16(alu_output_exe),.ra_exe_16(ra_ex),.dest_exe_3(dest_ex),.pc_mem_16(pc_mem),.instr_mem_16(instr_mem),.cw_mem_8(cw_mem),.in_mem_16(alu_output_mem),.ra_mem_16(ra_mem),.dest_mem_3(dest_mem));

 k_block_address_mux K0(.instr_mem_4(instr_mem[15:12]),.immediate_7(immediate_mem),.clk(clk),.data_from_exe_16(alu_output_mem),.address_16(address_mem),.k(k_mem));
freeze F0(.instr_mem_4(instr_mem[15:12]),.k_mem_3(k_mem),.freeze1(freeze_1),.source1_dec_address_3(instr_decode[8:6]),.source2_dec_address_3(instr_decode[11:9]),.dest_exe_address_3(dest_address_exe),.cw_exe_bit5(cw_exe[5]),.freeze2(freeze_2),.instr_exe(instr_exe[15:12]));
c_block_mem C_MEM(.instruction_x(instr_mem),.dest_address(dest_address_mem),.k_mem(k_mem),.valid_bit(valid_bit_mem));

mod_data DM0(.raw_data_112(data_112_decode[111:0]),.dest_address_wb(dest_address_wb_2),.data_wb(data_wb),.k_mem(k_mem),.data_out_16(data_from_mod_data_16));
memory M0(.address(address_mem),.write_data(data_tomem_mem),.write_en(cw_mem[1]),.data_out(data_memout_mem),.clk(clk));

reg_m2w Reg4(.clk(clk),.enable(1'b1),.clr(clr),.pc_mem_16(pc_mem),.instr_mem_16(instr_mem),.cw_mem_8(cw_mem_),.in_mem_16(data_mem),.k_mem_3(k_mem),.dest_mem_3(dest_mem),.pc_wb_16(pc_wb),.instr_wb_16(instr_wb),.cw_wb_8(cw_wb),.in_wb_16(data_wb),.k_wb_3(k_wb),.dest_wb_3(dest_address_wb));
c_block C_WB(.instruction_x(instr_wb),.dest_address(dest_address_wb_2),.valid_bit(valid_bit_wb));
s_block SB0(.cw_mem_before_sblock(cw_mem),.cw_mem_after_sblock(cw_mem_),.instr_mem(instr_mem),.k_mem(k_mem));
//toto
//wire [15:0] rai9_jri,pc_out,pc_f,pc_jal0,pc_beq01,pcbeq10;//??
//assign rai9_jri=ra_decode+{{7{instr_decode[8]}},instr_decode[8:0]};//?
//assign pc_jal0=pc_decode+{{7{instr_decode[8]}},instr_decode[8:0]};//?
//assign pc_beq01=pc_exe+{{10{instr_exe[5]}},instr_exe[5:0]};//?
//assign pc_beq10=pc_exe+16'h0001;//?
LUT L0(.current_pc(pc_f),.write_en(write_en),.clk(clk),.clr(clr),.write_data(data_lut),.history(history_lut),.target(target));

mux_pc PC_MUX(.next_pc_normal(target),.next_pc_jri(rai9_jri),.next_pc_jlr(rb_decode),.next_pc_jal0(pc_jal0),.next_pc_beq01(pc_beq01),.next_pc_beq10(pc_beq10),.mno(mno),.pc_out(pc_out));
branch_controller bc0(.instr_exe(instr_exe),.instr_decode(instr_decode),.pc_decode(pc_decode),.pc_exe(pc_exe),.history_exe(history_exe),.history_decode(history_dec),.new_history(history_new),.mno(mno),.A(A),.B(B),.write_en(write_en),.write_data(data_lut));//removed alu_out

reg_pc Reg0(.clk(clk),.enable(enable_bar),.clr(clr),.pc_in_16(pc_out),.pc_out_16(pc_f));
reg_f2d Reg1(.clk(clk),.enable(enable_bar),.clr(clr),.instr_f_16(instr_fetch_mod),.pc_f_16(pc_f),.instr_d_16(instr_decode),.pc_d_16(pc_decode),.history_in(history_lut),.history_out(history_dec));//modified
reg_d2e Reg2(.clk(clk),.enable(enable),.clr(clr),.pc_dec_16(pc_decode),.instr_dec_16(instr_decode_mod),.cw_dec_8(cw_decode_mod),.in1_dec_16(rb_final_decode),.in2_dec_16(ra_final_decode),.ra_dec_16(ra_decode),.dest_dec_3(dest_decode),.pc_exe_16(pc_exe),.instr_exe_16(instr_exe),.cw_exe_8(cw_exe),.in1_exe_16(a_ex),.in2_exe_16(b_ex),.ra_exe_16(ra_ex),.dest_exe_3(dest_ex),.history_in(history_dec),.history_out(history_exe));

register_file  RF0(.read_address_1(instr_decode[8:6]),.read_address_2(instr_decode[11:9]),.write_en(cw_wb[0]),.write_address(dest_address_final),.write_data(data_final),.current_pc(pc_decode),.clk(clk),.data_1(rb_decode_initial),.data_2(ra_decode_initial),.data_112(data_112_decode));// look at the outputs
controller CON0 (.instr_decode_4(instr_decode[15:12]),.cw_decode_8(cw_decode));
address_comp AC0(.source_address(instr_decode[8:6]),.dest_address_exe(dest_address_exe),.dest_address_mem(dest_address_mem),.dest_address_wb(dest_address_wb_2),.v_exe(valid_bit_exe),.v_mem(valid_bit_mem),.v_wb(valid_bit_wb),.lm(lm_1));
address_comp AC1(.source_address(instr_decode[11:9]),.dest_address_exe(dest_address_exe),.dest_address_mem(dest_address_mem),.dest_address_wb(dest_address_wb_2),.v_exe(valid_bit_exe),.v_mem(valid_bit_mem),.v_wb(valid_bit_wb),.lm(lm_2));
mux_4to1 MUX0(.in1(rb_decode_initial),.in2(alu_output_exe),.in3(data_mem),.in4(data_final),.sel(lm_1),.out(rb_decode));
mux_4to1 MUX1(.in1(ra_decode_initial),.in2(alu_output_exe),.in3(data_mem),.in4(data_final),.sel(lm_2),.out(ra_decode));

mux_4to1 MUX_rb(.in1(rb_decode),.in2({instr_decode[8:0],7'b0000000}),.in3({{10{instr_decode[5]}},instr_decode[5:0]}),.in4(rb_decode),.sel({cw_decode[2],cw_decode[3]}),.out(rb_final_decode));

	
//NOPS should also be modified

endmodule


`timescale 1 ns / 1 ps
	module tb_IITB_RISC;
	
	reg tb_clk,tb_clr;
	wire tb_z_flag_final,tb_c_flag_final;
	wire [15:0] tb_R0,tb_R1,tb_R2,tb_R3,tb_R4,tb_R5,tb_R6,tb_R7;
	 IITB_RISC mm (tb_clk,tb_clr,tb_z_flag_final,tb_c_flag_final,tb_R0,tb_R1,tb_R2,tb_R3,tb_R4,tb_R5,tb_R6,tb_R7);
	 

	initial
	begin
	tb_clk=1'b0;
	tb_clr=1'b1;
	#25;
	tb_clr=1'b0;

	end
	
	always
	begin
	#10;
	tb_clk<=~tb_clk;
	end
	endmodule
			