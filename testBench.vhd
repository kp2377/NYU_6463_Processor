LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	IEEE.STD_LOGIC_TEXTIO.ALL;
USE	STD.TEXTIO.ALL;

ENTITY testBench IS	
       -- No I/O signals defined
END testBench;

ARCHITECTURE tb_arch OF testBench IS

   -- component declarations
      Component TopModule 
       PORT
       (
           clr_TM        : IN STD_LOGIC;
           CLK1       : IN STD_LOGIC;
           
           CLK_CHOICE_TM : IN STD_LOGIC;
           clk_manual_TM : IN STD_LOGIC;
           ed_TM         : IN STD_LOGIC;
           ud_TM         : IN STD_LOGIC;
           
           Data_in_TM    : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
           UKEY_in_TM    : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
       
           UKEY_out   : OUT STD_LOGIC_VECTOR (127 DOWNTO 0);
           DD_OUT     : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
           output     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
           Enc_output : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
           Dec_output : OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
       );
      END Component;
      
      Component stimulus
       PORT(
              clr        : OUT STD_LOGIC;
              clk        : OUT STD_LOGIC;
                           
              CLK_CHOICE : OUT STD_LOGIC;
              clk_manual : OUT STD_LOGIC;
              ed         : OUT STD_LOGIC;
              ud         : OUT STD_LOGIC;
                           
              Data_in    : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
              UKEY_in    : OUT STD_LOGIC_VECTOR (127 DOWNTO 0)
           );
      END Component;
      
      Component tester
         PORT(
                UKEY_outt   : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
                outputt     : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                Enc_outputt : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
                Dec_outputt : IN STD_LOGIC_VECTOR (63 DOWNTO 0)
             );
      END Component;
      
   -- signal declarations, used to wire the components
     Signal clrr        : STD_LOGIC;
     Signal clkk        : STD_LOGIC;
     Signal clk_choicee : STD_LOGIC;
     Signal clk_manuall : STD_LOGIC;
     Signal edd         : STD_LOGIC;
     Signal udd         : STD_LOGIC;   
     Signal dinn        : STD_LOGIC_VECTOR(63 DOWNTO 0);
     Signal din_vld     : STD_LOGIC_VECTOR(63 DOWNTO 0);
     Signal uinn        : STD_LOGIC_VECTOR(127 DOWNTO 0);
     Signal uout       : STD_LOGIC_VECTOR(127 DOWNTO 0);
     Signal dout       : STD_LOGIC_VECTOR(31 DOWNTO 0);
     Signal enc_out    : STD_LOGIC_VECTOR(63 DOWNTO 0);
     Signal dec_out    : STD_LOGIC_VECTOR(63 DOWNTO 0);
     
     CONSTANT   ClkPeriod	: Time:= 10 ns;
BEGIN
   -- component instantiations
	sti: stimulus PORT MAP(
	                        clr => clrr, clk => clkk, 
                            CLK_CHOICE => clk_choicee, clk_manual => clk_manuall, ed => edd, ud => udd,
                            Data_in => dinn, UKEY_in => uinn
                          );
	uut: TopModule PORT MAP(
	                           clr_TM => clrr, CLK1 => clkk, 
	                           CLK_CHOICE_TM => clk_choicee, clk_manual_TM => clk_manuall, ed_TM => edd, ud_TM => udd,
	                           Data_in_TM => dinn, UKEY_in_TM => uinn, 
	                           UKEY_out => uout, DD_OUT => din_vld, output => dout,Enc_output => enc_out, Dec_output => dec_out
	                        );
	tst: tester PORT MAP(
                          UKEY_outt => uout, outputt => dout,Enc_outputt => enc_out, Dec_outputt => dec_out
	                    );
END tb_arch;







