----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 10:40:01 PM
-- Design Name: 
-- Module Name: MUX2 - Behavioral
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

entity MUX5 is
    Port ( in1 : in STD_LOGIC_VECTOR (4 downto 0);
           in2 : in STD_LOGIC_VECTOR (4 downto 0);    
           sel: in STD_LOGIC;
           output : out STD_LOGIC_VECTOR(4 downto 0)
          );
end MUX5;

architecture Behavioral of MUX5 is

begin

process(in1,in2,sel) 
begin
      case sel is
            when '0' => output <= in1;
            when '1' => output <= in2;
            when others => output <= in1;
      end case;
end process;
     

end Behavioral;