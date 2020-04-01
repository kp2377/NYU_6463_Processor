----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 06:27:09 PM
-- Design Name: 
-- Module Name: NextPCAdder - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL; 

entity NextPCAdder is
    Port ( PC : in STD_LOGIC_VECTOR (31 downto 0);
           add_input : in STD_LOGIC_VECTOR(2 downto 0);
           PCPLUS4 : out STD_LOGIC_VECTOR (31 downto 0));
end NextPCAdder;

architecture Behavioral of NextPCAdder is

begin

PCPLUS4 <= PC + (x"0000000" & '0' & add_input);

end Behavioral;