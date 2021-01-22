Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY ALU IS
PORT( A, B: IN STD_LOGIC_VECTOR(15 downto 0);
		sel : IN STD_LOGIC_VECTOR(2 downto 0);
		s : OUT STD_LOGIC_VECTOR(15 downto 0));
END ALU;

ARCHITECTURE behavior OF ALU IS

COMPONENT AddSubNbits IS
GENERIC (N : positive := 16);
PORT( A, B : IN STD_LOGIC_VECTOR(N-1 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(N-1 downto 0);
		addSub : IN STD_LOGIC);
END COMPONENT;

SIGNAL cout, selAddSub : STD_LOGIC;
SIGNAL saddsub : STD_LOGIC_VECTOR(15 downto 0);

BEGIN
	
	addsub : AddSubNbits PORT MAP(A=>A, B=>B, Cin=>'0', Cout=>cout, S=>saddsub, addSub=>selAddSub);
	
	PROCESS(sel, A, B, saddsub)
	BEGIN
		IF(sel = "000") THEN
			selAddSub <= '0';
			s <= saddsub;
		ELSIF (sel = "001") THEN
			selAddSub <= '1';
			s <= saddsub;
		ELSIF (sel = "010") THEN
			s <= A AND B;
		ELSIF (sel = "011") THEN
			s <= A OR B;
		ELSIF (sel = "100") THEN
			s <= NOT(A) ;
		ELSE NULL;
		END IF;
	END PROCESS;
	
END behavior;