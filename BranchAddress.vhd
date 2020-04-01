----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 07:17:36 PM
-- Design Name: 
-- Module Name: BranchAddress - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

entity BranchAddress is
    Port ( in1 : in STD_LOGIC_VECTOR (31 downto 0);
           PCPlus4 : in STD_LOGIC_VECTOR (31 downto 0);
           PCBranch : out STD_LOGIC_VECTOR (31 downto 0));
end BranchAddress;

architecture Behavioral of BranchAddress is

begin

PCBranch <= in1+ PCPlus4;

end Behavioral;