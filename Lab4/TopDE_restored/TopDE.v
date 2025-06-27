`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input  logic        CLOCK, Reset,
	input  logic [4:0]  Regin,
	output logic        ClockDIV,
	output logic [31:0] PC, Instr, Regout
	
);
	
		
initial 
	ClockDIV <= 1'b1;

reg [1:0] counter = 0;

always @(posedge CLOCK) begin
	 counter <= counter + 1;
	 if (counter == 2'b11) begin
		  ClockDIV <= ~ClockDIV;
		  counter <= 0;
	 end
end
	
Pipeline PIP1 (
	.clockCPU(ClockDIV),
	.clockMem(CLOCK),
	.reset(Reset),
	.PC(PC),
	.Instr(Instr),
	.regin(Regin),
	.regout(Regout)
);		
	

/*Uniciclo UNI1 (
	.clockCPU(ClockDIV),
	.clockMem(CLOCK),
	.reset(Reset),
	.PC(PC),
	.Instr(Instr),
	.regin(Regin),
	.regout(Regout)
);

					
/*	Multiciclo MULT1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout), .estado(Estado);	*/
						
/* Pipeline PIP1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); */

endmodule
