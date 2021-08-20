//Register file
//current_pc is the pc of the instruction in decode stage.
//its hardwired to R7
//current_pc is t the pc from fetch stage
module register_file(read_address_1,read_address_2,write_en,write_address,write_data,current_pc,clk,data_1,data_2,data_112);
input [2:0] read_address_1,read_address_2,write_address;
output wire [15:0] data_1,data_2;
output wire [127:0] data_112;//modified it to 8 reg
input write_en,clk;
input [15:0] write_data,current_pc;
//create register file
reg [15:0] RF [0:6];//there are 8 register and all are 16 bit wide
integer i;
reg [15:0] R7;
initial
begin
	for (i=0;i<7;i=i+1)
	begin
		RF[i]=i;
		end
	
end

assign  data_1=(read_address_1!=3'b111)?RF[read_address_1]:R7;
assign  data_2=(read_address_2!=3'b111)?RF[read_address_2]:R7;
assign data_112={R7,RF[6],RF[5],RF[4],RF[3],RF[2],RF[1],RF[0]};
always@(current_pc)
R7=current_pc;
always@(posedge clk)
	begin
		
		if(write_en==1'b1 && write_address!=3'b111)
			RF[write_address]<=write_data;
			
	end
endmodule

//Test_bench-working
//`timescale 1 ns/1 ps
//module tb_register_file;
//reg [2:0] tb_read_address_1,tb_read_address_2,tb_write_address;
//wire [15:0] tb_data_1,tb_data_2;
//wire [111:0] tb_data_112;
//reg tb_write_en,tb_clk;
//reg [15:0] tb_write_data,tb_current_pc;
//
//register_file R1(tb_read_address_1,tb_read_address_2,tb_write_en,tb_write_address,tb_write_data,tb_current_pc,tb_clk,tb_data_1,tb_data_2,tb_data_112);
//
//initial 
//begin
//tb_clk=1'b0;
//tb_read_address_1=3'b001;
//tb_read_address_2=3'b000;
//tb_current_pc=16'h1000;
//#15;
//tb_write_en=1'b1;
//tb_write_data=16'h43f6;
//tb_write_address=3'b100;
//#20;
//tb_write_en=1'b1;
//tb_write_data=16'hffef;
//tb_write_address=3'b101;
//#20;
//tb_write_en=1'b1;
//tb_write_data=16'h0111;
//tb_write_address=3'b011;
//#20;
//tb_write_en=1'b0;
//tb_write_data=16'haaaa;
//tb_write_address=3'b010;
//#20;
//tb_write_en=1'b1;
//tb_write_data=16'h0111;
//tb_write_address=3'b011;
//tb_current_pc=16'h1010;
//
//#20;
//tb_write_en=1'b1;
//tb_write_data=16'h0101;
//tb_write_address=3'b001;
//tb_read_address_1=3'b011;
//tb_read_address_2=3'b111;
//#20;
//tb_write_en=1'b0;
//tb_write_data=16'habce;
//tb_write_address=3'b000;
//
//#20;
//tb_write_en=1'b1;
//tb_write_data=16'habcf;
//tb_write_address=3'b000;
//
//end
//
//always
//begin
//#10;
//tb_clk<=~tb_clk;
//end
//
//
//endmodule
