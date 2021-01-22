Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY controlUnitFsm IS

PORT( clk, reset, run : IN STD_LOGIC;
		IR : IN STD_LOGIC_VECTOR(8 downto 0);
		BusSel : OUT STD_LOGIC_VECTOR(3 downto 0);
		Done, IRs, R0s, R1s, R2s, R3s, R4s : OUT STD_LOGIC;
		R5s, R6s, R7s, As, Gs : OUT STD_LOGIC;
		opeChoice : OUT STD_LOGIC_VECTOR(2 downto 0)
		);
		
END controlUnitFsm;

ARCHITECTURE Behavior OF controlUnitFsm IS

TYPE TypeEtat IS (Fetch, Decode, Exec_MV, Exec_MVI, Exec1_add, Exec2_add, Exec3_add, Exec1_sub, 
                   Exec2_sub, Exec3_sub, Exec1_and, Exec2_and,Exec3_and, Exec1_or, Exec2_or,Exec3_or,
						 Exec1_not, Exec2_not, Exec3_not
						 );
SIGNAL etat_present, etat_futur : TypeEtat;
SIGNAL codop, Rx, Ry : STD_LOGIC_VECTOR(2 downto 0);

BEGIN 
	
	codop <= IR(8 downto 6);
	Rx <= IR(5 downto 3);
	Ry <= IR(2 downto 0);
	
	PROCESS(clk, reset)
	BEGIN
			IF(reset = '1') THEN
				etat_present <= Fetch;
			ELSIF(clk'event AND clk = '1') THEN
				etat_present <= etat_futur;
			END IF;
	END PROCESS;
	
	PROCESS(etat_present, Run)
	BEGIN
		case etat_present IS
			WHEN Fetch => etat_futur <= Decode;
			WHEN Decode => IF(Run = '1') THEN
									IF(codop = "000") THEN
										etat_futur <= Exec_MV;
									ELSIF(codop = "001") THEN
										etat_futur <= Exec_MVI;
									ELSIF(codop = "010") THEN
										etat_futur <= Exec1_add;
									ELSIF(codop = "011") THEN
										etat_futur <= Exec1_sub;
									ELSIF(codop = "100") THEN
										etat_futur <= Exec1_and;
									ELSIF(codop = "101") THEN
										etat_futur <= Exec1_or;
									ELSIF(codop = "110") THEN
										etat_futur <= Exec1_not;
									END IF;
								END IF;
			WHEN Exec_MV => etat_futur <= Fetch;
			WHEN Exec_MVI => etat_futur <= Fetch;
			WHEN Exec1_add => etat_futur <= Exec2_add;
			WHEN Exec2_add => etat_futur <= Exec3_add;
			WHEN Exec3_add => etat_futur <= Fetch;
			WHEN Exec1_sub => etat_futur <= Exec2_sub;
			WHEN Exec2_sub => etat_futur <= Exec3_sub;
			WHEN Exec3_sub => etat_futur <= Fetch;
			WHEN Exec1_and => etat_futur <= Exec2_and;
			WHEN Exec2_and => etat_futur <= Exec3_and;
			WHEN Exec3_and => etat_futur <= Fetch;
			WHEN Exec1_or => etat_futur <= Exec2_or;
			WHEN Exec2_or => etat_futur <= Exec3_or;
			WHEN Exec3_or => etat_futur <= Fetch;
			WHEN Exec1_not => etat_futur <= Exec2_not;
			WHEN Exec2_not => etat_futur <= Exec3_not;
			WHEN Exec3_not => etat_futur <= Fetch;
			WHEN OTHERS => NULL;
		END CASE;
	END PROCESS;
	
	
	
	-- Les registres occupent les positions [0-7] du BusSel
	-- La position 8 est pour Din et 9 pour la sortie de G
	PROCESS(etat_present)
	-- Decodeur a rajouter pour le test de Rx
	BEGIN
		CASE etat_present IS
			WHEN Fetch => Done <= '0';
			              IRs <= '1';
							  R0s <= '0';
							  R1s <= '0';
							  R2s <= '0';
							  R3s <= '0';
							  R4s <= '0';
							  R5s <= '0';
							  R6s <= '0';
							  R7s <= '0';
							  
	      WHEN Decode => IRs <= '0';
			
			WHEN Exec_MV => BusSel <= '0'&Ry; 
								 IF(Rx = "000") THEN R0s <= '1';
								 ELSIF(Rx = "001") THEN R1s <= '1';
								 ELSIF(Rx = "010") THEN R2s <= '1';
								 ELSIF(Rx = "011") THEN R3s <= '1';
								 ELSIF(Rx = "100") THEN R4s <= '1';
								 ELSIF(Rx = "101") THEN R5s <= '1';
								 ELSIF(Rx = "110") THEN R6s <= '1';
								 ELSIF(Rx = "111") THEN R7s <= '1';
								 END IF;
								 Done <= '1';
			
			WHEN Exec_MVI => BusSel <= "1000";
								  IF(Rx = "000") THEN R0s <= '1';
								  ELSIF(Rx = "001") THEN R1s <= '1';
								  ELSIF(Rx = "010") THEN R2s <= '1';
								  ELSIF(Rx = "011") THEN R3s <= '1';
								  ELSIF(Rx = "100") THEN R4s <= '1';
								  ELSIF(Rx = "101") THEN R5s <= '1';
								  ELSIF(Rx = "110") THEN R6s <= '1';
								  ELSIF(Rx = "111") THEN R7s <= '1';
								  END IF;
								  Done <= '1';
			
			WHEN Exec1_add => BusSel <= '0'&Rx;
									As <= '1';
									opeChoice <= "000";
			
			WHEN Exec2_add => 
									As <= '0';
									BusSel <= '0' & Ry;
									Gs <= '1';
			
			WHEN Exec3_add => BusSel <= "1001";
			                  Gs <= '0';
									IF(Rx = "000") THEN R0s <= '1';
								   ELSIF(Rx = "001") THEN R1s <= '1';
								   ELSIF(Rx = "010") THEN R2s <= '1';
								   ELSIF(Rx = "011") THEN R3s <= '1';
								   ELSIF(Rx = "100") THEN R4s <= '1';
								   ELSIF(Rx = "101") THEN R5s <= '1';
								   ELSIF(Rx = "110") THEN R6s <= '1';
								   ELSIF(Rx = "111") THEN R7s <= '1';
								   END IF;
									Done <= '1';
			WHEN Exec1_sub => BusSel <= '0' & Rx;
									As <= '1';
			WHEN Exec2_sub => As <= '0';
			                  opeChoice <= "001";
									BusSel <= '0' & Ry;
									Gs <= '1';
			WHEN Exec3_sub => BusSel <= "1001";
			                  Gs <= '0';
									IF(Rx = "000") THEN R0s <= '1';
								   ELSIF(Rx = "001") THEN R1s <= '1';
								   ELSIF(Rx = "010") THEN R2s <= '1';
								   ELSIF(Rx = "011") THEN R3s <= '1';
								   ELSIF(Rx = "100") THEN R4s <= '1';
								   ELSIF(Rx = "101") THEN R5s <= '1';
								   ELSIF(Rx = "110") THEN R6s <= '1';
								   ELSIF(Rx = "111") THEN R7s <= '1';
								   END IF;
									Done <= '1';
									
			WHEN Exec1_and => BusSel <= '0'&Rx;
									As <= '1';
									opeChoice <= "010";
			
			WHEN Exec2_and => 
									As <= '0';
									BusSel <= '0' & Ry;
									Gs <= '1';
			
			WHEN Exec3_and => BusSel <= "1001";
			                  Gs <= '0';
									IF(Rx = "000") THEN R0s <= '1';
								   ELSIF(Rx = "001") THEN R1s <= '1';
								   ELSIF(Rx = "010") THEN R2s <= '1';
								   ELSIF(Rx = "011") THEN R3s <= '1';
								   ELSIF(Rx = "100") THEN R4s <= '1';
								   ELSIF(Rx = "101") THEN R5s <= '1';
								   ELSIF(Rx = "110") THEN R6s <= '1';
								   ELSIF(Rx = "111") THEN R7s <= '1';
								   END IF;
									Done <= '1';
			
			WHEN Exec1_or => BusSel <= '0'&Rx;
									As <= '1';
									opeChoice <= "011";
			
			WHEN Exec2_or => 
									As <= '0';
									BusSel <= '0' & Ry;
									Gs <= '1';
			
			WHEN Exec3_or => BusSel <= "1001";
			                  Gs <= '0';
									IF(Rx = "000") THEN R0s <= '1';
								   ELSIF(Rx = "001") THEN R1s <= '1';
								   ELSIF(Rx = "010") THEN R2s <= '1';
								   ELSIF(Rx = "011") THEN R3s <= '1';
								   ELSIF(Rx = "100") THEN R4s <= '1';
								   ELSIF(Rx = "101") THEN R5s <= '1';
								   ELSIF(Rx = "110") THEN R6s <= '1';
								   ELSIF(Rx = "111") THEN R7s <= '1';
								   END IF;
									Done <= '1';
			
			WHEN Exec1_not => BusSel <= '0'&Rx;
									As <= '1';
									opeChoice <= "100";
			
			WHEN Exec2_not => 
									As <= '0';
									
									Gs <= '1';
			
			WHEN Exec3_not => BusSel <= "1001";
			                  Gs <= '0';
									IF(Rx = "000") THEN R0s <= '1';
								   ELSIF(Rx = "001") THEN R1s <= '1';
								   ELSIF(Rx = "010") THEN R2s <= '1';
								   ELSIF(Rx = "011") THEN R3s <= '1';
								   ELSIF(Rx = "100") THEN R4s <= '1';
								   ELSIF(Rx = "101") THEN R5s <= '1';
								   ELSIF(Rx = "110") THEN R6s <= '1';
								   ELSIF(Rx = "111") THEN R7s <= '1';
								   END IF;
									Done <= '1';
			
			WHEN OTHERS => NULL;
			
		END CASE;
	END PROCESS;
		
END Behavior;		
