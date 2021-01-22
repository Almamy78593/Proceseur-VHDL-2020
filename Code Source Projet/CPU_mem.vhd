Library IEEE;
USE ieee.std_logic_1164.all;


ENTITY CPU_mem IS
PORT (
		MClk, PClk, Resetn, Run : IN STD_LOGIC;
		dataBus, DinVision : OUT STD_LOGIC_VECTOR(15 downto 0);
		Done : OUT STD_LOGIC;
		IRsortieVision : OUT STD_LOGIC_VECTOR(8 downto 0);
		BusSelvision : OUT STD_LOGIC_VECTOR(3 downto 0);
		R0vision, R1vision : OUT STD_LOGIC_VECTOR(15 downto 0);
		Alusortievision, asortievision, gvision : OUT STD_LOGIC_VECTOR(15 downto 0)
		);
END ENTITY;

ARCHITECTURE arch OF CPU_mem IS

COMPONENT CPU_wm IS
PORT ( Clk, Run, Reset_n: IN STD_LOGIC;
	    Din : IN STD_LOGIC_VECTOR(15 downto 0);
		 dataBus : OUT STD_LOGIC_VECTOR(15 downto 0);
		 Done : OUT STD_LOGIC;
		 BusSelvision : OUT STD_LOGIC_VECTOR(3 downto 0);
		 IRsortieVision : OUT STD_LOGIC_VECTOR(8 downto 0);
		 R0vision, R1vision : OUT STD_LOGIC_VECTOR(15 downto 0);
		 Alusortievision, asortievision, gvision : OUT STD_LOGIC_VECTOR(15 downto 0)
		);
END COMPONENT;

COMPONENT ROM IS
PORT
	(
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT counter2 IS
PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END COMPONENT;


SIGNAL counterValue : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL memoryValue  : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

	DinVision <= memoryValue;

	COUNTER : counter2 PORT MAP ( aclr => Resetn, clock => MClk, q => counterValue );
	MEMOIRE : ROM PORT MAP ( address => counterValue, clock => MClk, q => memoryValue );
	CPU : CPU_wm PORT MAP ( Clk => PClk, Run => Run, Reset_n => Resetn, Din => memoryValue,
                           dataBus => dataBus, Done => Done, BusSelvision => BusSelvision,
								   IRsortieVision => IRsortieVision, R0vision => R0vision, R1vision => R1vision,
								   Alusortievision => Alusortievision, asortievision => asortievision, gvision=> gvision);
END arch;		