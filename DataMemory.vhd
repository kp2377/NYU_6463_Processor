----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 06:48:25 PM
-- Design Name: 
-- Module Name: DataMemory - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY DataMemory IS

	PORT
	(
		clk    : IN STD_LOGIC;
		clr    : IN STD_LOGIC;
		A      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		WD     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		D_IN   : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		WE     : IN STD_LOGIC;
		UKEY   : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		RD     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		E_D     : IN STD_LOGIC;
		EncMSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		EncLSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DecMSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DecLSB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END DataMemory;

ARCHITECTURE Behavioral OF DataMemory IS

	TYPE ram IS ARRAY (0 TO 263) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dmem :
	ram := ram'(
		--                "11110000", --Data1 -- 31 to 24 --x"FE"     
		--                "00000000", --Data1 -- 23 to 16 --x"DC"
		--                "00000000", --Data1 -- 15 to 8  --x"BA"
		--                "00000000", --Data1 --  7 to 0  --x"98"

		--                "00001111", --Data2 -- 31 to 24 --x"76"  
		--                "00000000", --Data2 -- 23 to 16 --x"54"  
		--                "00000000", --Data2 -- 15 to 8  --x"32"  
		--                "00000000", --Data2 --  7 to 0  --x"10"  

--		"10111001", --Data1 -- 31 to 24 --x"b9"     
--		"00111100", --Data1 -- 23 to 16 --x"3c"
--		"10110110", --Data1 -- 15 to 8  --x"B6"
--		"11001011", --Data1 --  7 to 0  --x"cb"

--		"01110101", --Data2 -- 31 to 24 --x"75"  
--		"10001011", --Data2 -- 23 to 16 --x"8b"  
--		"11111000", --Data2 -- 15 to 8  --x"f8"  
--		"01010000", --Data2 --  7 to 0  --x"50"  

        "00000000", -- Data1 -- DIN -- 63 to 56 
        "00000000", -- Data1 -- DIN -- 55 to 48 
        "00000000", -- Data1 -- DIN -- 47 to 40 
        "00000000", -- Data1 -- DIN -- 39 to 32 
                    
        "00000000", -- Data1 -- DIN -- 31 to 24 
        "00000000", -- Data1 -- DIN -- 23 to 16 
        "00000000", -- Data1 -- DIN -- 15 to 8 
        "00000000", -- Data1 -- DIN -- 7  to 0 
        
		"00000000", --Data3-- 31 to 24 -- x"00000000"
		"00000000", --Data3-- 23 to 16
		"00000000", --Data3-- 15 to 8
		"00000000", --Data3--  7 to 0

		"00000000", --Data4-- 31 to 24 -- x"00000000"
		"00000000", --Data4-- 23 to 16
		"00000000", --Data4-- 15 to 8
		"00000000", --Data4--  7 to 0

		"01000110", --Data5-- 31 to 24 -- x"46F8E8C5"
		"11111000", --Data5-- 23 to 16
		"11101000", --Data5-- 15 to 8
		"11000101", --Data5--  7 to 0

		"01000110", --Data6-- 31 to 24 -- x"460C6085"
		"00001100", --Data6-- 23 to 16
		"01100000", --Data6-- 15 to 8
		"10000101", --Data6--  7 to 0

		"01110000", --Data7-- 31 to 24 -- x"70F83B8A"
		"11111000", --Data7-- 23 to 16
		"00111011", --Data7-- 15 to 8
		"10001010", --Data7--  7 to 0

		"00101000", --Data8-- 31 to 24 -- x"284B8303"
		"01001011", --Data8-- 23 to 16
		"10000011", --Data8-- 15 to 8
		"00000011", --Data8--  7 to 0

		"01010001", --Data9-- 31 to 24 -- x"513E1454"
		"00111110", --Data9-- 23 to 16
		"00010100", --Data9-- 15 to 8
		"01010100", --Data9--  7 to 0

		"11110110", --Data10-- 31 to 24 -- x"F621ED22"
		"00100001", --Data10-- 23 to 16
		"11101101", --Data10-- 15 to 8
		"00100010", --Data10--  7 to 0

		"00110001", --Data11-- 31 to 24 -- x"3125065D"
		"00100101", --Data11-- 23 to 16
		"00000110", --Data11-- 15 to 8
		"01011101", --Data11--  7 to 0

		"00010001", --Data12-- 31 to 24 -- x"11A83A5D"
		"10101000", --Data12-- 23 to 16
		"00111010", --Data12-- 15 to 8
		"01011101", --Data12--  7 to 0

		"11010100", --Data13-- 31 to 24 -- x"D427686B"
		"00100111", --Data13-- 23 to 16
		"01101000", --Data13-- 15 to 8
		"01101011", --Data13--  7 to 0

		"01110001", --Data14-- 31 to 24 -- x"713AD82D"
		"00111010", --Data14-- 23 to 16
		"11011000", --Data14-- 15 to 8
		"00101101", --Data14--  7 to 0

		"01001011", --Data15-- 31 to 24 -- x"4B792F99"
		"01111001", --Data15-- 23 to 16
		"00101111", --Data15-- 15 to 8
		"10011001", --Data15--  7 to 0

		"00100111", --Data16-- 31 to 24 -- x"2799A4DD"
		"10011001", --Data16-- 23 to 16
		"10100100", --Data16-- 15 to 8
		"11011101", --Data16--  7 to 0

		"10100111", --Data17-- 31 to 24 -- x"A7901C49"
		"10010000", --Data17-- 23 to 16
		"00011100", --Data17-- 15 to 8
		"01001001", --Data17--  7 to 0

		"11011110", --Data18-- 31 to 24 -- x"DEDE871A"
		"11011110", --Data18-- 23 to 16
		"10000111", --Data18-- 15 to 8
		"00011010", --Data18--  7 to 0

		"00110110", --Data19-- 31 to 24 -- x"36C03196"
		"11000000", --Data19-- 23 to 16
		"00110001", --Data19-- 15 to 8
		"10010110", --Data19--  7 to 0

		"10100111", --Data20-- 31 to 24 -- x"A7EFC249"
		"11101111", --Data20-- 23 to 16
		"11000010", --Data20-- 15 to 8
		"01001001", --Data20--  7 to 0

		"01100001", --Data21-- 31 to 24 -- x"61A78BB8"
		"10100111", --Data21-- 23 to 16
		"10001011", --Data21-- 15 to 8
		"10111000", --Data21--  7 to 0

		"00111011", --Data22-- 31 to 24 -- x"3B0A1D2B"
		"00001010", --Data22-- 23 to 16
		"00011101", --Data22-- 15 to 8
		"00101011", --Data22--  7 to 0

		"01001101", --Data23-- 31 to 24 -- x"4DBFCA76"
		"10111111", --Data23-- 23 to 16
		"11001010", --Data23-- 15 to 8
		"01110110", --Data23--  7 to 0

		"10101110", --Data24-- 31 to 24 -- x"AE162167"
		"00010110", --Data24-- 23 to 16
		"00100001", --Data24-- 15 to 8
		"01100111", --Data24--  7 to 0

		"00110000", --Data25-- 31 to 24 -- x"30D76B0A"
		"11010111", --Data25-- 23 to 16
		"01101011", --Data25-- 15 to 8
		"00001010", --Data25--  7 to 0

		"01000011", --Data26-- 31 to 24 -- x"43192304"
		"00011001", --Data26-- 23 to 16
		"00100011", --Data26-- 15 to 8
		"00000100", --Data26--  7 to 0

		"11110110", --Data27-- 31 to 24 -- x"F6CC1431"
		"11001100", --Data27-- 23 to 16
		"00010100", --Data27-- 15 to 8
		"00110001", --Data27--  7 to 0

		"01100101", --Data28-- 31 to 24 -- x"65046380"
		"00000100", --Data28-- 23 to 16
		"01100011", --Data28-- 15 to 8
		"10000000", --Data28--  7 to 0 

		"10000000", --Data29-- 31 to 24 -- x"80000000"
		"00000000", --Data29-- 23 to 16
		"00000000", --Data29-- 15 to 8
		"00000000", --Data29--  7 to 0

		"00000000", --Data30-- 31 to 24 -- skey_A
		"00000000", --Data30-- 23 to 16
		"00000000", --Data30-- 15 to 8 
		"00000000", --Data30--  7 to 0 

		"00000000", --Data31-- 31 to 24  --skey_B
		"00000000", --Data31-- 23 to 16
		"00000000", --Data31-- 15 to 8 
		"00000000", --Data31--  7 to 0 

		x"b7", --Data32-- 31 to 24  --s[0]
		x"e1", --Data32-- 23 to 16  
		x"51", --Data32-- 15 to 8   
		x"63", --Data32--  7 to 0   

		x"56", --Data33-- 31 to 24  --s[1]
		x"18", --Data33-- 23 to 16  
		x"cb", --Data33-- 15 to 8   
		x"1c", --Data33--  7 to 0   

		x"f4", --Data34-- 31 to 24  --s[2]
		x"50", --Data34-- 23 to 16  
		x"44", --Data34-- 15 to 8   
		x"d5", --Data34--  7 to 0   

		x"92", --Data35-- 31 to 24  --s[3]
		x"87", --Data35-- 23 to 16  
		x"be", --Data35-- 15 to 8   
		x"8e", --Data35--  7 to 0   

		x"30", --Data36-- 31 to 24  --s[4]
		x"bf", --Data36-- 23 to 16  
		x"38", --Data36-- 15 to 8   
		x"47", --Data36--  7 to 0   

		x"ce", --Data37-- 31 to 24  --s[5]
		x"f6", --Data37-- 23 to 16  
		x"b2", --Data37-- 15 to 8   
		x"00", --Data37--  7 to 0   

		x"6d", --Data38-- 31 to 24  --s[6]
		x"2e", --Data38-- 23 to 16  
		x"2b", --Data38-- 15 to 8   
		x"b9", --Data38--  7 to 0   

		x"0b", --Data39-- 31 to 24  --s[7]
		x"65", --Data39-- 23 to 16  
		x"a5", --Data39-- 15 to 8   
		x"72", --Data39--  7 to 0   

		x"a9", --Data40-- 31 to 24  --s[8]
		x"9d", --Data40-- 23 to 16  
		x"1f", --Data40-- 15 to 8   
		x"2b", --Data40--  7 to 0   

		x"47", --Data41-- 31 to 24  --s[9]
		x"d4", --Data41-- 23 to 16  
		x"98", --Data41-- 15 to 8   
		x"e4", --Data41--  7 to 0   

		x"e6", --Data42-- 31 to 24  --s[10]
		x"0c", --Data42-- 23 to 16  
		x"12", --Data42-- 15 to 8   
		x"9d", --Data42--  7 to 0   

		x"84", --Data43-- 31 to 24  --s[11]
		x"43", --Data43-- 23 to 16  
		x"8c", --Data43-- 15 to 8   
		x"56", --Data43--  7 to 0   

		x"22", --Data44-- 31 to 24  --s[12]
		x"7b", --Data44-- 23 to 16  
		x"06", --Data44-- 15 to 8   
		x"0f", --Data44--  7 to 0   

		x"c0", --Data45-- 31 to 24  --s[13]
		x"b2", --Data45-- 23 to 16  
		x"7f", --Data45-- 15 to 8   
		x"c8", --Data45--  7 to 0   

		x"5e", --Data46-- 31 to 24  --s[14]
		x"e9", --Data46-- 23 to 16  
		x"f9", --Data46-- 15 to 8   
		x"81", --Data46--  7 to 0   

		x"fd", --Data47-- 31 to 24  --s[15]
		x"21", --Data47-- 23 to 16  
		x"73", --Data47-- 15 to 8   
		x"3a", --Data47--  7 to 0   

		x"9b", --Data48-- 31 to 24  --s[16]
		x"58", --Data48-- 23 to 16  
		x"ec", --Data48-- 15 to 8   
		x"f3", --Data48--  7 to 0   

		x"39", --Data49-- 31 to 24  --s[17]
		x"90", --Data49-- 23 to 16  
		x"66", --Data49-- 15 to 8   
		x"ac", --Data49--  7 to 0   

		x"d7", --Data50-- 31 to 24  --s[18]
		x"c7", --Data50-- 23 to 16  
		x"e0", --Data50-- 15 to 8   
		x"65", --Data50--  7 to 0   

		x"75", --Data51-- 31 to 24  --s[19]
		x"ff", --Data51-- 23 to 16  
		x"5a", --Data51-- 15 to 8   
		x"1e", --Data51--  7 to 0   

		x"14", --Data52-- 31 to 24  --s[20]
		x"36", --Data52-- 23 to 16  
		x"d3", --Data52-- 15 to 8   
		x"d7", --Data52--  7 to 0   

		x"b2", --Data53-- 31 to 24  --s[21]
		x"6e", --Data53-- 23 to 16  
		x"4d", --Data53-- 15 to 8   
		x"90", --Data53--  7 to 0   

		x"50", --Data54-- 31 to 24  --s[22]
		x"a5", --Data54-- 23 to 16  
		x"c7", --Data54-- 15 to 8   
		x"49", --Data54--  7 to 0   

		x"ee", --Data55-- 31 to 24  --s[23]
		x"dd", --Data55-- 23 to 16  
		x"41", --Data55-- 15 to 8   
		x"02", --Data55--  7 to 0   

		x"8d", --Data56-- 31 to 24  --s[24]
		x"14", --Data56-- 23 to 16  
		x"ba", --Data56-- 15 to 8   
		x"bb", --Data56--  7 to 0   

		x"2b", --Data57-- 31 to 24  --s[25]
		x"4c", --Data57-- 23 to 16  
		x"34", --Data57-- 15 to 8   
		x"74", --Data57--  7 to 0   

		x"00", --Data58-- 31 to 24  --L[0]
		x"00", --Data58-- 23 to 16  
		x"00", --Data58-- 15 to 8   
		x"00", --Data58--  7 to 0   

		x"00", --Data59-- 31 to 24  --L[1]
		x"00", --Data59-- 23 to 16  
		x"00", --Data59-- 15 to 8   
		x"00", --Data59--  7 to 0   

		x"00", --Data60-- 31 to 24  --L[2]
		x"00", --Data60-- 23 to 16  
		x"00", --Data60-- 15 to 8   
		x"00", --Data60--  7 to 0   

		x"00", --Data61-- 31 to 24  --L[3]
		x"00", --Data61-- 23 to 16  
		x"00", --Data61-- 15 to 8   
		x"00", --Data61--  7 to 0   

		x"00", --Data62-- 31 to 24  --DecryptionResultLSB 
		x"00", --Data62-- 23 to 16         
		x"00", --Data62-- 15 to 8          
		x"00", --Data62--  7 to 0          

		x"00", --Data63-- 31 to 24  --DecryptionResultMSB 
		x"00", --Data63-- 23 to 16         
		x"00", --Data63-- 15 to 8          
		x"00", --Data63--  7 to 0         

		x"00", --Data64-- 31 to 24  --EncryptionResultLSB 
		x"00", --Data64-- 23 to 16         
		x"00", --Data64-- 15 to 8          
		x"00", --Data64--  7 to 0          

		x"00", --Data65-- 31 to 24  --EncryptionResultMSB 
		x"00", --Data65-- 23 to 16         
		x"00", --Data65-- 15 to 8          
		x"00",  --Data65--  7 to 0 
		
		x"00", --Data66-- 31 to 24  --ENCRYPTION/DECRYPTION SELECT 
        x"00", --Data66-- 23 to 16         
        x"00", --Data66-- 15 to 8          
        x"00"  --Data66--  7 to 0 

		        

		);
