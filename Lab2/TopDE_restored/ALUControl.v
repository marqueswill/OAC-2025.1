`ifndef PARAM
	`include "Parametros.v"
`endif

module ALUControl(
	input  logic [5:0]  iALUOp,
	input  logic [31:0] iInstruction,
	output logic [4:0]  oControl
);

wire [6:0] FUNCT7;
wire [2:0] FUNCT3;

assign FUNCT7 = iInstruction[31:25];
assign FUNCT3 = iInstruction[14:12];

always @(*) begin
	case (iALUOp)
		2'b00: oControl <= OPADD;
		2'b01: oControl <= OPSUB;
		2'b10: 
			casex ({FUNCT7, FUNCT3})
				FUNADD:  oControl <= OPADD;
				FUNSLT:  oControl <= OPSLT;
				FUNOR:   oControl <= OPOR;
				FUNAND:  oControl <= OPAND;
				FUNSUB:  oControl <= OPSUB;
				default: oControl <= ZERO;
			endcase
		
		default: oControl <= ZERO;
	endcase
end


endmodule