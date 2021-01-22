Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY Acc4bits IS
PORT(A : IN STD_LOGIC_VECTOR(3 downto 0);
	  S : OUT STD_LOGIC_VECTOR(3 downto 0);
	  Cout : OUT STD_LOGIC;
	  Clk : IN STD_LOGIC;
	  Rst : IN STD_LOGIC);
END Acc4bits;

ARCHITECTURE Behavior OF Acc4bits IS

	SIGNAL s1, s2, s3 : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL s4 : STD_LOGIC;
	
	COMPONENT RegNbits IS
	GENERIC(N : positive := 4);
	PORT(D : IN STD_LOGIC_VECTOR(N-1 downto 0);
	  Q : OUT STD_LOGIC_VECTOR(N-1 downto 0);
	  Clk : IN STD_LOGIC;
	  Rst : IN STD_LOGIC);
	END COMPONENT;
	
	COMPONENT FA_Nbits IS
	GENERIC(N : positive := 4);
	PORT(A, B : IN STD_LOGIC_VECTOR(N-1 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(N-1 downto 0));
	END COMPONENT;
	
	COMPONENT Reg1bit IS
	PORT( D : IN STD_LOGIC;
	  Q : OUT STD_LOGIC;
	  Clk : IN STD_LOGIC;
	  Rst : IN STD_LOGIC);
	END COMPONENT;

BEGIN 
	
	reg1 : RegNbits PORT MAP(D => A, Q => s1, Clk => Clk, Rst => Rst);
	
	adder : FA_Nbits PORT MAP(A => s1, B => s3, Cin => '0', Cout => s4, S => s2);
	
	reg2 : RegNbits PORT MAP(D => s2, Q => s3, Clk => Clk, Rst => Rst);
	
	reg3 : Reg1bit PORT MAP(D => s4, Q => Cout, Clk => Clk, Rst => Rst);
	S <= s3;
	
END Behavior;