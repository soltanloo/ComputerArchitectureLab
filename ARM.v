// ============================================================================
// Copyright (c) 2012 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//
//
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
//
// Major Functions:	DE2 TOP LEVEL
//
// ============================================================================
//
// Revision History :
// ============================================================================
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/08/19  :|      Initial Revision
//   V1.1 :| Johnny Chen       :| 05/11/16  :|      Added FLASH Address FL_ADDR[21:20]
//   V1.2 :| Johnny Chen       :| 05/11/16  :|		Fixed ISP1362 INT/DREQ Pin Direction.   
//   V1.3 :| Johnny Chen       :| 06/11/16  :|		Added the Dedicated TV Decoder Line-Locked-Clock Input
//													            for DE2 v2.X PCB.
//   V1.5 :| Eko    Yan        :| 12/01/30  :|      Update to version 11.1 sp1.
// ============================================================================

module ARM
	(
		TEST_CLOCK,
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		HEX4,							//	Seven Segment Digit 4
		HEX5,							//	Seven Segment Digit 5
		HEX6,							//	Seven Segment Digit 6
		HEX7,							//	Seven Segment Digit 7
		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[8:0]
		LEDR,							//	LED Red[17:0]
		////////////////////////	UART	////////////////////////
		//UART_TXD,						//	UART Transmitter
		//UART_RXD,						//	UART Receiver
		////////////////////////	IRDA	////////////////////////
		//IRDA_TXD,						//	IRDA Transmitter
		//IRDA_RXD,						//	IRDA Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 22 Bits
		FL_WE_N,						//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,						//	FLASH Output Enable
		FL_CE_N,						//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	ISP1362 Interface	////////////////
		OTG_DATA,						//	ISP1362 Data bus 16 Bits
		OTG_ADDR,						//	ISP1362 Address 2 Bits
		OTG_CS_N,						//	ISP1362 Chip Select
		OTG_RD_N,						//	ISP1362 Write
		OTG_WR_N,						//	ISP1362 Read
		OTG_RST_N,						//	ISP1362 Reset
		OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
		OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
		OTG_INT0,						//	ISP1362 Interrupt 0
		OTG_INT1,						//	ISP1362 Interrupt 1
		OTG_DREQ0,						//	ISP1362 DMA Request 0
		OTG_DREQ1,						//	ISP1362 DMA Request 1
		OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
		OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
		////////////////////	LCD Module 16X2		////////////////
		LCD_ON,							//	LCD Power ON/OFF
		LCD_BLON,						//	LCD Back Light ON/OFF
		LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,							//	LCD Enable
		LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA,						//	LCD Data bus 8 bits
		////////////////////	SD_Card Interface	////////////////
		//SD_DAT,							//	SD Card Data
		//SD_WP_N,						   //	SD Write protect 
		//SD_CMD,							//	SD Card Command Signal
		//SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	   TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,						//	PS2 Data
		PS2_CLK,						//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		////////////	Ethernet Interface	////////////////////////
		ENET_DATA,						//	DM9000A DATA bus 16Bits
		ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
		ENET_CS_N,						//	DM9000A Chip Select
		ENET_WR_N,						//	DM9000A Write
		ENET_RD_N,						//	DM9000A Read
		ENET_RST_N,						//	DM9000A Reset
		ENET_INT,						//	DM9000A Interrupt
		ENET_CLK,						//	DM9000A Clock 25 MHz
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,						//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		TD_DATA,    					//	TV Decoder Data bus 8 bits
		TD_HS,							//	TV Decoder H_SYNC
		TD_VS,							//	TV Decoder V_SYNC
		TD_RESET,						//	TV Decoder Reset
		TD_CLK27,                  //	TV Decoder 27MHz CLK
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
output TEST_CLOCK;
input		   	CLOCK_27;				//	27 MHz
input		   	CLOCK_50;				//	50 MHz
input			   EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	   [3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	  [17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
output  [17:0]	LEDR;					//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
//output			UART_TXD;				//	UART Transmitter
//input			   UART_RXD;				//	UART Receiver
////////////////////////////	IRDA	////////////////////////////
//output			IRDA_TXD;				//	IRDA Transmitter
//input			   IRDA_RXD;				//	IRDA Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	  [15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output  [11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	  [7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output [21:0]	FL_ADDR;				//	FLASH Address bus 22 Bits
output			FL_WE_N;				//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;				//	FLASH Output Enable
output			FL_CE_N;				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	 [15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output [17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask 
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	ISP1362 Interface	////////////////////////
inout	 [15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
output  [1:0]	OTG_ADDR;				//	ISP1362 Address 2 Bits
output			OTG_CS_N;				//	ISP1362 Chip Select
output			OTG_RD_N;				//	ISP1362 Write
output			OTG_WR_N;				//	ISP1362 Read
output			OTG_RST_N;				//	ISP1362 Reset
output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
input			   OTG_INT0;				//	ISP1362 Interrupt 0
input			   OTG_INT1;				//	ISP1362 Interrupt 1
input			   OTG_DREQ0;				//	ISP1362 DMA Request 0
input			   OTG_DREQ1;				//	ISP1362 DMA Request 1
output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
inout	  [7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
//inout	 [3:0]	SD_DAT;					//	SD Card Data
//input			   SD_WP_N;				   //	SD write protect
//inout			   SD_CMD;					//	SD Card Command Signal
//output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			   I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 	   PS2_DAT;				//	PS2 Data
input			   PS2_CLK;				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;					// CPLD -> FPGA (data in)
input  			TCK;					// CPLD -> FPGA (clk)
input  			TCS;					// CPLD -> FPGA (CS)
output 			TDO;					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
output			ENET_CS_N;				//	DM9000A Chip Select
output			ENET_WR_N;				//	DM9000A Write
output			ENET_RD_N;				//	DM9000A Read
output			ENET_RST_N;				//	DM9000A Reset
input			   ENET_INT;				//	DM9000A Interrupt
output			ENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
inout			   AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			   AUD_ADCDAT;				//	Audio CODEC ADC Data
inout			   AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout			   AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input	 [7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			   TD_HS;					//	TV Decoder H_SYNC
input			   TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
input          TD_CLK27;            //	TV Decoder 27MHz CLK
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1

	wire freeze, hazard, rstSwitch;
	assign freeze = hazard;
	assign rstSwitch = SW[7];

	// IF Stage to IF Stage Reg wires
	wire[31:0] PC, Instruction;

	// IF Stage Reg to ID Stage wires
	wire[31:0] IF_Reg_PC_out, IF_Reg_Ins_out;

	// ID Stage to ID Stage Reg wires
	wire imm, WB_EN, MEM_R_EN, MEM_W_EN, B, S, Two_src;
	wire[3:0] EXE_CMD, Dest, src1, src2;
	wire[31:0] Val_Rn, Val_Rm;
	wire[11:0] Shift_operand;
  wire[23:0] Signed_imm_24;
  wire[3:0] destAddress;
  wire[31:0] ID_Stage_PC;

	// ID Stage Reg to EXE Stage wires
	wire ID_out_WB_EN, ID_out_MEM_R_EN, ID_out_MEM_W_EN, ID_out_B, ID_out_S;
  wire[3:0] ID_out_EXE_CMD;
  wire[31:0] ID_out_Val_Rm, ID_out_Val_Rn;
  wire ID_out_imm;
  wire[11:0] ID_out_Shift_operand;
  wire[23:0] ID_out_Signed_imm_24;
  wire[3:0] ID_out_Dest;
  wire[31:0] ID_out_PC;

	// EXE Stage to EXE Stage Reg wires
	wire[31:0] ALU_result, Br_addr;
  
	// EXE Stage to SR wires
	wire[3:0] status;

	// EXE Stage Reg out wires
	wire EXE_Reg_out_WB_EN, EXE_Reg_out_MEM_R_EN, EXE_Reg_out_MEM_W_EN;
	wire[31:0] EXE_Reg_out_ALU_result, EXE_Reg_out_ST_val, EXE_Reg_out_Dest;

	// MEM Stage to MEM Stage Reg wires
	wire[31:0] MEM_Stage_out_MEM_result;

	// MEM Stage Reg out wires
	wire[31:0] MEM_Stage_Reg_out_ALU_result, MEM_Stage_Reg_out_MEM_read_value;
	wire[3:0] MEM_Stage_Reg_out_Dest;
	wire MEM_Stage_out_WB_EN, MEM_Stage_out_MEM_R_EN;

	// SR out wires
	wire[3:0] SR;

	// WB out wires
	wire[31:0] Result_WB;
  wire writeBackEn;
  wire[3:0] Dest_WB;

	IF_Stage if_stage(
		.clk(CLOCK_50), .rst(rstSwitch), .freeze(freeze), .Branch_taken(B), .BranchAddr(Br_addr),
		.PC(PC), .Instruction(Instruction), .out_clk(out_clk)
	);

	IF_Stage_Reg if_stage_reg(
		.clk(CLOCK_50), .rst(rstSwitch), .freeze(freeze), .flush(B), .PC_in(PC), .Instruction_in(Instruction),
		.PC(IF_Reg_PC_out), .Instruction(IF_Reg_Ins_out)
	);
	
	ID_Stage id_stage(
		.clk(CLOCK_50), .rst(rstSwitch), .Instruction(IF_Reg_Ins_out), .Result_WB(Result_WB), .writeBackEn(writeBackEn), .Dest_WB(Dest_WB), .hazard(hazard), .SR(SR), .PC_in(IF_Reg_PC_out),
		.WB_EN(WB_EN), .MEM_R_EN(MEM_R_EN), .MEM_W_EN(MEM_W_EN), .B(B), .S(S), .EXE_CMD(EXE_CMD), .Val_Rn(Val_Rn), .Val_Rm(Val_Rm), .imm(imm), .Shift_operand(Shift_operand), .Signed_imm_24(Signed_imm_24), .Dest(Dest), .src1(src1), .src2(src2), .Two_src(Two_src), .destAddress(destAddress), .PC(ID_Stage_PC)
	);

	ID_Stage_Reg id_stage_reg(
		.clk(CLOCK_50), .rst(rstSwitch), .flush(B), .WB_EN_IN(WB_EN), .MEM_R_EN_IN(MEM_R_EN), .MEM_W_EN_IN(MEM_W_EN), .B_IN(B), .S_IN(S), .EXE_CMD_IN(EXE_CMD), .PC_in(ID_Stage_PC), .Val_Rn_IN(Val_Rn), .Val_Rm_IN(Val_Rm), .imm_IN(imm), .Shift_operand_IN(Shift_operand), .Signed_imm_24_IN(Signed_imm_24), .Dest_IN(Dest),
		.WB_EN(ID_out_WB_EN), .MEM_R_EN(ID_out_MEM_R_EN), .MEM_W_EN(ID_out_MEM_W_EN), .B(ID_out_B), .S(ID_out_S), .EXE_CMD(ID_out_EXE_CMD), .Val_Rm(ID_out_Val_Rm), .Val_Rn(ID_out_Val_Rn), .imm(ID_out_imm), .Shift_operand(ID_out_Shift_operand), .Signed_imm_24(ID_out_Signed_imm_24), .Dest(ID_out_Dest), .PC(ID_out_PC)
		, .SR_In(SR), .SR(ID_SR)
	);

	EXE_Stage exe_stage(
		.clk(CLOCK_50), .EXE_CMD(ID_out_EXE_CMD), .MEM_R_EN(ID_out_MEM_R_EN), .MEM_W_EN(ID_out_MEM_W_EN), .PC(ID_out_PC), .Val_Rn(ID_out_Val_Rn), .Val_Rm(ID_out_Val_Rm), .imm(ID_out_imm), .Shift_operand(ID_out_imm), .Signed_imm_24(ID_out_Signed_imm_24), .SR(ID_SR),
  	.ALU_result(ALU_result), .Br_addr(Br_addr), .status(status)
	);
	EXE_Stage_Reg exe_stage_reg(
  	.clk(CLOCK_50), .rst(rstSwitch), .WB_en_in(ID_out_WB_EN), .MEM_R_EN_in(ID_out_MEM_R_EN), .MEM_W_EN_in(ID_out_MEM_W_EN), .ALU_result_in(ALU_result), .ST_val_in(ID_out_Val_Rm), .Dest_in(ID_out_Dest),
  	.WB_en(EXE_Reg_out_WB_EN), .MEM_R_EN(EXE_Reg_out_MEM_R_EN), .MEM_W_EN(EXE_Reg_out_MEM_W_EN), .ALU_result(EXE_Reg_out_ALU_result), .ST_val(EXE_Reg_out_ST_val), .Dest(EXE_Reg_out_Dest)
	);

	MEM_Stage mem_stage(
		.clk(CLOCK_50), .MEMread(EXE_Reg_out_MEM_R_EN), .MEMwrite(EXE_Reg_out_MEM_W_EN), .address(EXE_Reg_out_ALU_result), .data(EXE_Reg_out_ST_val),
		.MEM_result(MEM_Stage_out_MEM_result)
	);

	MEM_Stage_Reg mem_stage_reg(
		.clk(CLOCK_50), .rst(rstSwitch), .WB_en_in(EXE_Reg_out_WB_EN), .MEM_R_en_in(EXE_Reg_out_MEM_R_EN), .ALU_result_in(EXE_Reg_out_ALU_result), .Mem_read_value_in(MEM_Stage_out_MEM_result), .Dest_in(EXE_Reg_out_Dest),
		.WB_en(MEM_Stage_out_WB_EN), .MEM_R_en(MEM_Stage_out_MEM_R_EN), .ALU_result(MEM_Stage_Reg_out_ALU_result), .Mem_read_value(MEM_Stage_Reg_out_MEM_read_value), .Dest(MEM_Stage_Reg_out_Dest)
	);

	WB_Stage wb_stage(
		.ALU_result(MEM_Stage_Reg_out_ALU_result), .MEM_result(MEM_Stage_Reg_out_MEM_read_value), .MEM_R_en(MEM_Stage_out_MEM_R_EN),
		.out(Result_WB)
	);

	Hazard_Detection_Unit hazard_detection_unit(
		.src1(src1), .src2(src2), .Exe_Dest(ID_out_Dest), .Exe_WB_en(ID_out_WB_EN), .Two_src(Two_src), .Mem_Dest(EXE_Reg_out_Dest), .Mem_WB_EN(EXE_Reg_out_WB_EN),
		.hazard_detected(hazard)
	);

	reg4neg SReg(
		.clk(CLOCK_50), .rst(rstSwitch), .en(S), .reg_in(status),
		.reg_out(SR)
	);

	// assign LEDR = EXE_Reg_out_ALU_result;
	// assign GPIO_0 = EXE_Reg_out_ALU_result;
	// assign GPIO_1 = {EXE_Reg_out_WB_EN, EXE_Reg_out_MEM_R_EN, EXE_Reg_out_MEM_W_EN, EXE_Reg_out_ST_val,EXE_Reg_out_Dest};
	// assign GPIO_1 = {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD};
	
endmodule