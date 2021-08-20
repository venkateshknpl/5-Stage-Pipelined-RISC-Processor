module LUT(current_pc,write_en,clk,clr,write_data,history,target);

input [15:0] current_pc;//current pc----bits 32 to 17(both inclusive)

input clk,clr,write_en;
input [32:0]write_data;//{current_pc--[32:17];target--[16:1];history[0]}
output [15:0]target;// taken from the target location for that particular pc; ie if at all it jumps then where it is supposed to go
output reg history;
//these two bits should be pipelined

reg [15:0] init_target=16'h0000;

reg [32:0] lut [0:7];//height of lut is taken as 8 
reg [2:0]count=3'b000;//keeps trackof next empty/next write_location location in lut. Increment on this reg is modular 
wire sel;//selector of the mux
integer i,j;
reg [2:0] index; 
reg found=0;
initial//initialising all rows of LUT as 0 
	begin
	for(i=0;i<8;i=i+1)
		begin
		lut[i]<=0;
		end
	end 

assign target=(sel==1'b1)?(current_pc+init_target):(current_pc+16'h0001);
assign sel=(history==1'b1)?1'b1:1'b0;

always@(current_pc)
	begin
	history=1'b0;
	
	for(i=0;i<8;i=i+1)
		begin
		if (current_pc==lut[i][32:17])
			begin
			history=lut[i][0];
			init_target=lut[i][16:1];
			end
		end

	end

always@(posedge clk)
	begin
	if(clr)
		begin
		for(i=0;i<8;i=i+1)
			begin
			lut[i]<=0;//33 bits
			end
		end
	else if (write_en)
		begin
		found=0;
			for(i=0;i<8;i=i+1)
			begin
			if(lut[i][32:17]==write_data[32:17] )
			begin
			found=1;
			lut[i]<=write_data;
			end
			end
			
			if (!found)
				begin
				lut[count]<=write_data;
				count<=count+3'b001;
				end
		end

	end

endmodule
