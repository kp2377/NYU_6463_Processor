----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 06:23:24 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is

PORT (
        din: in STD_LOGIC_VECTOR(31 DOWNTO 0);
        clk: in STD_LOGIC;
        clr: in STD_LOGIC;
        output: out STD_LOGIC_VECTOR(31 DOWNTO 0));
end PC;

architecture Behavioral of PC is
begin
PROCESS (clr, clk)  BEGIN
  IF (clr='1') THEN 
        output <= x"00000000";
  ELSIF (clk'EVENT AND clk='1') THEN 
        output<=din;
  END IF;                                      
END PROCESS;                                  

end Behavioral;