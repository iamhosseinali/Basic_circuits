----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:40 09/19/2021 
-- Design Name: 
-- Module Name:    BCD_7segment - Behavioral 
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

entity BCD_7segment is
    Port 
	 
	 ( 		BCD 					: in  	unsigned (3 downto 0);
				Seven_Segment_Int : out  	unsigned (7 downto 0)
			  
	 );

end BCD_7segment;

architecture Behavioral of BCD_7segment is

begin


		process(BCD)
		begin 
		
		case BCD is 
			
			when "0000" =>
					Seven_Segment_Int	<=	"00111111";
					
			when "0001" =>
					Seven_Segment_Int	<=	"00000110";
					
			when "0010" =>
					Seven_Segment_Int	<=	"01011011";

			when "0011" =>
					Seven_Segment_Int	<=	"01001111";

			when "0100" =>
					Seven_Segment_Int	<=	"01100110";

			when "0101" =>
					Seven_Segment_Int	<=	"01101101";

			when "0110" =>
					Seven_Segment_Int	<=	"01111101";

			when "0111" =>
					Seven_Segment_Int	<=	"00000111";

			when "1000" =>
					Seven_Segment_Int	<=	"01111111";

			when "1001" =>
					Seven_Segment_Int	<=	"01100111";

			when others =>
					Seven_Segment_Int	<=	"00000000";
			
		end case;
			
			
		end process;



end Behavioral;

