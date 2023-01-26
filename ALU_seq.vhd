
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity ALU_seq is
    Port ( 
	 
				A : in  	signed 	(3 downto 0);
				B : in  	signed 	(3 downto 0);
				S : in  	unsigned (2 downto 0);
				F : out  signed 	(3 downto 0)
			);
end ALU_seq;

architecture Behavioral of ALU_seq is
begin
process(A,B,S)
	begin 
		case S is 
		
			when "000" => F <= (others=>'0');
			when "100" => F <= B-A ;
			when "010" => F <= A-B;
			when "110" => F <= A+B;
			when "001" => F <= A xor B;
			when "101" => F <= A or B;
			when "011" => F <= A and B;
			when others => F <= "1111";
			
		end case;
	end process;
end Behavioral;

