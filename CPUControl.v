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

endmodule