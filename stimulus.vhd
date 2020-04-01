LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	IEEE.STD_LOGIC_TEXTIO.ALL;
USE	STD.TEXTIO.ALL;

ENTITY stimulus IS
   PORT   (
            clr        : OUT STD_LOGIC;
            clk        : OUT STD_LOGIC;
                         
            CLK_CHOICE : OUT STD_LOGIC;
            clk_manual : OUT STD_LOGIC;
            ed         : OUT STD_LOGIC;
            ud         : OUT STD_LOGIC;
                         
            Data_in    : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
            UKEY_in    : OUT STD_LOGIC_VECTOR (127 DOWNTO 0)
          );  
END stimulus;


ARCHITECTURE sti_arch OF stimulus IS
   SIGNAL    clk_tmp : STD_LOGIC;
   signal stop_the_clock: boolean;
   signal i: INTEGER := 0;
   signal j: INTEGER := 0;
   CONSTANT  ClkPeriod	: Time := 10 ns;
   
BEGIN

sti_clr: PROCESS
   BEGIN  
   WHILE (i < 100) LOOP  
        clr<='1';
      WAIT FOR 50 ns;
        clr<='0';
      wait for 35000*Clkperiod;
      wait for 10 ns;
      i <= i+1;           
   end loop;         
   stop_the_clock <= true;
   wait;
END PROCESS;

sti_ed: PROCESS
   BEGIN 
   WHILE (j < 100) LOOP     
        ed <= '0';
      wait for 35000*Clkperiod;
      wait for 60 ns;
      j <= j+1;           
   end loop;
END PROCESS;

sti_ud: PROCESS
   BEGIN    
        ud <= '1';
      wait for 71000*Clkperiod;
      wait;
END PROCESS;


sti_clk_choice: PROCESS
   BEGIN    
        CLK_CHOICE <= '1';
--      WAIT FOR 400 ns;
--        CLK_CHOICE <= '0';
      wait for 71000*Clkperiod;
      wait;
END PROCESS;
   
sti_clk: PROCESS
BEGIN
    while not stop_the_clock loop
      clk_tmp <= '0', '1' after ClkPeriod / 2;
      wait for ClkPeriod;
    end loop;
    wait;
END PROCESS;
      clk <= clk_tmp;
      clk_manual <= clk_tmp;

   
--sti_inputs: PROCESS
--   BEGIN    
--        Data_in <= x"6320e1d05c1c3a15";
--        UKEY_in <= x"00000000000000000000000000000000"; 
--      wait for 35000*Clkperiod;
      
--      wait for 100 ns;
      
--        Data_in <= x"6b3262645ca1e70d";
--        UKEY_in <= x"00000000000000000000000000000000"; 
--      wait for 35000*Clkperiod;

--      wait;
--END PROCESS;
        
   
   chk_result: PROCESS
      VARIABLE tmp_out: STD_LOGIC_VECTOR(63 DOWNTO 0);
      VARIABLE tmp_uout: STD_LOGIC_VECTOR(127 DOWNTO 0);
      VARIABLE l: LINE;
      VARIABLE good_time, good_val, errordet: BOOLEAN;
      VARIABLE r : REAL;
      VARIABLE vector_time: TIME;
      VARIABLE space: CHARACTER;

FILE vector_file: TEXT IS IN "C:\Users\Rajesh\Desktop\Girish\Project\NYU_Processor\input_values.txt";
BEGIN
   WHILE NOT ENDFILE(vector_file) LOOP
      READLINE(vector_file, l);
      READ(l, r, good_time);
      NEXT WHEN NOT good_time;
      vector_time:= r*1000 ns;
      IF(NOW < vector_time) THEN
         WAIT FOR vector_time-NOW;
      END IF;
      
------------ READ UKEY -----------------------
      READ(l, space);  
      HREAD(l, tmp_uout, good_val);
      ASSERT good_val REPORT "Bad vector value";
      WAIT FOR 10 ns; -- Wait until the signal becomes stable

------------ READ DIN -----------------------
      READ(l, space);  
      HREAD(l, tmp_out, good_val);
      ASSERT good_val REPORT "Bad vector value";
      WAIT FOR 10 ns; -- Wait until the signal becomes stable
      
      Data_in <= tmp_out;
      UKEY_in <= tmp_uout;
                  
   END LOOP;
   WAIT;
   END PROCESS;
   

END sti_arch;
    