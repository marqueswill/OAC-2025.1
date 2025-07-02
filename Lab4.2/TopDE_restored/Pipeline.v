`ifndef PARAM
	`include "Parametros.v"
`endif

module Pipeline (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout,

	// IF/ID
	output logic [31:0] IF_ID_instr_out,
	output logic [31:0] IF_ID_pc_out,

	// ID/EX
	output logic [31:0] ID_EX_pc_out,
	output logic [31:0] ID_EX_imm_out,
	output logic [31:0] ID_EX_rs1_val_out,
	output logic [31:0] ID_EX_rs2_val_out,
	output logic [31:0] ID_EX_instr_out,
	output logic [4:0]  ID_EX_rd_out,

	// // EX/MEM
	output logic [31:0] EX_MEM_ALU_result_out,
	output logic [31:0] EX_MEM_rs1_val_out,
	output logic [31:0] EX_MEM_rs2_val_out,
	output logic [31:0] EX_MEM_pc_out,
	output logic [31:0] EX_MEM_imm_out,
	output logic [4:0]  EX_MEM_rd_out

	// // MEM/WB
	// output logic [31:0] MEM_WB_MemData_out,
	// output logic [31:0] MEM_WB_ALU_result_out,
	// output logic [4:0]  MEM_WB_rd_out
);

// TESTE (APAGAR)
	// Assign internal registers to outputs
	assign IF_ID_instr_out       = IF_ID_instr;
	assign IF_ID_pc_out          = IF_ID_pc;

	assign ID_EX_pc_out          = ID_EX_pc;
	assign ID_EX_imm_out         = ID_EX_imm;
	assign ID_EX_rs1_val_out     = ID_EX_rs1_val;
	assign ID_EX_rs2_val_out     = ID_EX_rs2_val;
	assign ID_EX_instr_out       = ID_EX_instr;
	assign ID_EX_rd_out          = ID_EX_rd;

	assign EX_MEM_ALU_result_out = EX_MEM_ALU_result;
	assign EX_MEM_rs1_val_out    = EX_MEM_rs1_val;
	assign EX_MEM_rs2_val_out    = EX_MEM_rs2_val;
	assign EX_MEM_pc_out         = EX_MEM_pc;
	assign EX_MEM_imm_out        = EX_MEM_imm;
	assign EX_MEM_rd_out         = EX_MEM_rd;

	// assign MEM_WB_MemData_out    = MEM_WB_MemData;
	// assign MEM_WB_ALU_result_out = MEM_WB_ALU_result;
	// assign MEM_WB_rd_out         = MEM_WB_rd;
//////////////////////////////////////////////////	

//Registrador IF
	logic [31:0] instr_IF;

//Registrador IF/ID
	logic [31:0] IF_ID_instr, IF_ID_pc;
	
	initial begin
			PC<=32'h0040_0000;
			Instr<=32'b0;
			regout<=32'b0;
		end
		

		
//1) ESTÁGIO IF

wire [31:0] PCPlus4;
assign PCPlus4 = PC + 32'd4;

// MUX PC
wire [31:0] PCNext;
assign PCNext = EX_MEM_Jalr  ? PCJalr_MEM :
                EX_MEM_Jal   ? PCBranch_MEM :
                BranchTaken  ? PCBranch_MEM :
                               PCPlus4;
										 
// Lógica atualização PC
always @(posedge clockCPU or posedge reset) begin
	if (reset)
		PC <= TEXT_ADDRESS;
	else if (!hazard_stall)
		PC <= PCNext;
end


//Memória de instruções
	ramI MemC (
		.address(PC[11:2]),
		.clock(clockMem),
		.data(32'b0),
		.wren(1'b0),
		.q(instr_IF)
	);

// REGISTRADOR IF/ID
always @(posedge clockCPU or posedge reset) begin
	if (reset) begin
		IF_ID_instr <= 32'b0;
		IF_ID_pc    <= 32'b0;
	end else if (!hazard_stall) begin
		IF_ID_instr <= instr_IF;
		IF_ID_pc    <= PC;
	end
	// else mantém o valor atual (stall)
end

	//Saídas de depuração
	assign Instr = instr_IF;
	

/*************************************************/
//2) ESTÁGIO ID	
	

wire [31:0] LeituraReg1, LeituraReg2;

//Banco de Registradores
Registers bancoRegister (
    .iCLK(clockCPU),
    .iRST(reset),
    .iRegWrite(RegWrite_WB),        
    .iReadRegister1(IF_ID_instr[19:15]),
    .iReadRegister2(IF_ID_instr[24:20]),
    .iWriteRegister(Rd_WB),         
    .iWriteData(WriteBackData),    
    .oReadData1(LeituraReg1),
    .oReadData2(LeituraReg2),
    .iRegDispSelect(regin),
    .oRegDisp(regout)
);

//Gerador de imediatos
wire [31:0] imm_ID;

ImmGen imGerador (
    .iInstrucao(IF_ID_instr),
    .oImm(imm_ID)
);

//CPUControl
wire ALUSrc_ID, MemtoReg_ID, RegWrite_ID, MemRead_ID, MemWrite_ID;
wire Branch_ID, Jal_ID, Jalr_ID;
wire [1:0] ALUOp_ID;

CPUControl unidadeControle (
    .iInstruction(IF_ID_instr),
    .oALUSrc(ALUSrc_ID),
    .oMemtoReg(MemtoReg_ID),
    .oRegWrite(RegWrite_ID),
    .oMemRead(MemRead_ID),
    .oMemWrite(MemWrite_ID),
    .oBranch(Branch_ID),
    .oJal(Jal_ID),
    .oJalr(Jalr_ID),
    .oALUOp(ALUOp_ID)
);		
		
//hazard

wire hazard_stall;
assign hazard_stall = ID_EX_MemRead &&
                     ((ID_EX_rd == IF_ID_instr[19:15]) || (ID_EX_rd == IF_ID_instr[24:20]));		

							
//REGISTRADOR ID/EX
reg [31:0] ID_EX_pc, ID_EX_imm, ID_EX_rs1_val, ID_EX_rs2_val, ID_EX_instr;
reg [4:0]  ID_EX_rd;
reg        ID_EX_ALUSrc, ID_EX_MemtoReg, ID_EX_RegWrite;
reg        ID_EX_MemRead, ID_EX_MemWrite, ID_EX_Branch, ID_EX_Jal, ID_EX_Jalr;
reg [1:0]  ID_EX_ALUOp;

always @(posedge clockCPU or posedge reset) begin
	if (reset) begin
		ID_EX_pc        <= 0;
		ID_EX_imm       <= 0;
		ID_EX_rs1_val   <= 0;
		ID_EX_rs2_val   <= 0;
		ID_EX_instr     <= 0;
		ID_EX_rd        <= 0;
		ID_EX_ALUSrc    <= 0;
		ID_EX_MemtoReg  <= 0;
		ID_EX_RegWrite  <= 0;
		ID_EX_MemRead   <= 0;
		ID_EX_MemWrite  <= 0;
		ID_EX_Branch    <= 0;
		ID_EX_Jal       <= 0;
		ID_EX_Jalr      <= 0;
		ID_EX_ALUOp     <= 0;
	end else begin
		// ID_EX_pc        <= IF_ID_pc;
		// ID_EX_imm       <= imm_ID;
		// ID_EX_rs1_val   <= LeituraReg1;
		// ID_EX_rs2_val   <= LeituraReg2;
		// ID_EX_instr     <= IF_ID_instr;
		// /*ID_EX_rs1       <= IF_ID_instr[19:15];
		// ID_EX_rs2       <= IF_ID_instr[24:20];*/
		// ID_EX_rd        <= IF_ID_instr[11:7];

		//sinais de controle são afetados pelo stall
		if (hazard_stall) begin
			ID_EX_ALUSrc    <= 0;
			ID_EX_MemtoReg  <= 0;
			ID_EX_RegWrite  <= 0;
			ID_EX_MemRead   <= 0;
			ID_EX_MemWrite  <= 0;
			ID_EX_Branch    <= 0;
			ID_EX_Jal       <= 0;
			ID_EX_Jalr      <= 0;
			ID_EX_ALUOp     <= 2'b00;
		end else begin
			ID_EX_pc        <= IF_ID_pc;
			ID_EX_imm       <= imm_ID;
			ID_EX_rs1_val   <= LeituraReg1;
			ID_EX_rs2_val   <= LeituraReg2;
			ID_EX_instr     <= IF_ID_instr;
			ID_EX_rd        <= IF_ID_instr[11:7];

			ID_EX_ALUSrc    <= ALUSrc_ID;
			ID_EX_MemtoReg  <= MemtoReg_ID;
			ID_EX_RegWrite  <= RegWrite_ID;
			ID_EX_MemRead   <= MemRead_ID;
			ID_EX_MemWrite  <= MemWrite_ID;
			ID_EX_Branch    <= Branch_ID;
			ID_EX_Jal       <= Jal_ID;
			ID_EX_Jalr      <= Jalr_ID;
			ID_EX_ALUOp     <= ALUOp_ID;
		end
	end
end

		
/******************************************************/

//3) ESTÁGIO EX		
		
wire [4:0] ALUControl_EX;

//Instancia o ALUControl
ALUControl aluControl (
    .iALUOp(ID_EX_ALUOp),
    .iInstruction(ID_EX_instr), 
    .oControl(ALUControl_EX)
);

//Seleção da entrada B da ULA (MUX)
wire [31:0] ALU_inputB_EX;
assign ALU_inputB_EX = ID_EX_ALUSrc ? ID_EX_imm : ID_EX_rs2_val;

//Resultado da ULA
wire [31:0] ALU_result_EX;
wire zero_EX;

ALU ula (
    .iControl(ALUControl_EX),
    .iA(ID_EX_rs1_val),
    .iB(ALU_inputB_EX),
    .oResult(ALU_result_EX),
    .oZero(zero_EX)
);		

//REGISTRADOR EX/MEM

reg [31:0] EX_MEM_ALU_result, EX_MEM_rs1_val, EX_MEM_rs2_val, EX_MEM_pc, EX_MEM_imm;
reg [4:0]  EX_MEM_rd;
reg        EX_MEM_Zero, EX_MEM_Branch, EX_MEM_Jal, EX_MEM_Jalr;
reg        EX_MEM_MemRead, EX_MEM_MemWrite;
reg        EX_MEM_MemtoReg, EX_MEM_RegWrite;

always @(posedge clockCPU or posedge reset) begin
    if (reset) begin
        EX_MEM_ALU_result <= 0;
		  EX_MEM_rs1_val    <= 0;
        EX_MEM_rs2_val    <= 0;
        EX_MEM_rd         <= 0;
        EX_MEM_pc         <= 0;
        EX_MEM_Zero       <= 0;
        EX_MEM_Branch     <= 0;
        EX_MEM_Jal        <= 0;
        EX_MEM_Jalr       <= 0;
        EX_MEM_MemRead    <= 0;
        EX_MEM_MemWrite   <= 0;
        EX_MEM_MemtoReg   <= 0;
        EX_MEM_RegWrite   <= 0;
    end else begin
        EX_MEM_ALU_result <= ALU_result_EX;
		  EX_MEM_rs1_val    <= ID_EX_rs1_val;
        EX_MEM_rs2_val    <= ID_EX_rs2_val;
        EX_MEM_rd         <= ID_EX_rd;
        EX_MEM_pc         <= ID_EX_pc;
		  EX_MEM_imm        <= ID_EX_imm;
        EX_MEM_Zero       <= zero_EX;
        EX_MEM_Branch     <= ID_EX_Branch;
        EX_MEM_Jal        <= ID_EX_Jal;
        EX_MEM_Jalr       <= ID_EX_Jalr;
        EX_MEM_MemRead    <= ID_EX_MemRead;
        EX_MEM_MemWrite   <= ID_EX_MemWrite;
        EX_MEM_MemtoReg   <= ID_EX_MemtoReg;
        EX_MEM_RegWrite   <= ID_EX_RegWrite;
    end
end	
		
		
/****************************************************/

//4) ESTÁGIO MEM		
		
//Saída da memória de dados
wire [31:0] MemData_MEM;

ramD MemD (
    .address(EX_MEM_ALU_result[11:2]),
    .clock(clockMem),
    .data(EX_MEM_rs2_val),
    .wren(EX_MEM_MemWrite),
    .rden(EX_MEM_MemRead),
    .q(MemData_MEM)
);

//Cálculo de destino do PC (para jal, beq, etc.)
wire [31:0] PCBranch_MEM;
assign PCBranch_MEM = EX_MEM_pc + EX_MEM_imm; // o IMM original poderia ser propagado, se necessário		

// Condição de branch tomada
wire BranchTaken;
assign BranchTaken = EX_MEM_Branch && EX_MEM_Zero;

wire [31:0] PCJalr_MEM;
assign PCJalr_MEM = (EX_MEM_rs1_val + EX_MEM_imm) & ~32'd1;

//REGISTRADOR MEM/WB
reg [31:0] MEM_WB_MemData, MEM_WB_ALU_result;
reg [4:0]  MEM_WB_rd;
reg        MEM_WB_MemtoReg, MEM_WB_RegWrite;

always @(posedge clockCPU or posedge reset) begin
    if (reset) begin
        MEM_WB_MemData   <= 0;
        MEM_WB_ALU_result <= 0;
        MEM_WB_rd        <= 0;
        MEM_WB_MemtoReg  <= 0;
        MEM_WB_RegWrite  <= 0;
    end else begin
        MEM_WB_MemData   <= MemData_MEM;
        MEM_WB_ALU_result <= EX_MEM_ALU_result;
        MEM_WB_rd        <= EX_MEM_rd;
        MEM_WB_MemtoReg  <= EX_MEM_MemtoReg;
        MEM_WB_RegWrite  <= EX_MEM_RegWrite;
    end
end

/*************************************************/

//5) ESTÁGIO WB

wire [4:0] Rd_WB;
wire [31:0] WriteBackData;
wire RegWrite_WB;

//MUX para selecionar entre MemData e ALU result
assign WriteBackData = MEM_WB_MemtoReg ? MEM_WB_MemData : MEM_WB_ALU_result;
assign Rd_WB = MEM_WB_rd;
assign RegWrite_WB = MEM_WB_RegWrite;

endmodule