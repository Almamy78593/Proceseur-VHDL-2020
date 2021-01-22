Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY controlUnitTestBench IS
END ENTITY;

ARCHITECTURE arch OF controlUnitTestBench IS

SIGNAL s_clk : STD_LOGIC := '0';
SIGNAL s_reset : STD_LOGIC;
SIGNAL s_run : STD_LOGIC;
SIGNAL s_ir : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL s_busSel : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL s_Done, s_IRs, s_R0s, s_R1s, s_R2s, s_R3s, s_R4s : STD_LOGIC;
SIGNAL s_R5s, s_R6s, s_R7s, s_As, s_Gs, s_AddSub : STD_LOGIC;

COMPONENT controlUnitFsm IS
PORT( clk, reset, run : IN STD_LOGIC;
		IR : IN STD_LOGIC_VECTOR(8 downto 0);
		BusSel : OUT STD_LOGIC_VECTOR(3 downto 0);
		Done, IRs, R0s, R1s, R2s, R3s, R4s : OUT STD_LOGIC;
		R5s, R6s, R7s, As, Gs, AddSub : OUT STD_LOGIC);
END COMPONENT;

BEGIN
		
		UniteControle : controlUnitFSM PORT MAP( clk=>s_clk, reset=>s_reset, run=>s_run, IR=>s_ir,
	                                            	BusSel=>s_busSel, Done=>s_Done, IRs=>s_IRS, R0s=>s_R0s, R1s=>s_R1s, R2s=>s_R2s, 
																R3s=>s_R3s, R4s=>s_R4s, R5s=>s_R5s, R6s=>s_R6s, R7s=>s_R7s, As=>s_AS,
																Gs=>s_Gs, AddSub=>s_AddSub );
		
		s_clk <= not(s_clk) after 10 ns;
		
		PROCESS
		BEGIN
			
			s_reset <= '1';
			s_reset <= '0';
			s_ir <= "001001010";
			wait for 50 ns;
			s_run <= '1';
			wait;
		END PROCESS;
END arch;