library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debounce_Top is
    Port ( 
					Clock 			: in  STD_LOGIC;
					Push_Button 	: in  STD_LOGIC;
					Seven_Segment	: out	unsigned (7 downto 0)
			  );
end Debounce_Top;

architecture Behavioral of Debounce_Top is

	signal	Push_Button_Int			:	std_logic						:=	'0';
	signal	Push_Button_Prev			:	std_logic						:=	'0';
	signal	Debounce_State				:	std_logic						:=	'0';
	signal	Seven_Segment_Int			:	unsigned	(7 downto 0)		:=	(others=>'0');
	signal	BCD_Digit					:	unsigned	(3 downto 0)		:=	(others=>'0');
	signal	Debounce_Counter			:	unsigned	(25 downto 0)		:=	(others=>'1');
	
begin

	Seven_Segment						<=	Seven_Segment_Int;
	
	process(Clock)
	begin
	
		if rising_edge(Clock) then
		
			Push_Button_Int			<=	Push_Button;
			Push_Button_Prev			<=	Push_Button_Int;
			Debounce_State				<=	'0';
			
			if (Push_Button_Int = '0' and Push_Button_Prev = '1' and Debounce_State = '0') then
			
				BCD_Digit				<=	BCD_Digit + 1;
				Debounce_State			<=	'1';
				Debounce_Counter		<=	(others=>'0');
				
				if (BCD_Digit = to_unsigned(9,4)) then
					BCD_Digit			<=	(others=>'0');
				end if;
				
			end if;

			if (Push_Button_Int = '1' and Push_Button_Prev = '0' and Debounce_State = '0') then

				Debounce_State			<=	'1';
				Debounce_Counter		<=	(others=>'0');
			
			end if;
			
			if (Debounce_Counter < to_unsigned(10000000,26)) then
			
				Debounce_Counter		<=	Debounce_Counter + 1;
				Debounce_State			<=	'1';
			
			end if;
		
			case BCD_Digit is
			
				when "0000" =>
					Seven_Segment_Int  <= "00111111";
				when "0001" =>
					Seven_Segment_Int  <= "00000110";
				when "0010" =>
					Seven_Segment_Int  <= "01011011";
				when "0011" =>
					Seven_Segment_Int  <= "01001111";
				when "0100" =>
					Seven_Segment_Int  <= "01100110";
				when "0101" =>
					Seven_Segment_Int  <= "01101101";
				when "0110" =>
					Seven_Segment_Int  <= "01111101";
				when "0111" =>
					Seven_Segment_Int  <= "00000111";
				when "1000" =>
					Seven_Segment_Int  <= "01111111";
				when "1001" =>
					Seven_Segment_Int  <= "01101111";
				when others =>
					Seven_Segment_Int  <= "00000000";
			
			end case;	
		
		end if;
	
	end process;

end Behavioral;