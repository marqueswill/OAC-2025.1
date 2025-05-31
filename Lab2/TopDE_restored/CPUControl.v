`ifndef PARAM
	`include "Parametros.v"
`endif

module CPUControl(
	input  [31:0] iInstruction,
	output 		  oRegDst,
	output 		  oALUSrc,
	output 		  oMemtoReg,
	output 		  oRegWrite,
	output 		  oMemRead,
	output 		  oMemWrite,
	output 		  oBranch,
	output 		  oJalr,
	output 		  oJal,
	output [1:0]  oALUOp
);

endmodule