BEGIN

	PROCESS (clk, clr)
	BEGIN
		IF (clr = '1') THEN  -- RESET DATA MEMORY
		    
	    IF(E_D = '0') THEN
            dmem(263) <= x"00";
            dmem(262) <= x"00";
            dmem(261) <= x"00";
            dmem(260) <= x"00";
        ELSIF (E_D = '1') THEN
            dmem(263) <= x"01";
            dmem(262) <= x"00";
            dmem(261) <= x"00";
            dmem(260) <= x"00";
        END IF;
		
			dmem(259) <= x"00";    dmem(255) <= x"00";    dmem(251) <= x"00";    dmem(247) <= x"00";
			dmem(258) <= x"00";    dmem(254) <= x"00";    dmem(250) <= x"00";    dmem(246) <= x"00";
			dmem(257) <= x"00";    dmem(253) <= x"00";    dmem(249) <= x"00";    dmem(245) <= x"00";
			dmem(256) <= x"00";    dmem(252) <= x"00";    dmem(248) <= x"00";    dmem(244) <= x"00";
			
--			dmem(243) <= x"00";    dmem(239) <= x"00";    dmem(235) <= x"00";    dmem(231) <= x"00";
--            dmem(242) <= x"00";    dmem(238) <= x"00";    dmem(234) <= x"00";    dmem(230) <= x"00";
--            dmem(241) <= x"00";    dmem(237) <= x"00";    dmem(233) <= x"00";    dmem(229) <= x"00";
--            dmem(240) <= x"00";    dmem(236) <= x"00";    dmem(232) <= x"00";    dmem(228) <= x"00";	

