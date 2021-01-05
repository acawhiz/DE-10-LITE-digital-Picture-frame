`timescale 10ns/1ns 
//https://www.chipverify.com/verilog/verilog-parameters
//https://zipcpu.com/blog/2017/07/29/fifo.html
//https://www.fpga4student.com/2017/01/verilog-code-for-fifo-memory.html

module FIFO1 #(parameter DATA_WIDTH=35,ADDR_WIDTH=32)(
  input clk_wr,clk_rd, rst_n,
  input [DATA_WIDTH-1:0] DataIn,
  output   [DATA_WIDTH-1:0] DataOut,
 (*keep=1*) output empty,
 (*keep=1*)  output full,
  input rden, wren,clear,
  output reg [ADDR_WIDTH-1:0] wrptr,
  output reg [ADDR_WIDTH-1:0] rdptr
	);

	reg [DATA_WIDTH-1:0] fifo_array[(2**ADDR_WIDTH)-1:0];
	reg rden_ack=1'b0;
	reg wren_ack=1'b0;

always@(posedge clk_wr)
begin

	if(!rst_n)
		begin
			wrptr={ADDR_WIDTH{1'b0}};
			
		end
	else if (clear)
		wrptr={ADDR_WIDTH{1'b0}};
	else if (wren & !full & wren_ack ==1'b0) begin //write pointer will only incrment once for every posedge of wren
		fifo_array[wrptr]=DataIn;
		wrptr=wrptr+1'b1;
	end
	
end	

always@(posedge clk_rd)
begin
	if(!rst_n)
		rdptr={ADDR_WIDTH{1'b0}};
	else if (clear)
		rdptr={ADDR_WIDTH{1'b0}};	
	else if (rden & rden_ack ==1'b0 & !empty) //read pointer will only incrment once for every posedge of rden
		rdptr=rdptr+1'b1;

end	

always @(posedge clk_rd) begin
	if (!rden & rden_ack)
		rden_ack = 1'b0;
	else if (rden & !rden_ack)
		rden_ack = 1'b1;
end

always @(posedge clk_wr) begin
	if (!wren & wren_ack)
		wren_ack = 1'b0;
	else if (wren & !wren_ack)
		wren_ack = 1'b1;
end

assign DataOut=fifo_array[rdptr];
assign full = (  ((wrptr +1'b1) == {1'b1,rdptr} )| ((wrptr + 1'b1) == rdptr) )?1'b1:1'b0;
assign empty = (wrptr==rdptr)?1'b1:1'b0;

endmodule