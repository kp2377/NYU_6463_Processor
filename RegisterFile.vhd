--VHDL Code for the RF (Register File) of the MIPS Processor--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity registerfile is

PORT (
        A1: in STD_LOGIC_VECTOR(4 DOWNTO 0);--addr port 1 to read reg, reg content goes to RD1
        A2: in STD_LOGIC_VECTOR(4 DOWNTO 0);--addr port 2 to read reg, reg content goes to RD2
        A3: in STD_LOGIC_VECTOR(4 DOWNTO 0);--addr port 3 to write data in WD3 into register 
        WD3: in STD_LOGIC_VECTOR(31 DOWNTO 0);--data to be written into reg specified by A3
        WE3: in STD_LOGIC;--write enable for A3 and WD3
        clk: in STD_LOGIC;--clock
        
        RD1: out STD_LOGIC_VECTOR(31 DOWNTO 0);--shows reg content of the reg specified by A1 
        RD2: out STD_LOGIC_VECTOR(31 DOWNTO 0)--shows reg content of the reg specified by A2 
);
end registerfile;

architecture Behavioral of registerfile is
-----//signals//----------
--32x32 ram is the reg file 
--so totally 32 registers and each reg is 32bit wide
--since 5 bits were allocated to the regs in the ISA, we have 32 regs
TYPE ram IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL regfile:                                               
ram:=ram'(  
            x"00000000", x"00000000", x"00000000", x"00000000",
            x"00000000", x"00000000", x"00000000", x"00000000",
            x"00000000", x"00000000", x"00000000", x"00000000",
            x"00000000", x"00000000", x"00000000", x"00000000",
            x"00000000", x"00000000", x"00000000", x"00000000",
            x"00000000", x"00000000", x"00000000", x"00000000",
            x"00000000", x"00000000", x"00000000", x"00000000",
            x"00000000", x"00000000", x"00000000", x"00000000"
         );
---------------------------
begin
----------//code//---------

RD1<=regfile(CONV_INTEGER(A1));--read data from reg specified by addr A1
RD2<=regfile(CONV_INTEGER(A2));

process(clk)
begin
    if (clk'EVENT AND clk='1') then
        if(WE3='1')then                 --write enable
            regfile(CONV_INTEGER(A3))<=WD3; --write data in WD3 into reg specified by addr A3
            --read data from reg specified by addr A2
        end if;
    end if;
end process;

end Behavioral;
