
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity FA_4bit is
    Port ( 
				A 		: in  	STD_LOGIC_VECTOR (3 downto 0);
				B 		: in  	STD_LOGIC_VECTOR (3 downto 0);
				Cin 	: in 		STD_LOGIC;
				Sum 	: out  	STD_LOGIC_VECTOR (3 downto 0);
				Cout  : out  	STD_LOGIC);
end FA_4bit;

architecture Behavioral of FA_4bit is


COMPONENT full_adder
	PORT(
		A : IN std_logic;
		B : IN std_logic;
		Cin : IN std_logic;          
		Sum : OUT std_logic;
		Cout : OUT std_logic
		);
	END COMPONENT;
	
 signal Carry : std_logic_vector (2 downto 0) := "000";


begin

		FA0: full_adder PORT MAP(
				A 			=> A(0),
				B 			=> B(0),
				Cin		=> Cin,
				Sum 		=> Sum(0),
				Cout 		=> Carry(0)
				);



		FA1: full_adder PORT MAP(
			A 			=> A(1),
			B 			=> B(1),
			Cin		=> Carry(0),
			Sum 		=> Sum(1),
			Cout 		=> Carry(1)
		);




		FA2: full_adder PORT MAP(
				A 			=> A(2),
				B 			=> B(2),
				Cin		=> Carry(1),
				Sum 		=> Sum(2),
				Cout 		=> Carry(2)
			);




		FA3: full_adder PORT MAP(
				A 			=> A(3),
				B 			=> B(3),
				Cin		=> Carry(2),
				Sum 		=> Sum(3),
				Cout 		=> Cout
			);



end Behavioral;

