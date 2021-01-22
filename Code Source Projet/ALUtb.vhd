Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY ALUtb IS
END ENTITY;

ARCHITECTURE arch OF ALUtb IS

COMPONENT ALU IS
PORT( A, B: IN STD_LOGIC_VECTOR(15 downto 0);
		sel : IN STD_LOGIC_VECTOR(2 downto 0);
		s : OUT STD_LOGIC_VECTOR(15 downto 0)
		);
END COMPONENT;

SIGNAL s_A, s_B, s_s : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL s_sel : STD_LOGIC_VECTOR(2 downto 0);

BEGIN	
		
		aluette : ALU PORT MAP ( A=>s_A, B=>s_B, sel=>s_sel, s=>s_s );
		
		PROCESS
		BEGIN
		
		  wait for 20 ns;
		
			s_sel <= "000";
			s_A <= "0000000000001001";
			s_B <= "0000000000000011";
			
			
			wait for 20 ns;
			
			s_A <= "0000000000000001";
			s_B <= "0000000000000001";
			
			
			wait for 20 ns;
			
			s_A <= "0000000000000001";
			s_B <= "0000000000000010";
			
			wait;
			
		END PROCESS;
END arch;