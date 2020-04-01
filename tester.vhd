LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	IEEE.STD_LOGIC_TEXTIO.ALL;
USE	STD.TEXTIO.ALL;



ENTITY tester IS
   PORT(
	       UKEY_outt   : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
           outputt     : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
           Enc_outputt : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
           Dec_outputt : IN STD_LOGIC_VECTOR (63 DOWNTO 0)
	   );
END tester;

ARCHITECTURE tst_arch OF tester IS
BEGIN
   chk_result: PROCESS
      VARIABLE tmp_out: STD_LOGIC_VECTOR(31 DOWNTO 0);
      VARIABLE tmp_uout: STD_LOGIC_VECTOR(127 DOWNTO 0);
      VARIABLE tmp_eout: STD_LOGIC_VECTOR(63 DOWNTO 0);
      VARIABLE l: LINE;
      VARIABLE good_time, good_val, errordet: BOOLEAN;
      VARIABLE r : REAL;
      VARIABLE vector_time: TIME;
      VARIABLE space: CHARACTER;

FILE vector_file: TEXT IS IN "C:\Users\Rajesh\Desktop\Girish\Project\NYU_Processor\values.txt";
BEGIN
   WHILE NOT ENDFILE(vector_file) LOOP
      READLINE(vector_file, l);
      READ(l, r, good_time);
      NEXT WHEN NOT good_time;
      vector_time:= r*1000 ns;
      IF(NOW < vector_time) THEN
         WAIT FOR vector_time-NOW;
      END IF;

------------ Check whether Halt condition was reached or not -----------------------
      READ(l, space);  
      HREAD(l, tmp_out, good_val);
      ASSERT good_val REPORT "Bad vector value";
      WAIT FOR 10 ns; -- Wait until the signal becomes stable
      ASSERT (tmp_out = outputt) REPORT "Output mismatch";
      
------------ READ UKEY -----------------------
      READ(l, space);  
      HREAD(l, tmp_uout, good_val);
      ASSERT good_val REPORT "Bad vector value";
      WAIT FOR 10 ns; -- Wait until the signal becomes stable
      ASSERT (tmp_uout = UKEY_outt) REPORT "Output mismatch";
      
------------ READ Din (which is Dec_output here) -----------------------      
      READ(l, space);  
      HREAD(l, tmp_eout, good_val);
      ASSERT good_val REPORT "Bad vector value";
      WAIT FOR 10 ns; -- Wait until the signal becomes stable
      ASSERT (tmp_eout = Dec_outputt) REPORT "Output mismatch";
      
------------ READ Enc_output -----------------------      
      READ(l, space);  
      HREAD(l, tmp_eout, good_val);
      ASSERT good_val REPORT "Bad vector value";
      WAIT FOR 10 ns; -- Wait until the signal becomes stable
      ASSERT (tmp_eout = Enc_outputt) REPORT "Output mismatch";
      
   END LOOP;
   WAIT;
   END PROCESS;
END tst_arch; 