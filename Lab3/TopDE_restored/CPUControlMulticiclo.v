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
			regEstado <= 3'b0;
		end
	else
	begin
			casex ({OPCODE, FUNCT3, FUNCT7}) // Uma saída por instrução, dá pra fazer de forma mais generalizada
				IDAND	 : direcaoEstado1 <= 4'd6;
				IDOR	 : direcaoEstado1 <= 4'd6;
				IDSLT	 : direcaoEstado1 <= 4'd6;
				IDSUB	 : direcaoEstado1 <= 4'd6;
				IDADD	 : direcaoEstado1 <= 4'd6;
				//IDJALR : direcaoEstado1 <= ;
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
            4'd0: regEstado = 4'd1; // Estado 0
            4'd1: regEstado = direcaoEstado1; // Estado 1
            4'd2: regEstado = direcaoEstado2; // Estado 2
            4'd3: regEstado = 4'd4; // Estado 3
            4'd4: regEstado = 4'd0; // Estado 4
            4'd5: regEstado = 4'd0; // Estado 5
            4'd6: regEstado = 4'd7; // Estado 6
            4'd7: regEstado = 4'd0; // Estado 7
            4'd8: regEstado = 4'd0; // Estado 8
            4'd9: regEstado = 4'd0; // Estado 9
				4'd9: regEstado = 4'd7; // Estado 10
            default: regEstado = 5'd0; // Caso padrão (valor inesperado)
        endcase
	end	
end
endmodule
