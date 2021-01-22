Library IEEE;
USE ieee.std_logic_1164.all;

ENTITY CPU IS 

PORT ( Clk, Run, Reset_n, counterClock, counterClear : IN STD_LOGIC;
	    Din : OUT STD_LOGIC_VECTOR(15 downto 0);
		 dataBus : OUT STD_LOGIC_VECTOR(15 downto 0);
		 Done : OUT STD_LOGIC;
		 BusSelvision : OUT STD_LOGIC_VECTOR(3 downto 0);
		 IRsortieVision : OUT STD_LOGIC_VECTOR(8 downto 0);
		 R0vision, R1vision : OUT STD_LOGIC_VECTOR(15 downto 0);
		 counterValueVision, addressVision : OUT STD_LOGIC_VECTOR(3 downto 0)
		);

END ENTITY;

ARCHITECTURE arch OF CPU IS

COMPONENT mux_10v1_16bits IS
PORT( a,b,c,d,e,f,g,h,i,j: IN STD_LOGIC_VECTOR(15 downto 0);
		sel : IN STD_LOGIC_VECTOR(3 downto 0);
		s : OUT STD_LOGIC_VECTOR(15 downto 0));
END COMPONENT;

COMPONENT RegNbits IS
GENERIC(N : positive := 4);
PORT(D : IN STD_LOGIC_VECTOR(N-1 downto 0);
	  Q : OUT STD_LOGIC_VECTOR(N-1 downto 0);
	  Clk : IN STD_LOGIC;
	  Rst : IN STD_LOGIC;
	  Enable : IN STD_LOGIC);
END COMPONENT;

COMPONENT ALU IS
PORT( A, B: IN STD_LOGIC_VECTOR(15 downto 0);
		sel : IN STD_LOGIC_VECTOR(2 downto 0);
		s : OUT STD_LOGIC_VECTOR(15 downto 0));
END COMPONENT;

COMPONENT controlUnitFsm IS
PORT( clk, reset, run : IN STD_LOGIC;
		IR : IN STD_LOGIC_VECTOR(8 downto 0);
		BusSel : OUT STD_LOGIC_VECTOR(3 downto 0);
		Done, IRs, R0s, R1s, R2s, R3s, R4s : OUT STD_LOGIC;
		R5s, R6s, R7s, As, Gs : OUT STD_LOGIC;
		opeChoice : OUT STD_LOGIC_VECTOR(2 downto 0));
END COMPONENT;

COMPONENT counter2 IS
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ROM IS
	PORT(address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END COMPONENT;

	
SIGNAL IRsortie, IRe : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL BusSelec : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL IRs, R0s, R1s, R2s, R3s, R4s : STD_LOGIC;
SIGNAl R5s, R6s, R7s, As, Gs : STD_LOGIC;
SIGNAl dataBusSignal : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL R0sortie, R1sortie, R2sortie, R3sortie, R4sortie, R5sortie, R6sortie, R7sortie : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL Asortie, Gsortie : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL ALUsortie : STD_LOGIC_VECTOR(15 downto 0);

SIGNAL counterValue, addressValue : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL romValue : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL choiceope : STD_LOGIC_VECTOR(2 downto 0);

BEGIN

Din <= romValue;
counterValueVision <= counterValue;

IRsortieVision <= IRsortie;
dataBus <= dataBusSignal;
BusSelvision <= BusSelec;

R0vision <= R0sortie;
R1vision <= R1sortie;

IRe <= romValue(15 downto 7);


coucounter : counter2 PORT MAP(aclr => counterClear, clock => counterClock, q => counterValue );

memory : ROM PORT MAP ( address=>counterValue, clock=>counterClock, q=>romValue );

IR : RegNbits GENERIC MAP(N => 9)
              PORT MAP( D => IRe, Q => IRsortie, Clk => Clk, Rst => Reset_n, Enable => IRs);

R0 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R0sortie, Clk => Clk, Rst => Reset_n, Enable => R0s);
R1 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R1sortie, Clk => Clk, Rst => Reset_n, Enable => R1s);
R2 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R2sortie, Clk => Clk, Rst => Reset_n, Enable => R2s);
R3 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R3sortie, Clk => Clk, Rst => Reset_n, Enable => R3s);
R4 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R4sortie, Clk => Clk, Rst => Reset_n, Enable => R4s);
R5 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R5sortie, Clk => Clk, Rst => Reset_n, Enable => R5s);
R6 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R6sortie, Clk => Clk, Rst => Reset_n, Enable => R6s);
R7 : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => R7sortie, Clk => Clk, Rst => Reset_n, Enable => R7s);
A : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => dataBusSignal, Q => Asortie, Clk => Clk, Rst => Reset_n, Enable => As);
G : RegNbits GENERIC MAP(N => 16)
              PORT MAP( D => ALUsortie, Q => Gsortie, Clk => Clk, Rst => Reset_n, Enable => Gs);				  

Mux : mux_10v1_16bits PORT MAP( a=>R0sortie, b=>R1sortie, c=>R2sortie, d=>R3sortie, e=>R4sortie, 
                                f=>R5sortie, g=>R6sortie, h=>R7sortie, i=>romValue, j=>Gsortie,
										  sel => BusSelec, s => dataBusSignal );

ALUcomp : ALU PORT MAP( A => Asortie, B => dataBusSignal, sel => choiceope, s => ALUsortie );										  
				
controlUnit : controlUnitFSM PORT MAP(clk => Clk, IR => IRsortie, BusSel => BusSelec, Run => run, 
Done => Done, IRs => IRs, R0s=>R0s, R1s=>R1s, R2s=>R2s, R3s=>R3s, R4s=>R4s,
R5s => R5s, R6s=>R6s, R7s=>R7s, As=>As, Gs=>Gs, opeChoice=>choiceope, reset => Reset_n);

END arch;

