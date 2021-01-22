Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY CPU_mem_tb IS
END ENTITY;

ARCHITECTURE arch OF CPU_mem_tb IS

SIGNAL s_clk : STD_LOGIC := '0';
SIGNAL s_Mclk : STD_LOGIC := '0';
SIGNAL s_reset, s_done : STD_LOGIC;
SIGNAL s_run: STD_LOGIC := '0';
SIGNAL s_din, s_dataBus : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL s_BusSelvision : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL s_IRvision : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL R0contenu, R1contenu, alusortie, asortie, gsortie, dinvoir : STD_LOGIC_VECTOR(15 downto 0);


COMPONENT CPU_mem IS
PORT (
		MClk, PClk, Resetn, Run : IN STD_LOGIC;
		dataBus, DinVision : OUT STD_LOGIC_VECTOR(15 downto 0);
		Done : OUT STD_LOGIC;
		IRsortieVision : OUT STD_LOGIC_VECTOR(8 downto 0);
		BusSelvision : OUT STD_LOGIC_VECTOR(3 downto 0);
		R0vision, R1vision : OUT STD_LOGIC_VECTOR(15 downto 0);
		Alusortievision, asortievision, gvision : OUT STD_LOGIC_VECTOR(15 downto 0)
		);
END COMPONENT;

BEGIN
		
		processeur : CPU_mem PORT MAP ( Mclk => s_Mclk, dinvision => dinvoir, gvision=>gsortie, asortievision => asortie, 
		                              Alusortievision=>alusortie, PClk=>s_clk, Run=>s_run, Resetn=>s_reset,  dataBus=>s_dataBus,
		                             Done=>s_done, BusSelvision=>s_BusSelvision, IRsortieVision => s_IRvision,
											  R0vision => R0contenu, R1vision => R1contenu);
		
		s_clk <= not(s_clk) after 5 ns;
		
		
		PROCESS
		BEGIN
			
			wait for 1 ns;
			s_Mclk <= '1';
			wait for 1 ns;
			s_Mclk <= '0';
		
			-- On passe l'ordre d'un MOVI dans R1
		
			wait for 1 ns;
		
			s_Mclk <= '1';
			wait for 1 ns;
			s_Mclk <= '0';
			
			-- On lance le controleur
			s_reset <= '1';
			s_reset <= '0';
			wait for 10 ns;
			
			-- On passe la valeur à stocker dans R1
		   s_Mclk <= '1';
			wait for 1 ns;
			s_Mclk <= '0';
			
			wait for 20 ns;
			
			-- On lane l'execution
			s_run <= '1';
			wait for 1 ns;
			s_run <= '0';
			wait for 20 ns;
			
			
			-- On passe l'ordre d'un MOVI dans R0
		
			s_Mclk <= '1';
			wait for 1 ns;
			s_Mclk <= '0';
			
			wait for 10 ns;
			
			-- On passe la valeur à stocker dans R0
		   s_Mclk <= '1';
			wait for 1 ns;
			s_Mclk <= '0';
			
			wait for 20 ns;
			-- On lance l'execution
			s_run <= '1';
			wait for 1 ns;
			s_run <= '0';
			wait for 20 ns;
			
			
			s_Mclk <= '1';
			wait for 1 ns;
			s_Mclk <= '0';
			
			wait for 20 ns;
			
			
			s_run <= '1';
			wait for 1 ns;
			s_run <= '0';
			
			wait;

		END PROCESS;
END arch;