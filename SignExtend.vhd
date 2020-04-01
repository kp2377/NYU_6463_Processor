----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 06:16:05 PM
-- Design Name: 
-- Module Name: SignExtend - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtend is

PORT (
       Imm: in STD_LOGIC_VECTOR(15 DOWNTO 0);
       SignImm: out STD_LOGIC_VECTOR(31 DOWNTO 0)
     );
end SignExtend;

architecture Behavioral of SignExtend is
begin

SignImm(15 downto 0) <= Imm(15 downto 0); 
with Imm(15) select		      
SignImm(31 downto 16) <= x"FFFF" when '1',
			             x"0000" when others;	

end Behavioral;