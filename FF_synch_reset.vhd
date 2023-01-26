----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:12 09/23/2021 
-- Design Name: 
-- Module Name:    FF_synch_reset - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FF_synch_reset is


	 
	 Port ( 
	 
				D : in  STD_LOGIC;
				clock  : in  STD_LOGIC;
				Q : out  STD_LOGIC;
				set  : in  STD_LOGIC;
				reset  : in  STD_LOGIC);

end FF_synch_reset;

architecture Behavioral of FF_synch_reset is

begin


		process(clock)
		begin 
		
			
			if rising_edge (clock) then 
			
			
			   Q <= D;

				
				if (set = '1') then 
				Q <= '1';
				end if;
				
				
				if (reset = '1') then 
				Q <= '0';
				end if;
				
				
			 
			 
			end if;
			
	
		
		
		
		end process;


end Behavioral;

