`ifndef PARAM
	`include "Parametros.v"
`endif
module CPUControlMulticiclo(
	input  [31:0] iInstruction,
	input  wire 		  iCLK, iRST,
	output EscrevePC,
	output EscrevePCCond,
	output IouD,
	output LeMem,
	output EscreveMem,
	output EscreveIR,
	output [1:0] Mem2Reg,
	output OrigPC,
	output [1:0] OrigAULA,
	output [1:0] OrigBULA,
	output [1:0] ALUOp,
	output EscreveReg,
	output EscrevePCB
);
	wire [7:0] OPCODE;
	wire [7:0] FUNCT7;
	wire [3:0] FUNCT3;

	assign FUNCT7 = {1'b0, iInstruction[31:25]};
	assign FUNCT3 = {1'b0, iInstruction[14:12]};
	assign OPCODE = {1'b0, iInstruction[6:0]};

	wire [3:0] direcaoEstado1, direcaoEstado2;
   reg  [3:0] regEstado; 

always @(posedge iCLK or posedge iRST) begin

	if (iRST)
		begin // reseta o banco de registradores e pilha
			regEstado <= 4'd0;
			EscrevePC    <= 0;
			EscrevePCCond<= 0;
			IouD         <= 0;
			LeMem        <= 0;
			EscreveMem   <= 0;
			EscreveIR    <= 0;
			Mem2Reg      <= 2'b00;
			OrigPC       <= 0;
			OrigAULA     <= 2'b00;
			OrigBULA     <= 2'b00;
			ALUOp        <= 2'b00;
			EscreveReg   <= 0;
			EscrevePCB   <= 0;
		end
	else
	begin
			casex ({OPCODE, FUNCT3, FUNCT7}) // Uma saída por instrução, dá pra fazer de forma mais generalizada
				IDAND	 : direcaoEstado1 <= 4'd6;
				IDOR	 : direcaoEstado1 <= 4'd6;
				IDSLT	 : direcaoEstado1 <= 4'd6;
				IDSUB	 : direcaoEstado1 <= 4'd6;
				IDADD	 : direcaoEstado1 <= 4'd6;
				IDJALR : direcaoEstado1 <= 4'd11;
				IDBEQ	 : direcaoEstado1 <= 4'd8;
				IDSW	 : direcaoEstado1 <= 4'd2;
				IDADDI : direcaoEstado1 <= 4'd10;
				IDLW	 : direcaoEstado1 <= 4'd2;
				IDJAL	 : direcaoEstado1 <= 4'd9;
				default: direcaoEstado1   <= 4'd0;
			endcase
			casex ({OPCODE, FUNCT3, FUNCT7}) // Uma saída por instrução, dá pra fazer de forma mais generalizada
				IDSW	 : direcaoEstado2 <= 4'd5;
				IDLW	 : direcaoEstado2 <= 4'd3;
				default: direcaoEstado2   <= 4'd0;
			endcase
		case (regEstado)
            4'd0:
				begin
					regEstado <= 4'd1; // Estado 0
						EscrevePC<=1;
						EscrevePCCond<=0;
						IouD<=0;
						LeMem<=1;
						EscreveMem<=0;
						EscreveIR<=1;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b10;
						OrigBULA<=2'b01;
						ALUOp<=2'b00;
						EscreveReg<=0;
						EscrevePCB<=1;
				end
            4'd1:
				begin
					 regEstado <= direcaoEstado1; // Estado 1
						EscrevePC<=0;
						EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b00;
						OrigBULA<=2'b10;
						ALUOp<=2'b00;
						EscreveReg<=0;
						EscrevePCB<=0;
				end
            4'd2:
				begin
					 regEstado <= direcaoEstado2; // Estado 2
						EscrevePC<=0;
						EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b01;
						OrigBULA<=2'b10;
						ALUOp<=2'b00;
						EscreveReg<=0;
						EscrevePCB<=0;
				end
            4'd3:
				begin
					 regEstado <= 4'd4; // Estado 3
						EscrevePC<=0;
						EscrevePCCond<=0;
						IouD<=1;
						LeMem<=1;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b00;
						OrigBULA<=2'b00;
						ALUOp<=2'b00;
						EscreveReg<=0;
						EscrevePCB<=0;
				end
            4'd4:
				begin
					 regEstado <= 4'd0; // Estado 4
						EscrevePC<=0;
						EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b10;
						OrigPC<=0;
						OrigAULA<=2'b00;
						OrigBULA<=2'b00;
						ALUOp<=2'b00;
						EscreveReg<=1;
						EscrevePCB<=0;
				end
            4'd5:
				begin
					 regEstado <= 4'd0; // Estado 5
					 EscrevePC<=0;
						EscrevePCCond<=0;
						IouD<=1;
						LeMem<=0;
						EscreveMem<=1;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b00;
						OrigBULA<=2'b00;
						ALUOp<=2'b00;
						EscreveReg<=0;
						EscrevePCB<=0;
				end
            4'd6:
				begin
					 regEstado <= 4'd7; // Estado 6
					 EscrevePC<=0;
					 EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b01;
						OrigBULA<=2'b00;
						ALUOp<=2'b10;
						EscreveReg<=0;
						EscrevePCB<=0;
				end
            4'd7:
				begin
					 regEstado <= 4'd0; // Estado 7
					 EscrevePC<=0;
					 EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b00;
						OrigBULA<=2'b00;
						ALUOp<=2'b00;
						EscreveReg<=1;
						EscrevePCB<=0;
				end
            4'd8:
				begin
					 regEstado <= 4'd0; // Estado 8
					 EscrevePC<=0;
					 EscrevePCCond<=1;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=1;
						OrigAULA<=2'b01;
						OrigBULA<=2'b00;
						ALUOp<=2'b01;
						EscreveReg<=0;
						EscrevePCB<=0;
				end
            4'd9:
				begin
					 regEstado <= 4'd0; // Estado 9
					 EscrevePC<=1;
					 EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b01;
						OrigPC<=1;
						OrigAULA<=2'b00;
						OrigBULA<=2'b00;
						ALUOp<=2'b00;
						EscreveReg<=1;
						EscrevePCB<=0;
				end
				4'd10:
				begin
					 regEstado <= 4'd7; // Estado 10
					 EscrevePC<=0;
					 EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b00;
						OrigPC<=0;
						OrigAULA<=2'b01;
						OrigBULA<=2'b10;
						ALUOp<=2'b00;
						EscreveReg<=0;
						EscrevePCB<=0;
				end
				4'd11:
				begin
					 regEstado <= 4'd0; // Estado 11
					 EscrevePC<=1;
					 EscrevePCCond<=0;
						IouD<=0;
						LeMem<=0;
						EscreveMem<=0;
						EscreveIR<=0;
						Mem2Reg<=2'b01;
						OrigPC<=0;
						OrigAULA<=2'b01;
						OrigBULA<=2'b10;
						ALUOp<=2'b00;
						EscreveReg<=1;
						EscrevePCB<=0;
				end
            default: 
				begin
					regEstado <= 5'd0; // Caso padrão (valor inesperado)
					EscrevePC    <= 0;
					EscrevePCCond<= 0;
					IouD         <= 0;
					LeMem        <= 0;
					EscreveMem   <= 0;
					EscreveIR    <= 0;
					Mem2Reg      <= 2'b00;
					OrigPC       <= 0;
					OrigAULA     <= 2'b00;
					OrigBULA     <= 2'b00;
					ALUOp        <= 2'b00;
					EscreveReg   <= 0;
					EscrevePCB   <= 0;
				end
        endcase
	end	
end
endmodule
