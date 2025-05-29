`ifndef PARAM
	`include "Parametros.v"
`endif

module ALUControl(
	input  logic [5:0]  iALUOp,
	input  logic [31:0] iInstruction,
	output logic [4:0]  oControl
);

endmodule