`ifndef PARAM
	`include "Parametros.v"
`endif

module ALU (
	input 		 [4:0]  iControl,
	input signed [31:0] iA, 
	input signed [31:0] iB,
	output logic [31:0] oResult,
	output        oZero
);

always @(*) begin
	case (iControl)
		OPADD:  oResult <= iA + iB;
		OPSUB:  oResult <= iA - iB;
		OPAND:  oResult <= iA & iB;
		OPOR:   oResult <= iA | iB;
		OPSLT:  oResult <= (iA < iB) ? 32'd1 : 32'd0;
		default: oResult <= 32'd0;
	endcase
end

assign oZero = (oResult == 32'd0 || iA == iB);

endmodule
