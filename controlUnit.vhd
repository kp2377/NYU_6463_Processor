----------------


-- OP Code and Function mapping(Hex):
-- HEX values
-- 00-0: do nothing
-- 00-1: Add
-- 00-3: Subtract
-- 00-5: AND
-- 00-7: OR
-- 00-9: NOR
-- 01: Add Immidiate(ADDI)
-- 02: Subtract immidiate(SUBI)
-- 03: And Immidiate(ANDI)
-- 04: OR Immidiate(ORI)
-- 05: Shift Right Immidiate(SHR)
-- 07: Load Byte(LB)
-- 08: Store Byte(SB)
-- 09: Branch if less than(BLT)
-- 0A: Branch if equal(BEQ)
-- 0B: branch if not equal(BNE)
-- 0C: Jump(JMP)
-- 3F: Halt(HAL)



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;



entity controlUnit is
---------//ports//---------
PORT (
Op: in STD_LOGIC_VECTOR(5 DOWNTO 0);--The opcode from the current instruction
Funct: in STD_LOGIC_VECTOR(5 DOWNTO 0);
--Control signals branching from the CU go into different muxes inside the processor
--which select specific data paths depending on the instruction
MemtoReg: out STD_LOGIC; 
MemWrite: out STD_LOGIC;
Branch: out STD_LOGIC;
ALUControl: out STD_LOGIC_VECTOR(2 DOWNTO 0);
ALUSrc: out STD_LOGIC;
RegDst: out STD_LOGIC;
RegWrite: out STD_LOGIC;
SHRControl: out STD_LOGIC; 
Jump:	out STD_LOGIC;
HALT : out STD_LOGIC
);
end controlUnit;

architecture Behavioral of controlUnit is--VHDL Code for the CU (Control Unit) of the MIPS Processor--
-----------ture Behavioral of controlunit is
----------//signals//------------
Signal ALUc: STD_LOGIC_VECTOR(2 downto 0);
---------------------------------
begin
---------//code//----------------

ALUc <= "000" when Funct = "001001" 
              else Funct(2 downto 0);

----------ALUControl--ALUOp--------------------------
with Op select
ALUControl(2 downto 0) <= 	ALUc when "000000",
                            "001" when "000001",  --
                            "011" when "000010",  --
                            "101" when "000011",  --
                            "111" when "000100",  --
                            "010" when "000101",  --
                            "001" when "000111",
                            "001" when "001000",	
                            "110" when "001001",
                            "011" when "001010",	
                            "100" when "001011",			
                            "110" when others;  -- do not understand what this line wants to say??
----------MemtoReg--isLoad-----------------------											
with Op select
MemtoReg <= 	'1' when "000111",  --07
				'0' when others;
----------MemWrite--isStore---------------------
with Op select
MemWrite <= 	'1' when "001000", --08
				'0' when others;
-----------Branch----------------------------------

Branch <= 	'1' when ( (op = "001001") or (op = "001010") or (op = "001011")) else
		    '0';

---------
with Op select
Jump <= 	'1' when "001100",  --0C
			'0' when others;
-----------RegDst---(!iType)-------------------------------------
with Op select
RegDst <= 	'1' when "000000",
            '0' when others;			
----------SHRControl--------------------
with Op select
SHRControl <= 	'1' when "000101",
                
                '0' when others;		            	
------------ALUSrc----------------------------------------------
with Op select
ALUSrc <= 	'0' when "000000",
            '1' when "000001",
            '1' when "000010",
            '1' when "000011",
            '1' when "000100",
            '1' when "000111",
            '1' when "001000",
            '0' when others;	
------------RegWrite---------------------------------------------
with Op select
RegWrite <= 	'1' when "000000",
                '1' when "000001",
                '1' when "000010",
                '1' when "000011",
                '1' when "000100",
                '1' when "000101",
                '1' when "000111",
                '0' when others;
----------------------------------------------------------------

----------HALT--------------------
with Op select
HALT  <= '1' when "111111",
         '0' when others;		          

end Behavioral;
