Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY AddSubNbits IS
GENERIC(N : positive := 16);
PORT( A, B : IN STD_LOGIC_VECTOR(N-1 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(N-1 downto 0);
		addSub : IN STD_LOGIC);
END AddSubNbits;

ARCHITECTURE behavior OF AddSubNbits IS

COMPONENT FA_Nbits IS
	GENERIC(N : positive := 16);
	PORT(A, B : IN STD_LOGIC_VECTOR(N-1 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(N-1 downto 0));
END COMPONENT;

SIGNAL Sign : STD_LOGIC_VECTOR(N-1 downto 0);
SIGNAL Sc : STD_LOGIC;
BEGIN

	adderN : FA_Nbits 
	 PORT MAP(A => A, B => Sign,  Cin => Sc, Cout => Cout, S => S);
	
	PROCESS(addSub, A, B)
	BEGIN
		IF(addSub = '0') THEN
			Sign <= B;
			Sc <= Cin;
		ELSE
			Sign <= NOT(B);
			Sc <= '1';
		END IF;
	END PROCESS;
	
END behavior;