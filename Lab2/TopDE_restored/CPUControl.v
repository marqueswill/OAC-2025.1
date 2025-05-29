module CPUControl(
	input  [5:0] iOpcode,
	output 		 oRegDst,
	output 		 oALUSrc,
	output 		 oMemtoReg,
	output 		 oRegWrite,
	output 		 oMemRead,
	output 		 oMemWrite,
	output 		 oBranch,
	output [1:0] oALUOp
);

wire [8:0] outputs;

assign oRegDst   = outputs[8];
assign oALUSrc   = outputs[7];
assign oMemtoReg = outputs[6];
assign oRegWrite = outputs[5];
assign oMemRead  = outputs[4];
assign oMemWrite = outputs[3];
assign oBranch   = outputs[2];
assign oALUOp    = outputs[1:0];


always @(*) begin
	casex (iOpcode)
		6'b0: outputs <= 9'b0;
		6'b0: outputs <= 9'b0;
		6'b0: outputs <= 9'b0;
		6'b0110011: outputs <= 9'b100100010;
		default: outputs <= ZERO;
	endcase
end

endmodule