--            dmem(116) <= x"00"; --Data30-- 31 to 24 -- skey_A
--            dmem(117) <= x"00"; --Data30-- 23 to 16
--            dmem(118) <= x"00"; --Data30-- 15 to 8 
--            dmem(119) <= x"00"; --Data30--  7 to 0 
--            dmem(120) <= x"00";
--            dmem(121) <= x"00"; --Data31-- 31 to 24  --skey_B
--            dmem(122) <= x"00"; --Data31-- 23 to 16
--            dmem(123) <= x"00"; --Data31-- 15 to 8 
--            dmem(124) <= x"00"; --Data31--  7 to 0 
            
            dmem(124) <= x"b7";    --Data32-- 31 to 24  --s[0] 
            dmem(125) <= x"e1";    --Data32-- 23 to 16         
            dmem(126) <= x"51";    --Data32-- 15 to 8          
            dmem(127) <= x"63";    --Data32--  7 to 0          
                               
            dmem(128) <= x"56";    --Data33-- 31 to 24  --s[1] 
            dmem(129) <= x"18";    --Data33-- 23 to 16         
            dmem(130) <= x"cb";    --Data33-- 15 to 8          
            dmem(131) <= x"1c";    --Data33--  7 to 0          
                               
            dmem(132) <= x"f4";    --Data34-- 31 to 24  --s[2] 
            dmem(133) <= x"50";    --Data34-- 23 to 16         
            dmem(134) <= x"44";    --Data34-- 15 to 8          
            dmem(135) <= x"d5";    --Data34--  7 to 0          
                               
            dmem(136) <= x"92";    --Data35-- 31 to 24  --s[3] 
            dmem(137) <= x"87";    --Data35-- 23 to 16         
            dmem(138) <= x"be";    --Data35-- 15 to 8          
            dmem(139) <= x"8e";    --Data35--  7 to 0          
                               
            dmem(140) <= x"30";    --Data36-- 31 to 24  --s[4] 
            dmem(141) <= x"bf";    --Data36-- 23 to 16         
            dmem(142) <= x"38";    --Data36-- 15 to 8          
            dmem(143) <= x"47";    --Data36--  7 to 0          
                               
            dmem(144) <= x"ce";    --Data37-- 31 to 24  --s[5] 
            dmem(145) <= x"f6";    --Data37-- 23 to 16         
            dmem(146) <= x"b2";    --Data37-- 15 to 8          
            dmem(147) <= x"00";    --Data37--  7 to 0          
                               
            dmem(148) <= x"6d";    --Data38-- 31 to 24  --s[6] 
            dmem(149) <= x"2e";    --Data38-- 23 to 16         
            dmem(150) <= x"2b";    --Data38-- 15 to 8          
            dmem(151) <= x"b9";    --Data38--  7 to 0          
                               
            dmem(152) <= x"0b";    --Data39-- 31 to 24  --s[7] 
            dmem(153) <= x"65";    --Data39-- 23 to 16         
            dmem(154) <= x"a5";    --Data39-- 15 to 8          
            dmem(155) <= x"72";    --Data39--  7 to 0          
                               
            dmem(156) <= x"a9";    --Data40-- 31 to 24  --s[8] 
            dmem(157) <= x"9d";    --Data40-- 23 to 16         
            dmem(158) <= x"1f";    --Data40-- 15 to 8          
            dmem(159) <= x"2b";    --Data40--  7 to 0          
                               
            dmem(160) <= x"47";    --Data41-- 31 to 24  --s[9] 
            dmem(161) <= x"d4";    --Data41-- 23 to 16         
            dmem(162) <= x"98";    --Data41-- 15 to 8          
            dmem(163) <= x"e4";    --Data41--  7 to 0          
                               
            dmem(164) <= x"e6";    --Data42-- 31 to 24  --s[10]
            dmem(165) <= x"0c";    --Data42-- 23 to 16         
            dmem(166) <= x"12";    --Data42-- 15 to 8          
            dmem(167) <= x"9d";    --Data42--  7 to 0          
                               
            dmem(168) <= x"84";    --Data43-- 31 to 24  --s[11]
            dmem(169) <= x"43";    --Data43-- 23 to 16         
            dmem(170) <= x"8c";    --Data43-- 15 to 8          
            dmem(171) <= x"56";    --Data43--  7 to 0          
                               
            dmem(172) <= x"22";    --Data44-- 31 to 24  --s[12]
            dmem(173) <= x"7b";    --Data44-- 23 to 16         
            dmem(174) <= x"06";    --Data44-- 15 to 8          
            dmem(175) <= x"0f";    --Data44--  7 to 0          
                               
            dmem(176) <= x"c0";    --Data45-- 31 to 24  --s[13]
            dmem(177) <= x"b2";    --Data45-- 23 to 16         
            dmem(178) <= x"7f";    --Data45-- 15 to 8          
            dmem(179) <= x"c8";    --Data45--  7 to 0          
                               
            dmem(180) <= x"5e";    --Data46-- 31 to 24  --s[14]
            dmem(181) <= x"e9";    --Data46-- 23 to 16         
            dmem(182) <= x"f9";    --Data46-- 15 to 8          
            dmem(183) <= x"81";    --Data46--  7 to 0          
                               
            dmem(184) <= x"fd";    --Data47-- 31 to 24  --s[15]
            dmem(185) <= x"21";    --Data47-- 23 to 16         
            dmem(186) <= x"73";    --Data47-- 15 to 8          
            dmem(187) <= x"3a";    --Data47--  7 to 0          
                               
            dmem(188) <= x"9b";    --Data48-- 31 to 24  --s[16]
            dmem(189) <= x"58";    --Data48-- 23 to 16         
            dmem(190) <= x"ec";    --Data48-- 15 to 8          
            dmem(191) <= x"f3";    --Data48--  7 to 0          
                               
            dmem(192) <= x"39";    --Data49-- 31 to 24  --s[17]
            dmem(193) <= x"90";    --Data49-- 23 to 16         
            dmem(194) <= x"66";    --Data49-- 15 to 8          
            dmem(195) <= x"ac";    --Data49--  7 to 0          
                              
            dmem(196) <= x"d7";    --Data50-- 31 to 24  --s[18]
            dmem(197) <= x"c7";    --Data50-- 23 to 16         
            dmem(198) <= x"e0";    --Data50-- 15 to 8          
            dmem(199) <= x"65";    --Data50--  7 to 0          
                              
            dmem(200) <= x"75";    --Data51-- 31 to 24  --s[19]
            dmem(201) <= x"ff";    --Data51-- 23 to 16         
            dmem(202) <= x"5a";    --Data51-- 15 to 8          
            dmem(203) <= x"1e";    --Data51--  7 to 0          
            
            dmem(204) <= x"14";    --Data52-- 31 to 24  --s[20]
            dmem(205) <= x"36";    --Data52-- 23 to 16         
            dmem(206) <= x"d3";    --Data52-- 15 to 8          
            dmem(207) <= x"d7";    --Data52--  7 to 0          
                               
            dmem(208) <= x"b2";    --Data53-- 31 to 24  --s[21]
            dmem(209) <= x"6e";    --Data53-- 23 to 16         
            dmem(210) <= x"4d";    --Data53-- 15 to 8          
            dmem(211) <= x"90";    --Data53--  7 to 0          
                               
            dmem(212) <= x"50";    --Data54-- 31 to 24  --s[22]
            dmem(213) <= x"a5";    --Data54-- 23 to 16         
            dmem(214) <= x"c7";    --Data54-- 15 to 8          
            dmem(215) <= x"49";    --Data54--  7 to 0          
                               
            dmem(216) <= x"ee";    --Data55-- 31 to 24  --s[23]
            dmem(217) <= x"dd";    --Data55-- 23 to 16         
            dmem(218) <= x"41";    --Data55-- 15 to 8          
            dmem(219) <= x"02";    --Data55--  7 to 0          
                               
            dmem(220) <= x"8d";    --Data56-- 31 to 24  --s[24]
            dmem(221) <= x"14";    --Data56-- 23 to 16         
            dmem(222) <= x"ba";    --Data56-- 15 to 8          
            dmem(223) <= x"bb";    --Data56--  7 to 0          
                               
            dmem(224) <= x"2b";    --Data57-- 31 to 24  --s[25]
            dmem(225) <= x"4c";    --Data57-- 23 to 16         
            dmem(226) <= x"34";    --Data57-- 15 to 8          
            dmem(227) <= x"74";    --Data57--  7 to 0   
            
            dmem(7) <= D_IN (7 DOWNTO 0);
            dmem(6) <= D_IN (15 DOWNTO 8);
            dmem(5) <= D_IN (23 DOWNTO 16);
            dmem(4) <= D_IN (31 DOWNTO 24);
            dmem(3) <= D_IN (39 DOWNTO 32);
            dmem(2) <= D_IN (47 DOWNTO 40);
            dmem(1) <= D_IN (55 DOWNTO 48);
            dmem(0) <= D_IN (63 DOWNTO 56);
            
            dmem(231) <= UKEY (7 DOWNTO 0);  
            dmem(230) <= UKEY (15 DOWNTO 8); 
            dmem(229) <= UKEY (23 DOWNTO 16);
            dmem(228) <= UKEY (31 DOWNTO 24);
            
            dmem(235) <= UKEY (39 DOWNTO 32);
            dmem(234) <= UKEY (47 DOWNTO 40);
            dmem(233) <= UKEY (55 DOWNTO 48);
            dmem(232) <= UKEY (63 DOWNTO 56);
            
            dmem(239) <= UKEY (71 DOWNTO 64);
            dmem(238) <= UKEY (79 DOWNTO 72);
            dmem(237) <= UKEY (87 DOWNTO 80);
            dmem(236) <= UKEY (95 DOWNTO 88);
            
            dmem(243) <= UKEY (103 DOWNTO 96);
            dmem(242) <= UKEY (111 DOWNTO 104);
            dmem(241) <= UKEY (119 DOWNTO 112);
            dmem(240) <= UKEY (127 DOWNTO 120);
            

		ELSIF (clk'EVENT AND clk = '0') THEN
			IF (A < x"00000108") THEN          
				IF (WE = '1') THEN
					dmem(CONV_INTEGER(unsigned(A)) + 3) <= WD(7 DOWNTO 0);
					dmem(CONV_INTEGER(unsigned(A)) + 2) <= WD(15 DOWNTO 8);
					dmem(CONV_INTEGER(unsigned(A)) + 1) <= WD(23 DOWNTO 16);
					dmem(CONV_INTEGER(unsigned(A)))     <= WD(31 DOWNTO 24);
				ELSIF (WE = '0') THEN
					RD(7 DOWNTO 0)   <= dmem(CONV_INTEGER(unsigned(A)) + 3);
					RD(15 DOWNTO 8)  <= dmem(CONV_INTEGER(unsigned(A)) + 2);
					RD(23 DOWNTO 16) <= dmem(CONV_INTEGER(unsigned(A)) + 1);
					RD(31 DOWNTO 24) <= dmem(CONV_INTEGER(unsigned(A)));
				END IF;

			END IF;
			
			    EncMSB(7 DOWNTO 0)   <= dmem(3);
                EncMSB(15 DOWNTO 8)  <= dmem(2);
                EncMSB(23 DOWNTO 16) <= dmem(1);
                EncMSB(31 DOWNTO 24) <= dmem(0);
            
                EncLSB(7 DOWNTO 0)   <= dmem(7);
                EncLSB(15 DOWNTO 8)  <= dmem(6);
                EncLSB(23 DOWNTO 16) <= dmem(5);
                EncLSB(31 DOWNTO 24) <= dmem(4);
            
                DecMSB(7 DOWNTO 0)   <= dmem(251);
                DecMSB(15 DOWNTO 8)  <= dmem(250);
                DecMSB(23 DOWNTO 16) <= dmem(249);
                DecMSB(31 DOWNTO 24) <= dmem(248);
                                        
                DecLSB(7 DOWNTO 0)   <= dmem(247);
                DecLSB(15 DOWNTO 8)  <= dmem(246);
                DecLSB(23 DOWNTO 16) <= dmem(245);
                DecLSB(31 DOWNTO 24) <= dmem(244);
		ELSE
			NULL;
		END IF;
	END PROCESS;

END Behavioral;