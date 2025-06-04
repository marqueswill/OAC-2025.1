`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input logic CLOCK, Reset,
	input logic [4:0] Regin,
	output logic ClockDIV,
	output logic [31:0] PC, Instr, Regout,
	output logic [3:0] Estado,
	output logic [31:0] oSaidaULA,
	output logic [31:0] oEntradaULA2,
	output logic [31:0] oLeituraReg1,
	output logic [31:0] oLeituraReg2,
	output logic [31:0] oDadosLidosMemoria,
	output logic [31:0] oEscritaReg,
	output logic [9:0] oCPUControl,
	output logic [4:0] oRd,
	output logic [31:0] oImm
);
	
		
	initial 
		ClockDIV <= 1'b1;

	reg [1:0] counter = 0;

	always @(posedge CLOCK) begin
		 counter <= counter + 1;
		 if (counter == 2'b11) begin
			  ClockDIV <= ~ClockDIV;
			  counter <= 0;
		 end
	end
		

	
	Uniciclo UNI1 (
		.clockCPU(ClockDIV),
		.clockMem(CLOCK),
		.reset(Reset),
		.PC(PC),
		.Instr(Instr),
		.regin(Regin),
		.regout(Regout),
		.oSaidaULA(oSaidaULA),
		.oEntradaULA2(oEntradaULA2),
		.oLeituraReg1(oLeituraReg1),
		.oLeituraReg2(oLeituraReg2),
		.oDadosLidosMemoria(oDadosLidosMemoria),
		.oEscritaReg(oEscritaReg),
		.oCPUControl(oCPUControl),
		.oRd(oRd),
		.oImm(oImm)
	);

					
/*	Multiciclo MULT1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout), .estado(Estado);	*/
						
/* Pipeline PIP1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); */
		
	
endmodule
