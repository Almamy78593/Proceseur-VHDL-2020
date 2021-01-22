Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY addsubtb IS
END ENTITY;

ARCHITECTURE arch OF addsubtb IS

COMPONENT AddSubNbits IS
GENERIC(N : positive := 16);
PORT( A, B : IN STD_LOGIC_VECTOR(N-1 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(N-1 downto 0);
		addSub : IN STD_LOGIC);
END COMPONENT;

SIGNAL s_A, s_B, s_s : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL s_sel, s_cin, s_cout : STD_LOGIC;

BEGIN	
		
		aluette : AddSubNbits PORT MAP ( Cin=>s_cin, Cout=>s_cout, A=>s_A, B=>s_B, addSub=>s_sel, s=>s_s );
		
		PROCESS
		BEGIN
			s_cin <= '0';
		
			s_A <= "0000000000001000";
			s_B <= "0000000000000011";
			s_sel <= '1';
			
			wait for 15 ns;
			

			s_A <= "0000000000000001";
			s_B <= "0000000000000001";
			
			wait for 15 ns;
			
			s_A <= "0000000000000010";
			s_B <= "0000000000000001";
			
			wait;
			
		END PROCESS;
END arch;