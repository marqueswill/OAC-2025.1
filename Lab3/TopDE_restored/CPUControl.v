`ifndef PARAM
	`include "Parametros.v"
`endif

module CPUControl(
	input			  iClock,
	input  [31:0] iInstruction,
	output 		  EscrevePCCond, EscrevePC, IouD, EscreveMem, LeMem, EscreveIR,
	output		  OrigPC, EscrevePCB, EscreveReg, 
	output [1:0]  Mem2Reg, ALUOp, OrigAUla, OrigBUla
);

//wire [7:0] OPCODE;
//wire [7:0] FUNCT7;
//wire [3:0] FUNCT3;
//
//assign FUNCT7 = {1'b0, iInstruction[31:25]};
//assign FUNCT3 = {1'b0, iInstruction[14:12]};
//assign OPCODE = {1'b0, iInstruction[6:0]};
//
//wire [9:0] outputs;
//
//assign oALUSrc   = outputs[9];
//assign oMemtoReg = outputs[8];
//assign oRegWrite = outputs[7];
//assign oMemRead  = outputs[6];
//assign oMemWrite = outputs[5];
//assign oBranch   = outputs[4];
//assign oJal      = outputs[3];
//assign oJalr     = outputs[2];
//assign oALUOp    = outputs[1:0];
//
//always @(*) begin
//	casex ({OPCODE, FUNCT3, FUNCT7}) // Uma saída por instrução, dá pra fazer de forma mais generalizada
//		IDAND	 : outputs <= 10'b 0010000010;
//		IDOR	 : outputs <= 10'b 0010000010;
//		IDSLT	 : outputs <= 10'b 0010000010;
//		IDSUB	 : outputs <= 10'b 0010000010;
//		IDADD	 : outputs <= 10'b 0010000010;
//		IDJALR : outputs <= 10'b 1010000100;
//		IDBEQ	 : outputs <= 10'b 0000010001;
//		IDSW	 : outputs <= 10'b 1000100000;
//		IDADDI : outputs <= 10'b 1010000000;
//		IDLW	 : outputs <= 10'b 1111000000;
//		IDJAL	 : outputs <= 10'b 0010001000;
//		default: outputs   <= ZERO;
//	endcase
//end

endmodule