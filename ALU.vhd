library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


ENTITY ALU IS
	port (
            SrcA    : in  std_logic_vector(31 downto 0);
            SrcB    : in  std_logic_vector(31 downto 0);
            ALUControl     : in  std_logic_vector(2 downto 0);
            ALUResult : out std_logic_vector(31 downto 0);
            Zero   : out std_logic
		);                          --'1' if Op1<Op2. Used for BLT instruction
END ALU;


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



Architecture Behavioral of ALU is

signal z: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal shiftright: STD_LOGIC_VECTOR(31 DOWNTO 0);

begin


--rightshift--
WITH SrcB SELECT
   shiftright<=
	SrcA WHEN x"00000000",
	'0' & SrcA(31 DOWNTO 1) WHEN x"00000001",
	"00" & SrcA(31 DOWNTO 2) WHEN x"00000002",
	"000" & SrcA(31 DOWNTO 3) WHEN x"00000003",
	"0000" & SrcA(31 DOWNTO 4) WHEN x"00000004",
	"00000" & SrcA(31 DOWNTO 5) WHEN x"00000005",
	"000000" & SrcA(31 DOWNTO 6) WHEN x"00000006",
	"0000000" & SrcA(31 DOWNTO 7) WHEN x"00000007",
	"00000000" & SrcA(31 DOWNTO 8) WHEN x"00000008",
	"000000000" & SrcA(31 DOWNTO 9) WHEN x"00000009",
	"0000000000" & SrcA(31 DOWNTO 10) WHEN x"0000000A",
	"00000000000" & SrcA(31 DOWNTO 11) WHEN x"0000000B",
	"000000000000" & SrcA(31 DOWNTO 12) WHEN x"0000000C",
	"0000000000000" & SrcA(31 DOWNTO 13) WHEN x"0000000D",
	"00000000000000" & SrcA(31 DOWNTO 14) WHEN x"0000000E",
	"000000000000000" & SrcA(31 DOWNTO 15) WHEN x"0000000F",
	"0000000000000000" & SrcA(31 DOWNTO 16) WHEN x"00000010",
	"00000000000000000" & SrcA(31 DOWNTO 17) WHEN x"00000011",
	"000000000000000000" & SrcA(31 DOWNTO 18) WHEN x"00000012",
	"0000000000000000000" & SrcA(31 DOWNTO 19) WHEN x"00000013",
	"00000000000000000000" & SrcA(31 DOWNTO 20) WHEN x"00000014",
	"000000000000000000000" & SrcA(31 DOWNTO 21) WHEN x"00000015",
	"0000000000000000000000" & SrcA(31 DOWNTO 22) WHEN x"00000016",
	"00000000000000000000000" & SrcA(31 DOWNTO 23) WHEN x"00000017",
	"000000000000000000000000" & SrcA(31 DOWNTO 24) WHEN x"00000018",
	"0000000000000000000000000" & SrcA(31 DOWNTO 25) WHEN x"00000019",
	"00000000000000000000000000" & SrcA(31 DOWNTO 26) WHEN x"0000001A",
	"000000000000000000000000000" & SrcA(31 DOWNTO 27) WHEN x"0000001B",
	"0000000000000000000000000000" & SrcA(31 DOWNTO 28) WHEN x"0000001C",
	"00000000000000000000000000000" & SrcA(31 DOWNTO 29) WHEN x"0000001D",
	"000000000000000000000000000000" & SrcA(31 DOWNTO 30) WHEN x"0000001E",
	"0000000000000000000000000000000" & SrcA(31) WHEN x"0000001F",
	x"00000000" WHEN OTHERS;
-------------------------------------
with ALUControl select                         -- ALUControl signal comes from the CU depending on the current instruction
    ALUResult <= SrcA+SrcB when "001",
                 SrcA-SrcB when "011",
                 SrcA and SrcB when "101",
                 SrcA or SrcB when "111",
                 SrcA nor SrcB when "000",
                 shiftright when "010",             -- added extra, change it in the last
                 x"00000000" when others;	        -- error, halt

z<=SrcA-SrcB;

Zero <= '1' when ((ALUControl = "011") and (z = x"00000000")) else
        '1' when ((ALUControl = "110") and (z(31) = '0')) else
        '1' when ((ALUControl = "100") and (z /= x"00000000")) else
        '0' ;
                 
end Behavioral; 
