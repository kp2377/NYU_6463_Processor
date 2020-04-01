LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY TopModule IS
	PORT
	(
		clr        : IN STD_LOGIC;
		CLK1       : IN STD_LOGIC;
		clk        : INOUT STD_LOGIC;
		CLK_CHOICE : IN STD_LOGIC;
		clk_manual : IN STD_LOGIC;

		ed         : IN STD_LOGIC;
		ml         : IN STD_LOGIC;
		ud         : IN STD_LOGIC;

		CA         : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		AN         : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);

		output1    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		SEL        : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		SEL_OP     : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		Data_in    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		LED16_R    : OUT STD_LOGIC;
		LED16_G    : OUT STD_LOGIC;
		LED16_B    : OUT STD_LOGIC;
		LED17_R    : OUT STD_LOGIC;
		LED17_G    : OUT STD_LOGIC;
		LED17_B    : OUT STD_LOGIC
	);
END TopModule;
ARCHITECTURE Behavioral OF TopModule IS
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
	COMPONENT Hex2LED
		PORT
		(
			CLK : IN STD_LOGIC;
			X   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			Y   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
	END COMPONENT;
	SIGNAL clk_sig      : STD_LOGIC                     := '0';
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
	--------------------7segDisplay-----------------------
--	SIGNAL d            : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"00";
	TYPE arr IS ARRAY(0 TO 22) OF std_logic_vector(7 DOWNTO 0);
	SIGNAL NAME    : arr;
	SIGNAL Val     : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL HexVal  : std_logic_vector(31 DOWNTO 0);
	SIGNAL slowCLK : std_logic                     := '0';
	SIGNAL i_cnt   : std_logic_vector(19 DOWNTO 0) := x"00000";
	SIGNAL DISP  : std_logic_vector(31 DOWNTO 0);
	----------------------------------------------------
	----------------LED INDICATORS----------------------
	SIGNAL LED     : STD_LOGIC_VECTOR(5 DOWNTO 0)  := "000000";
	SIGNAL SEL_LED : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
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
	MAP (din => inPC, clk => clk, clr => clr, output => outPC);
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
	MAP (clk => clk, clr => clr, A => ALUResult, WD => DataOut2, D_IN => d_input, WE => MemWrite, UKEY => UKEY, RD => ReadData, E_D => ed, EncMSB => ENCM, EncLSB => ENCL, DecMSB => DECM, DecLSB => DECL);
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

	output1 <= Result;
--	d <= Data_in;
	SEL_LED <= SEL;

	clock_division : PROCESS (CLK1)
	BEGIN
		IF (rising_edge(CLK1)) THEN
			IF (i_cnt = x"61A8") THEN
				slowCLK <= NOT slowCLK;
				i_cnt   <= x"00000";
			ELSE
				i_cnt <= i_cnt + '1';
			END IF;
		END IF;
	END PROCESS;
	clock_division2 : PROCESS (CLK1)
	BEGIN
		IF (rising_edge(CLK1)) THEN
			IF (i_cnt2 = x"00000010") THEN
				clk_sig <= NOT clk_sig;
				i_cnt2  <= x"00000000";
			ELSE
				i_cnt2 <= i_cnt2 + '1';
			END IF;
		END IF;
	END PROCESS;
	timer_inc_process : PROCESS (slowCLK)
	BEGIN
		IF (rising_edge(slowCLK)) THEN
			IF (Val = "1000") THEN
				Val <= "0001";
			ELSE
				Val <= Val + '1';
			END IF;
		END IF;
	END PROCESS;
	WITH Val SELECT
		AN <= "01111111" WHEN "0001",
		"10111111" WHEN "0010",
		"11011111" WHEN "0011",
		"11101111" WHEN "0100",
		"11110111" WHEN "0101",
		"11111011" WHEN "0110",
		"11111101" WHEN "0111",
		"11111110" WHEN "1000",
		"11111111" WHEN OTHERS;
	WITH Val SELECT
		CA <= NAME(0) WHEN "0001",
		NAME(1) WHEN "0010",
		NAME(2) WHEN "0011",
		NAME(3) WHEN "0100",
		NAME(4) WHEN "0101",
		NAME(5) WHEN "0110",
		NAME(6) WHEN "0111",
		NAME(7) WHEN "1000",
		NAME(0) WHEN OTHERS;
	LED_INDICATOR : PROCESS (outPC)
	BEGIN
		IF (outPC >= x"00000000" AND outPC <= x"000000AB") THEN
			LED                                <= "100000";
		END IF;
		IF (outPC >= x"000000AC" AND outPC <= x"000000F3") THEN
			LED                                <= "010000";
		END IF;
		IF (outPC >= x"000000F4" AND outPC <= x"00000173") THEN
			LED                                <= "001000";
		END IF;
		IF (outPC >= x"00000174" AND outPC <= x"000001AC") THEN
			LED                                <= "000100";
		END IF;
		IF (outPC >= x"000001AD" AND outPC <= x"000001CB") THEN
			LED                                <= "000010";
		END IF;
		IF (outPC >= x"000001CC" AND outPC <= x"0000023F") THEN
			LED                                <= "000001";
		END IF;
		IF (outPC >= x"00000240" AND outPC <= x"00000253") THEN
			LED                                <= "110000";
		END IF;
		IF (outPC >= x"00000254" AND outPC <= x"0000029B") THEN
			LED                                <= "111111";
		END IF;
	END PROCESS;
	LED16_R <= LED(0);
	LED16_G <= LED(1);
	LED16_B <= LED(2);
	LED17_R <= LED(3);
	LED17_G <= LED(4);
	LED17_B <= LED(5);
	
	reset_options : PROCESS (CLK_CHOICE, ed, ml, clr, SEL, ud, Data_in, clk)
	BEGIN
	
		IF (clr = '1') THEN
			--DISP <= x"0000" & SEL_LED & x"0" & Data_in
			
			IF (ud = '0') THEN
				IF (SEL = "0000") THEN
					UKEY(7 DOWNTO 0) <= Data_in;
				ELSIF (SEL = "0001") THEN
					UKEY(15 DOWNTO 0) <= Data_in & UKEY(7 downto 0);
				ELSIF (SEL = "0011") THEN
					UKEY(23 DOWNTO 0) <= Data_in & UKEY(15 downto 0);
				ELSIF (SEL = "0010") THEN
					UKEY (31 DOWNTO 0) <= Data_in & UKEY(23 downto 0);
				ELSIF (SEL = "0110") THEN
					UKEY (39 DOWNTO 0) <= Data_in & UKEY(31 downto 0);
				ELSIF (SEL = "0111") THEN
					UKEY (47 DOWNTO 0) <= Data_in & UKEY(39 downto 0);
				ELSIF (SEL = "0101") THEN
					UKEY (55 DOWNTO 0) <= Data_in & UKEY(47 downto 0);
				ELSIF (SEL = "0100") THEN
					UKEY (63 DOWNTO 0) <= Data_in & UKEY(55 downto 0);
				ELSIF (SEL = "1100") THEN
					UKEY (71 DOWNTO 0) <= Data_in & UKEY(63 downto 0);
				ELSIF (SEL = "1101") THEN
					UKEY (79 DOWNTO 0) <= Data_in & UKEY(71 downto 0);
				ELSIF (SEL = "1111") THEN
					UKEY (87 DOWNTO 0) <= Data_in & UKEY(79 downto 0);
				ELSIF (SEL = "1110") THEN
					UKEY (95 DOWNTO 0) <= Data_in & UKEY(87 downto 0);
				ELSIF (SEL = "1010") THEN
					UKEY (103 DOWNTO 0) <= Data_in & UKEY(95 downto 0);
				ELSIF (SEL = "1011") THEN
					UKEY (111 DOWNTO 0) <= Data_in & UKEY(103 downto 0);
				ELSIF (SEL = "1001") THEN
					UKEY (119 DOWNTO 0) <= Data_in & UKEY(111 downto 0);
				ELSIF (SEL = "1000") THEN
					UKEY (127 DOWNTO 0) <= Data_in & UKEY(119 downto 0);	
				END IF;
				
				IF(ml = '0') THEN 
                  HexVal <= UKEY(31 DOWNTO 0);
                ELSIF(ml = '1') THEN
                  HexVal <= UKEY(63 DOWNTO 32);
                END IF;  
                
			ELSIF (ud = '1') THEN
				IF (SEL = "0000") THEN 
					d_input (7 DOWNTO 0) <= Data_in;
				ELSIF (SEL = "0001") THEN 
					d_input (15 DOWNTO 0) <= Data_in & d_input (7 DOWNTO 0);
				ELSIF (SEL = "0011") THEN 
					d_input (23 DOWNTO 0) <= Data_in & d_input (15 DOWNTO 0);
				ELSIF (SEL = "0010") THEN 
					d_input (31 DOWNTO 0) <= Data_in & d_input (23 DOWNTO 0);
				ELSIF (SEL = "0110") THEN 
					d_input (39 DOWNTO 0) <= Data_in & d_input (31 DOWNTO 0);
				ELSIF (SEL = "0111") THEN 
					d_input (47 DOWNTO 0) <= Data_in & d_input (39 DOWNTO 0);
				ELSIF (SEL = "0101") THEN 
					d_input (55 DOWNTO 0) <= Data_in & d_input (47 DOWNTO 0);
				ELSIF (SEL = "0100") THEN 
					d_input (63 DOWNTO 0) <= Data_in & d_input (55 DOWNTO 0);	
				END IF;
				
				IF(ml = '0') THEN 
				  HexVal <= d_input(31 DOWNTO 0);
				ELSIF(ml = '1') THEN
				  HexVal <= d_input(63 DOWNTO 32);
				END IF;    
			END IF;
		   
		ELSE
			IF (CLK_CHOICE = '1') THEN
				clk <= clk_sig;
				IF (ed = '0') THEN
					IF (ml = '1') THEN
						HexVal <= ENCL;
					ELSE
						HexVal <= ENCM;
					END IF;
				ELSE
					IF (ml = '1') THEN
						HexVal <= DECL;
					ELSE
						HexVal <= DECM;
					END IF;
				END IF;
			ELSE
				clk    <= clk_manual;
				HexVal <= Result;
			END IF;
		END IF;
	END PROCESS;

	SEL_OP <= SEL_LED;

	CONV1 : Hex2LED PORT
	MAP
	(CLK => CLK1, X => HexVal(31 DOWNTO 28), Y => NAME(0));
	CONV2 : Hex2LED PORT
	MAP (CLK => CLK1, X => HexVal(27 DOWNTO 24), Y => NAME(1));
	CONV3 : Hex2LED PORT
	MAP (CLK => CLK1, X => HexVal(23 DOWNTO 20), Y => NAME(2));
	CONV4 : Hex2LED PORT
	MAP (CLK => CLK1, X => HexVal(19 DOWNTO 16), Y => NAME(3));
	CONV5 : Hex2LED PORT
	MAP (CLK => CLK1, X => HexVal(15 DOWNTO 12), Y => NAME(4));
	CONV6 : Hex2LED PORT
	MAP (CLK => CLK1, X => HexVal(11 DOWNTO 8), Y => NAME(5));
	CONV7 : Hex2LED PORT
	MAP (CLK => CLK1, X => HexVal(7 DOWNTO 4), Y => NAME(6));
	CONV8 : Hex2LED PORT
	MAP (CLK => CLK1, X => HexVal(3 DOWNTO 0), Y => NAME(7));
END Behavioral;