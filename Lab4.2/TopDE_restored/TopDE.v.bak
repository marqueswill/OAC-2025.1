`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input logic CLOCK, Reset,
	input logic [4:0] Regin,
	output logic ClockDIV,
	output logic [31:0] PC,Instr,Regout,
	output logic [3:0] Estado
	);
	
		
	initial 
		ClockDIV <= 1'b1;

	always @(posedge CLOCK) 
		begin 		
				ClockDIV <= ~ClockDIV;  //clockDIV metade da frequência do Clock
		end
	

	
	Uniciclo UNI1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); 

					
/*	Multiciclo MULT1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout), .estado(Estado);	*/
						
/* Pipeline PIP1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); */
		
	
endmodule
