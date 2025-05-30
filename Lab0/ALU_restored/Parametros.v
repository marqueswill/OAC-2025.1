

/* Operacoes da ULA */
parameter
   ZERO     = 32'd0,	 
	OPAND		= 5'd0,
	OPOR		= 5'd1,
	OPXOR		= 5'd2,
	OPADD		= 5'd3,
	OPSUB		= 5'd4,
	OPSLT		= 5'd5,
	OPSLTU	= 5'd6,
	OPSLL		= 5'd7,
	OPSRL		= 5'd8,
	OPSRA		= 5'd9,
	OPLUI		= 5'd10,
	OPMUL		= 5'd11,
	OPMULH	= 5'd12,
	OPMULHU	= 5'd13,
	OPMULHSU	= 5'd14,
	OPDIV		= 5'd15,
	OPDIVU	= 5'd16,
	OPREM		= 5'd17,
	OPREMU	= 5'd18,
	OPNULL	= 5'd31; // saída ZERO