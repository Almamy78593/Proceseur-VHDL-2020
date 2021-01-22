Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY basculeD IS
PORT(D : IN STD_LOGIC;
	  Q : OUT STD_LOGIC;
	  Clk : IN STD_LOGIC;
	  Rst : IN STD_LOGIC;
	  Set: IN STD_LOGIC);
END basculeD;

ARCHITECTURE Behavior OF basculeD IS
BEGIN 
	
	PROCESS(Clk, Rst)
	BEGIN
		IF(Rst = '1')THEN 
			Q <= '0';
		ELSIF(rising_edge(Clk)) THEN
			IF (Set = '1') THEN
				Q <= '1';
			ELSE
				Q <= D;
			END IF;
		END IF;
	
	END PROCESS;
	
END Behavior;