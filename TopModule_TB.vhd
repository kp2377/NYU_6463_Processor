LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TopModule_TB IS
	PORT
	(
		clr_TM        : IN STD_LOGIC;
		CLK1       : IN STD_LOGIC;
		
		CLK_CHOICE_TM : IN STD_LOGIC;
		clk_manual_TM : IN STD_LOGIC;
		ed_TM         : IN STD_LOGIC;
		ud_TM         : IN STD_LOGIC;
		
		Data_in_TM    : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		UKEY_in_TM    : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
	
		UKEY_out   : OUT STD_LOGIC_VECTOR (127 DOWNTO 0);
		DD_OUT     : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		output     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Enc_output : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		Dec_output : OUT STD_LOGIC_VECTOR (63 DOWNTO 0)

	);
END TopModule_TB;

ARCHITECTURE Behavioral OF TopModule_TB IS
	COMPONENT ALU
		PORT
		(
			SrcA       : IN std_logic_vector(31 DOWNTO 0);
			SrcB       : IN std_logic_vector(31 DOWNTO 0);
			ALUControl : IN std_logic_vector(2 DOWNTO 0);
			ALUResult  : OUT std_logic_vector(31 DOWNTO 0);
			Zero       : OUT std_logic
		);
	END COMPONENT;
	COMPONENT BranchAddress
		PORT
		(
			in1      : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			PCPlus4  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			PCBranch : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT DataMemory
		PORT
		(
			clk    : IN STD_LOGIC;
			clr    : IN STD_LOGIC;
			A      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			WD     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			D_IN   : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			WE     : IN STD_LOGIC;
			UKEY   : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			RD     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			E_D    : IN STD_LOGIC;
			EncMSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			EncLSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DecMSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DecLSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT InstructionMemory
		PORT
		(
			A  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RD : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT Lasttwobits
		PORT
		(
			SignImm : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			output  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MUX32
		PORT
		(
			in1    : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			in2    : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			sel    : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MUX5
		PORT
		(
			in1    : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			in2    : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			sel    : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MUX3
		PORT
		(
			in1    : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			in2    : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			sel    : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT NextPCAdder
		PORT
		(
			PC        : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			add_input : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			PCPLUS4   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT PC
		PORT
		(
			din    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			clk    : IN STD_LOGIC;
			clr    : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT SignExtend
		PORT
		(
			Imm     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			SignImm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT controlUnit
		PORT
		(
			Op         : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			Funct      : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			MemtoReg   : OUT STD_LOGIC;
			MemWrite   : OUT STD_LOGIC;
			Branch     : OUT STD_LOGIC;
			ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			ALUSrc     : OUT STD_LOGIC;
			RegDst     : OUT STD_LOGIC;
			RegWrite   : OUT STD_LOGIC;
			SHRControl : OUT STD_LOGIC;
			Jump       : OUT STD_LOGIC;
			HALT       : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT registerfile
		PORT
		(
			A1  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			A2  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			A3  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			WD3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			WE3 : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			RD1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RD2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	
	Signal clk          : STD_LOGIC;
	SIGNAL i_cnt2       : std_logic_vector(31 DOWNTO 0) := x"00000000";
	SIGNAL i_cnt3       : INTEGER                       := 0;
	-----------------MUX_Jump-----------------------
	SIGNAL inPC         : STD_LOGIC_VECTOR(31 DOWNTO 0);
	---------------------------------------------------
	------------------MUX_PC_Branch---------------
	SIGNAL PCBranch_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PCSrc        : STD_LOGIC;
	----------------------------------------------------
	SIGNAL outPC        : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
	SIGNAL Instr        : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
	-------------------------MUX_RegDst-----------------------
	SIGNAL WriteReg     : STD_LOGIC_VECTOR(4 DOWNTO 0);
	----------------------------------------------------------
	--------------------------MUX_DataMemory------------------
	SIGNAL Result       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	----------------------------------------------------------
	-------------Control------------------
	SIGNAL MemtoReg     : STD_LOGIC;
	SIGNAL MemWrite     : STD_LOGIC;
	SIGNAL Branch       : STD_LOGIC;
	SIGNAL ALUControl   : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL ALUSrc       : STD_LOGIC;
	SIGNAL RegDst       : STD_LOGIC;
	SIGNAL RegWrite     : STD_LOGIC;
	SIGNAL SHRControl   : STD_LOGIC;
	SIGNAL Jump         : STD_LOGIC;
	SIGNAL HALT         : STD_LOGIC;
	-----------------------------------------
	-----------------MUX_SHRControl-----------------------
	SIGNAL SHRout       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Imm          : STD_LOGIC_VECTOR(31 DOWNTO 0);
	---------------------------------------------------
	-----------------ALU-------------------------
	SIGNAL SrcA         : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DataOut2     : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SrcB         : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALUResult    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Zero         : STD_LOGIC;
	-----------------------------------------------
	--------------------------DataMemory-------------------------
	SIGNAL ReadData     : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL d_input      : STD_LOGIC_VECTOR(63 DOWNTO 0);  
	SIGNAL UKEY         : STD_LOGIC_VECTOR(127 DOWNTO 0); 
	-----------------------------------------------------
	------------------SignExtend---------------
	SIGNAL SignImm      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	----------------------------------------------------
	------------------LasttwoBits---------------
	SIGNAL BR1          : STD_LOGIC_VECTOR(31 DOWNTO 0);
	----------------------------------------------------
	------------------PCBranch---------------
	SIGNAL PCPlus4      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PCBranch     : STD_LOGIC_VECTOR(31 DOWNTO 0);
	----------------------------------------------------
	------------------Jump---------------
	SIGNAL Jump_NextPC  : STD_LOGIC_VECTOR(31 DOWNTO 0);
	----------------------------------------------------
	------------------HALT---------------
	SIGNAL HaltOut      : STD_LOGIC_VECTOR(2 DOWNTO 0);
	----------------------------------------------------

	SIGNAL ENCM    : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
	SIGNAL ENCL    : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
	SIGNAL DECM    : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
	SIGNAL DECL    : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
	
	
BEGIN
	PCSrc       <= Branch AND Zero;
	Jump_NextPC <= PCPlus4(31 DOWNTO 28) & Instr(25 DOWNTO 0) & "00";
	Imm         <= x"0000" & Instr(15 DOWNTO 0);
	MUX_PC_Branch : MUX32 PORT MAP
		(in1 => PCPlus4, in2 => PCBranch, sel => PCSrc, output => PCBranch_out);
	MUX_PC_Jump : MUX32 PORT
	MAP (in1 => PCBranch_out, in2 => Jump_NextPC, sel => Jump, output => inPC);
	PC_Clock : PC PORT
	MAP (din => inPC, clk => clk, clr => clr_TM, output => outPC);
	InstructionMemorycomponent : InstructionMemory PORT
	MAP (A => outPC, RD => Instr);
	registerfilecomponent : registerfile PORT
	MAP (A1 => Instr(25 DOWNTO 21), A2 => Instr(20 DOWNTO 16), A3 => WriteReg, WD3 => Result, WE3 => RegWrite, clk => clk,
	RD1 => SrcA, RD2 => DataOut2
	);
	MUX_ALUSrc : MUX32 PORT
	MAP (in1 => DataOut2, in2 => SignImm, sel => ALUSrc, output => SHRout);
	MUX_SHRControl : MUX32 PORT
	MAP (in1 => SHRout, in2 => Imm, sel => SHRControl, output => SrcB);
	ALUcomponent : ALU PORT
	MAP (SrcA => SrcA, SrcB => SrcB, ALUControl => ALUControl, ALUResult => ALUResult, Zero => Zero);
	controlUnitcomponent : controlUnit PORT
	MAP (Op => Instr(31 DOWNTO 26), Funct => Instr(5 DOWNTO 0), MemtoReg => MemtoReg, MemWrite => MemWrite, Branch => Branch,
	ALUControl => ALUControl, ALUSrc => ALUSrc, RegDst => RegDst, RegWrite => RegWrite,
	SHRControl => SHRControl, Jump => Jump, HALT => HALT);
	MUX_RegDst : MUX5 PORT
	MAP (in1 => Instr(20 DOWNTO 16), in2 => Instr(15 DOWNTO 11), sel => RegDst, output => WriteReg);
	DataMemorycomponent : DataMemory PORT
	MAP (clk => clk, clr => clr_TM, A => ALUResult, WD => DataOut2, D_IN => d_input, WE => MemWrite, UKEY => UKEY, RD => ReadData, E_D => ed_TM, EncMSB => ENCM, EncLSB => ENCL, DecMSB => DECM, DecLSB => DECL);
	MUX_DataMemory : MUX32 PORT
	MAP (in1 => ALUResult, in2 => ReadData, sel => MemtoReg, output => Result);
	SignExtendcomponent : SignExtend PORT
	MAP (Imm => Instr(15 DOWNTO 0), SignImm => SignImm);
	Lasttwobitscomponent : Lasttwobits PORT
	MAP (SignImm => SignImm, output => BR1);
	NextPCAddercomponent : NextPCAdder PORT
	MAP (PC => outPC, add_input => HaltOut, PCPLUS4 => PCPlus4);
	MUX_Halt : MUX3 PORT
	MAP (in1 => "100", in2 => "000", sel => HALT, output => HaltOut);
	BranchAddresscomponent : BranchAddress PORT
	MAP (in1 => BR1, PCPlus4 => PCPlus4, PCBranch => PCBranch);
	
	--reset_options : PROCESS (CLK_CHOICE_TM, clr_TM, ed_TM, ud_TM, Data_in_TM, CLK1, clk_manual_TM)
	--BEGIN
	
		--IF (clr_TM = '1') THEN
--			IF (ud = '0') THEN
		--	 	UKEY <= UKEY_in_TM;
		--	 	d_input <= Data_in_TM; 
--			ELSIF (ud = '1') THEN
--				d_input <= TOPM_Data_in;
--				UKEY <= UKEY_in;
--			END IF;	   
		--ELSE
		    
		    UKEY <= UKEY_in_TM;
            d_input <= Data_in_TM;
		    --IF(ed_TM = '1')THEN
--		       UKEY <= x"00000000000000000000000000000000";
 --              d_input <= x"18C7C99A97F52AE0"; 
           -- ELSE
           --    UKEY <= x"00000000000000000000000000000000";
           --    d_input <= x"6320e1d05c1c3a15"; 
           -- END IF;
		
			--IF (CLK_CHOICE_TM = '1') THEN
				clk <= CLK1;
				--IF(ed = '0')THEN
				   Enc_output <= ENCM & ENCL;
				--ELSE
				   Dec_output <= DECM & DECL;
				--END IF;
				output <= Result;
			--ELSE
				--clk <= clk_manual_TM;
				
			--END IF;
		--END IF;
	--END PROCESS;

    UKEY_out <= UKEY;
    DD_OUT <= d_input;
    
END Behavioral;