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
		
		wire [31:0] SaidaULA, Leitura2, MemData;
		wire EscreveMem, LeMem;
		
//******************************************
// Aqui vai o seu código do seu processador



always @(posedge clockCPU  or posedge reset)
	if(reset)
		PC <= TEXT_ADDRESS;
	else
		PC <= PC + 32'd4;

		
		
assign EscreveMem = 1'b0;
assign LeMem = 1'b1;
assign SaidaULA = 32'b0;


// Instanciação das memórias
ramI MemC (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .rden(1'b1), .q(Instr));
ramD MemD (.address(SaidaULA[11:2]), .clock(clockMem), .data(Leitura2), .wren(EscreveMem), .rden(LeMem),.q(MemData));
		

	
		
//*****************************************	
			
endmodule
