Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY AddSubNbits_test IS
PORT( SW : IN STD_LOGIC_VECTOR(9 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(3 downto 0);
		LEDR : OUT STD_LOGIC_VECTOR(4 downto 0));
END AddSubNbits_test;

ARCHITECTURE behavior OF AddSubNbits_test IS

COMPONENT AddSubNbits IS
	GENERIC(N : positive := 4);
	PORT(A, B : IN STD_LOGIC_VECTOR(N-1 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(N-1 downto 0);
		addSub : IN STD_LOGIC);
END COMPONENT;

BEGIN
	
	AdderSuber : AddSubNbits GENERIC MAP(N =>4)
		PORT MAP(A=>SW(7 downto 4), B=>SW(3 downto 0), Cin=>SW(8), Cout=>LEDR(4), S=>LEDR(3 downto 0), addSub => SW(9));
	
END behavior;