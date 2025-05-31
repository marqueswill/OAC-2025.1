`ifndef PARAM
	`include "Parametros.v"
`endif

module Uniciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output reg [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout
	);
	
	
	initial
		begin
			PC<=TEXT_ADDRESS;
			Instr<=32'b0;
			regout<=32'b0;
		end
		
		wire [31:0] EntradaULA2,SaidaULA, DadosLidosMemoria, imm, ProxInst;
		wire [31:0] EscritaReg,LeituraReg1, LeituraReg2;
		wire oRegDst, oALUOrg, oMem2Reg, oEscreveReg, LeMem, EscreveMem, oBranch, oZeroAlu;
		wire [1:0] oALUOp;
		wire [4:0]  AluControl;
		
//******************************************
// Aqui vai o seu código do seu processador
always @(*) begin
    ProxInst = PC + 32'd4; // Atualiza ProxInst sempre que PC mudar
end

always @(posedge clockCPU or posedge reset) begin
    if (reset)
        PC <= TEXT_ADDRESS;
    else if(oJalr) // Verifica se a instrução é JALR
        PC <= (LeituraReg1 + imm) & ~32'b1;  // Atualiza PC para rs1 + imm, garantindo alinhamento
    else if(oJal)
		PC <= PC + imm;
	else if(oBranch & oZeroAlu)
		PC <= imm;
	 else
        PC <= ProxInst;
end



//Banco de registradores
Registers bancoRegister(
	clockCPU, reset, oEscreveReg,
    Instr[19:15], Instr[24:20], Instr[11:7],
    EscritaReg,
    LeituraReg1, LeituraReg2,

    regin,
    regout
);

// Instanciação das memórias
ramI MemINSTR (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .rden(1'b1), .q(Instr));
ramD MemDADOS (.address(SaidaULA[11:2]), .clock(clockMem), .data(LeituraReg2), .wren(EscreveMem), .rden(LeMem),.q(DadosLidosMemoria));

// Controle da CPU

CPUControl cpuControl(Instr[31:0], oALUOrg, oMem2Reg, oEscreveReg, LeMem, EscreveMem, oBranch, oJalr, oJal, oALUOp);

//Controle da ULA
		
ALUControl aluControl(oALUOp, Instr, AluControl);

// Geração de Imediato
ImmGen imGerador (Instr,imm);

// Aplicação da Ula
always @(*) begin
    if (oALUOrg)
        EntradaULA2 <= imm;
    else
        EntradaULA2 <= LeituraReg2;
end
ALU ula(AluControl,
	LeituraReg1, 
	EntradaULA2,
	SaidaULA,
	oZeroAlu);

//Escrita no registrador
always @(*) begin
    if (oJalr) // JALR
        EscritaReg <= ProxInst; // Armazena PC+4 no registrador de destino
    else if (oMem2Reg)
        EscritaReg <= DadosLidosMemoria;
    else
        EscritaReg <= SaidaULA;
end
	

	
//*****************************************	
			
endmodule