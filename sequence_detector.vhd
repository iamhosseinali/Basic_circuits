----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:38 09/26/2021 
-- Design Name: 
-- Module Name:    sequence_detector - Behavioral 
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

entity sequence_detector is
    Port ( 
	 
				input  	: in  STD_LOGIC;
				clock  	: in  STD_LOGIC;
				alarm  	: out  STD_LOGIC
				
				
				
			);
end sequence_detector;

architecture Behavioral of sequence_detector is

	signal shift : unsigned(4 downto 0):= (others=> '0');
	
begin



	process(clock)
	begin 
	
		if rising_edge(clock) then 
		
		shift <= input & shift (4 downto 1);
				alarm <= '0';

			if (shift = "10011") then 
				alarm <= '1';
		 
			end if;
		
		
		end if;
		
		
		
	
	
	
	
	end process;


end Behavioral;

