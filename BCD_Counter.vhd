----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:45:31 09/27/2021 
-- Design Name: 
-- Module Name:    BCD_Counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCD_Counter is
    Port ( 
	 
				UP_DOWN 					: in  STD_LOGIC;
				Reset  					: in  STD_LOGIC;
				clock  					: in  STD_LOGIC ;
				Seven_Segment_Int  	: out  unsigned (7 downto 0)
				
				
		);

end BCD_Counter;

architecture Behavioral of BCD_Counter is
	signal counter : unsigned (3 downto 0) := (others => '0');
	signal clockcounter : unsigned (3 downto 0) := (others => '0');
	
begin

	process(clock)
	begin 
	
		if rising_edge (clock) then 
		
			if (counter =  "0000") then 
			Seven_Segment_Int	<=	"00111111";
			elsif (counter =  "0001") then
			Seven_Segment_Int	<=	"00000110";
			elsif (counter =  "0010") then 
			Seven_Segment_Int	<=	"01011011";
			elsif (counter =  "0011") then 
			Seven_Segment_Int	<=	"01001111";
			elsif (counter =  "0100") then 
			Seven_Segment_Int	<=	"01100110";
			elsif (counter =  "0101") then 
			Seven_Segment_Int	<=	"01101101";
			elsif (counter =  "0101") then 
			Seven_Segment_Int	<=	"01111101";
			elsif (counter =  "0110") then 
		   Seven_Segment_Int	<=	"00000111";
			elsif (counter =  "0111") then 
			Seven_Segment_Int	<=	"01111111";
			elsif (counter =  "1000") then 
			Seven_Segment_Int	<=	"01100111";
			elsif (counter =  "1001") then 
			Seven_Segment_Int	<=	"00000000";
			end if; 

	clockcounter <= clockcounter +1;
										

		if (clockcounter = 9) then 

			
			counter <= counter -1;
		
		
			if (Up_Down = '1') then 
			counter <= counter +1;
			end if;
			
			if (reset = '1') then 
				counter <= (others => '0');
			end if ;
			
			clockcounter <= (others=> '0');
		end if; 
			
			
		
		
		
		
		end if ;
	
	
	
	
	
	
	
	end process;


end Behavioral;

