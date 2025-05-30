`ifndef PARAM
	`include "Parametros.v"
`endif

module ALUControl(
	input  logic [1:0]  iALUOp,
	input  logic [31:0] iInstruction,
	output logic [4:0]  oControl
);

reg [7:0] OPCODE;
reg [7:0] FUNCT7;
reg [3:0] FUNCT3;

assign FUNCT7 = {1'b0, iInstruction[31:25]};
assign FUNCT3 = {1'b0, iInstruction[14:12]};
assign OPCODE = {1'b0, iInstruction[6:0]};

always @(*) begin
	case (iALUOp)
		2'b00: oControl <= OPADD;
		2'b01: oControl <= OPSUB;
		2'b10: 
			casex ({OPCODE, FUNCT3, FUNCT7})
				IDAND:   oControl <= OPAND;
				IDOR :   oControl <= OPOR;
				IDSLT:   oControl <= OPSLT;
				IDSUB:   oControl <= OPSUB;
				IDADD:   oControl <= OPADD;
				default: oControl <= ZERO;
			endcase
		
		default: oControl <= ZERO;
	endcase
end


endmodule