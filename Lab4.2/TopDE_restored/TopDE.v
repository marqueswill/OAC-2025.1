`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input  logic        CLOCK, Reset,
	input  logic [4:0]  Regin,
	output logic        ClockDIV,
	output logic [31:0] PC, Instr, Regout,

	// Pipeline Register Outputs
	output logic [31:0] IF_ID_instr_out,
	output logic [31:0] IF_ID_pc_out,

	output logic [31:0] ID_EX_pc_out,
	output logic [31:0] ID_EX_imm_out,
	output logic [31:0] ID_EX_rs1_val_out,
	output logic [31:0] ID_EX_rs2_val_out,
	output logic [31:0] ID_EX_instr_out,
	output logic [4:0]  ID_EX_rd_out,

	output logic [31:0] EX_MEM_ALU_result_out,
	output logic [31:0] EX_MEM_rs1_val_out,
	output logic [31:0] EX_MEM_rs2_val_out,
	output logic [31:0] EX_MEM_pc_out,
	output logic [31:0] EX_MEM_imm_out,
	output logic [4:0]  EX_MEM_rd_out

	// output logic [31:0] MEM_WB_MemData_out,
	// output logic [31:0] MEM_WB_ALU_result_out,
	// output logic [4:0]  MEM_WB_rd_out
	
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
	.regout(Regout),

	// IF/ID
	.IF_ID_instr_out(IF_ID_instr_out),
	.IF_ID_pc_out(IF_ID_pc_out),

	// ID/EX
	.ID_EX_pc_out(ID_EX_pc_out),
	.ID_EX_imm_out(ID_EX_imm_out),
	.ID_EX_rs1_val_out(ID_EX_rs1_val_out),
	.ID_EX_rs2_val_out(ID_EX_rs2_val_out),
	.ID_EX_instr_out(ID_EX_instr_out),
	.ID_EX_rd_out(ID_EX_rd_out),

	// // EX/MEM
	.EX_MEM_ALU_result_out(EX_MEM_ALU_result_out),
	.EX_MEM_rs1_val_out(EX_MEM_rs1_val_out),
	.EX_MEM_rs2_val_out(EX_MEM_rs2_val_out),
	.EX_MEM_pc_out(EX_MEM_pc_out),
	.EX_MEM_imm_out(EX_MEM_imm_out),
	.EX_MEM_rd_out(EX_MEM_rd_out)

	// // MEM/WB
	// .MEM_WB_MemData_out(MEM_WB_MemData_out),
	// .MEM_WB_ALU_result_out(MEM_WB_ALU_result_out),
	// .MEM_WB_rd_out(MEM_WB_rd_out)
);	
	
endmodule
