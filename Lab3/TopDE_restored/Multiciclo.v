`ifndef PARAM
	`include "Parametros.v"
`endif

module Multiciclo (
	input  logic clockCPU, clockMem,
	input  logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0]  regin,
	output logic [31:0] regout,
	output logic [3:0]  estado
);
	


reg  [31:0] PCBack, SaidaULA, A, B, InstReg, MemReg;

wire [4:0] RS1, RS2, RD;
wire [7:0] OPCODE;
wire [7:0] FUNCT7;
wire [3:0] FUNCT3;

assign FUNCT7 = InstReg[31:25];
assign FUNCT3 = InstReg[14:12];
assign OPCODE = InstReg[6:0];
assign RS1    = InstReg[19:15];
assign RS2    = InstReg[24:20];
assign RD     = InstReg[11:7];


wire [31:0] wPCNext, wEndereco, wDadoEscritaReg, wImm, wEntrada1ULA, wEntrada2ULA, wInstReg, wMemReg, wDadoMem, wDado1, wDado2;
wire wEscrevePCCond, wEscrevePC, wIouD, wEscreveMem, wLeMem, wEscreveIR;
wire wOrigPC, wEscrevePCB, wEscreveReg, wZero;
wire [1:0] wMem2Reg, wALUOp, wOrigAULA, wOrigBULA;
wire [4:0] oALUControl;


initial
	begin
		PC     <= 32'h0040_0000;
		PCBack <= 32'h0040_0000;
		Instr  <= 32'b0;
		regout <= 32'b0;
	end



//******************************************
// Aqui vai o seu código do seu processador

// SEQUENCIAL /////////

// PC
always @(posedge clockCPU or posedge reset)
	if(reset) 
		begin
			PC     <= TEXT_ADDRESS;
			PCBack <= TEXT_ADDRESS;
			estado <= 4'b0000;
		end 
	else begin
		A 			<= wDado1;
		B        <= wDado2;
		SaidaULA <= wSaidaULA;
		PCBack   <= PC;
		
		// Program Counter
		if ((wZero && wEscrevePCCond)|| wEscrevePC)
			PC <= wPCNext;
		
		// Leitura memória
		if (wEscreveIR)
			InstReg <= wDadoMem;
		else
			MemReg  <= wDadoMem;
	
	end




// Controle CPU
CPUControl controle_multiciclo (	
	.iClock(clockCPU),
	.iInstruction(InstReg),
	.EscrevePCCond(wEscrevePCCond), 
	.EscrevePC(wEscrevePC), 
	.IouD(wIouD), 
	.EscreveMem(wEscreveMem), 
	.LeMem(wLeMem), 
	.EscreveIR(wEscreveIR),
	.OrigPC(wOrigPC), 
	.ALUOp(wALUOp), 
	.OrigAUla(wOrigAUla), 
	.OrigBUla(wOrigBUla),
	.EscrevePCB(wEscrevePCB), 
	.EscreveReg(wEscreveReg), 
	.Mem2Reg(wMem2Reg)
); 

//Controle da ULA
ALUControl aluControl(
	.iALUOp(wALUOp),
	.iInstruction(InstReg),
	.oControl(oALUControl)
);

// Banco de registradores
Registers bancoRegister(
    .iCLK(clockCPU),
    .iRST(reset),
    .iRegWrite(wEscreveReg),
    
    .iReadRegister1(RS1),
    .iReadRegister2(RS2),
    .iWriteRegister(RD),
    
    .iWriteData(wDadoEscritaReg),
    
    .oReadData1(wDado1),
    .oReadData2(wDado2),
    
    .iRegDispSelect(regin),
    .oRegDisp(regout)
);

// Geração de Imediato
ImmGen imGerador(
	.iInstrucao(InstReg),
	.oImm(wImm)
);

// ULA
ALU ula(
    .iControl(oALUControl),
    .iA(wEntrada1ULA),
    .iB(wEntrada2ULA),
    .oResult(wSaidaULA),
    .oZero(wZero)
);

// Memória
ramI MemC (.address(wEndereco[11:2]), .clock(clockMem), .data(B), .wren(wEscreveMem & ~wEndereco[28]), .q(wInstReg));
ramD MemD (.address(wEndereco[11:2]), .clock(clockMem), .data(B), .wren(wEscreveMem &  wEndereco[28]), .q(wMemReg));
///////////////

// MUXES //////
// Origem PC
always @(*) begin
	if (wOrigPC)
		wPCNext <= SaidaULA;
	else 
		wPCNext <= wSaidaULA;
end

// Ler Inst ou Mem
always @(*) begin
	if (wIouD)
		wEndereco <= SaidaULA;
	else
		wEndereco <= PC;
	
end

// Dado escrita registrador (mem, pc ou ula)
always @(*) begin
	if (wMem2Reg == 2'd2)
		wDadoEscritaReg <= MemReg;
	else if (wMem2Reg == 2'd1)
		wDadoEscritaReg <= PC;
	else
		wDadoEscritaReg <= SaidaULA;
end

// Entrada 1 da ULA (PC, A ou PC antigo)
always @(*) begin
	if (wOrigAULA == 2'd2)
		wEntrada1ULA <= PC;
	else if (wOrigAULA == 2'd1)
		wEntrada1ULA <= A;
	else
		wEntrada1ULA <= PCBack;
end

// Entrada 2 da ULA (imm, 4 ou B)
always @(*) begin
	if (wOrigBULA == 2'd2)
		wEntrada2ULA <= wImm;
	else if (wOrigBULA == 2'd1)
		wEntrada2ULA <= 32'd4;
	else
		wEntrada2ULA <= B;
end

// tecnicamente dá pra se livrar desse mux
always @(*) begin
	if (wEndereco[28])
		wDadoMem <= wMemReg;
	else
		wDadoMem <= wInstReg;
end

///////////////
//*****************************************
	
			
endmodule
