----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 07:05:45 PM
-- Design Name: 
-- Module Name: Lasttwobits - Behavioral
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

entity Lasttwobits is
    Port ( SignImm : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end Lasttwobits;

architecture Behavioral of Lasttwobits is

begin

output <= SignImm(29 downto 0) & "00";

end Behavioral;
