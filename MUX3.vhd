----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 10:11:23 PM
-- Design Name: 
-- Module Name: MUX1 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX3 is
    Port ( 
           in1 : in STD_LOGIC_VECTOR (2 downto 0);
           in2 : in STD_LOGIC_VECTOR (2 downto 0);    
           sel: in STD_LOGIC;
           output : out STD_LOGIC_VECTOR(2 downto 0)
         );
end MUX3;

architecture Behavioral of MUX3 is

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