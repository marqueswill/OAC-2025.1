module CPUControl(
	input  [31:0] iInstruction,
	//output 		  oRegDst,
	output 		  oALUSrc,
	output 		  oMemtoReg,
	output 		  oRegWrite,
	output 		  oMemRead,
	output 		  oMemWrite,
	output 		  oBranch,
	output [1:0]  oALUOp
);

reg [7:0] OPCODE;
reg [7:0] FUNCT7;
reg [3:0] FUNCT3;

assign FUNCT7 = {1'b0, iInstruction[31:25]};
assign FUNCT3 = {1'b0, iInstruction[14:12]};
assign OPCODE = {1'b0, iInstruction[6:0]};

wire [7:0] outputs;


assign oALUSrc   = outputs[7];
assign oMemtoReg = outputs[6];
assign oRegWrite = outputs[5];
assign oMemRead  = outputs[4];
assign oMemWrite = outputs[3];
assign oBranch   = outputs[2];
assign oALUOp    = outputs[1:0];

always @(*) begin
	casex ({OPCODE, FUNCT3, FUNCT7}) // Uma saída por instrução, dá pra fazer de forma mais generalizada
		IDAND	 : outputs <= 8'b	00100010;
		IDOR	 : outputs <= 8'b	00100010;
		IDSLT	 : outputs <= 8'b	00100010;
		IDSUB	 : outputs <= 8'b	00100010;
		IDADD	 : outputs <= 8'b	00100010;
		IDJALR : outputs <= 8'b	10100000;
		IDBEQ	 : outputs <= 8'b	00000101;
		IDSW	 : outputs <= 8'b	10001000;
		IDADDI : outputs <= 8'b	10100000;
		IDLW	 : outputs <= 8'b	11110000;
		IDJAL	 : outputs <= 8'b	00100000;
		default: outputs <= ZERO;
	endcase
end


endmodule