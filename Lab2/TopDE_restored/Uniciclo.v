`ifndef PARAM
	`include "Parametros.v"
`endif

module Uniciclo (
	input  logic        clockCPU, clockMem,
	input  logic        reset,
	output reg   [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0]  regin,
	output logic [31:0] regout
);
	
	
initial begin
	PC     <= TEXT_ADDRESS;
	Instr  <= 32'b0;
	regout <= 32'b0;
end
		
wire [31:0] EntradaULA2, SaidaULA, DadosLidosMemoria, imm, ProxInst, novoPC;
wire [31:0] EscritaReg, LeituraReg1, LeituraReg2;


wire oRegDst, oALUOrg, oMem2Reg, oEscreveReg, LeMem, EscreveMem, oBranch, oJalr, oJal, oZeroAlu;
wire [1:0] oALUOp;
wire [4:0] AluControl;


//******************************************

assign ProxInst = PC + 32'd4;
always @(*) begin
		if (oJalr)
			novoPC <= (LeituraReg1 + imm) & ~32'd1;
		else if ((oBranch && oZeroAlu) || oJal)
			novoPC <= PC + imm;
		else
			novoPC <= ProxInst;
end

always @(posedge clockCPU or posedge reset) begin
	if (reset) begin
		PC <= TEXT_ADDRESS;
	end else begin
		PC <= novoPC;
	end
end




//Banco de registradores

always @(*) begin
	if (oJalr || oJal)
		EscritaReg <= ProxInst;
	else if (oMem2Reg)
		EscritaReg <= DadosLidosMemoria;
	else
		EscritaReg <= SaidaULA;
end

Registers bancoRegister(
    .iCLK(clockCPU),
    .iRST(reset),
    .iRegWrite(oEscreveReg),
    
    .iReadRegister1(Instr[19:15]),
    .iReadRegister2(Instr[24:20]),
    .iWriteRegister(Instr[11:7]),
    
    .iWriteData(EscritaReg),
    
    .oReadData1(LeituraReg1),
    .oReadData2(LeituraReg2),
    
    .iRegDispSelect(regin),
    .oRegDisp(regout)
);


// Instanciação das memórias
ramI MemINSTR (
	.address(PC[11:2]),       
	.clock(clockMem), 
	.data(),            
	.wren(1'b0),       
	.rden(1'b1),  
	.q(Instr)
);

ramD MemDADOS (
	.address(SaidaULA[11:2]), 
	.clock(clockMem), 
	.data(LeituraReg2), 
	.wren(EscreveMem), 
	.rden(LeMem), 
	.q(DadosLidosMemoria)
);

	

// Controle da CPU
CPUControl cpuControl(
	.iInstruction(Instr),
	.oALUSrc(oALUOrg),
	.oMemtoReg(oMem2Reg),
	.oRegWrite(oEscreveReg),
	.oMemRead(LeMem),
	.oMemWrite(EscreveMem),
	.oBranch(oBranch),
	.oJal(oJal),
	.oJalr(oJalr),
	.oALUOp(oALUOp)
);


//Controle da ULA
ALUControl aluControl(
	.iALUOp(oALUOp),
	.iInstruction(Instr),
	.oControl(AluControl)
);



// Geração de Imediato
ImmGen imGerador(
	.iInstrucao(Instr),
	.oImm(imm)
);


// Aplicação da Ula
always @(*) begin
	if (oALUOrg)
		EntradaULA2 <= imm;
	else
		EntradaULA2 <= LeituraReg2;
end


ALU ula(
    .iControl(AluControl),
    .iA(LeituraReg1),
    .iB(EntradaULA2),
    .oResult(SaidaULA),
    .oZero(oZeroAlu)
);




//*****************************************	
			
endmodule