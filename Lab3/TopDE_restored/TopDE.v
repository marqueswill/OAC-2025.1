`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input  logic        CLOCK, Reset,
	input  logic [4:0]  Regin,
	output logic        ClockDIV,
	output logic [31:0] PC, Instr, Regout,
	output logic [3:0]  Estado,

	// Saídas dos registradores internos do Multiciclo
	output logic [31:0] oPCBack,
	output logic [31:0] oSaidaULA,
	output logic [31:0] oA,
	output logic [31:0] oB,
	output logic [31:0] oInstReg,
	output logic [31:0] oMemReg,
	output logic [31:0] oAdress
);



Multiciclo MULT1 (
	.clockCPU(CLOCK), 
	.clockMem(CLOCK), 
	.reset(Reset), 
	.PC(PC), 
	.Instr(Instr), 
	.regin(Regin), 
	.regout(Regout), 
	.estado(Estado),

	// Conexão das saídas internas
	.oPCBack(oPCBack),
	.oSaidaULA(oSaidaULA),
	.oA(oA),
	.oB(oB),
	.oInstReg(oInstReg),
	.oMemReg(oMemReg),
	.oAdress(oAdress)
);

endmodule
