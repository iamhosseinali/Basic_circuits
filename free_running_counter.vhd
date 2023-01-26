----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:47:36 09/26/2021 
-- Design Name: 
-- Module Name:    free_running_counter - Behavioral 
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

entity free_running_counter is
    Port ( 
	 
	 
				reset  	: in  STD_LOGIC;
				clock 	: in  STD_LOGIC;
				up_down 	: in  STD_LOGIC;
				output  	: out  unsigned(3 downto 0)
				
			);
end free_running_counter;

architecture Behavioral of free_running_counter is


	signal counter : unsigned(3 downto 0) := (others => '0');
begin

output <= counter;

	process(clock)
	begin 
	
		if rising_edge (clock) then 
		
		-- up_down = 0 => down, up_down = 1 => up;
			
			counter <= counter -1;
			
			if (up_down = '1') then 
				counter <= counter +1;
			end if;
			
			if (reset = '1') then 
				counter <= (others=>'0');
			end if;
				
		
		
		end if;
		
	end process;


end Behavioral;

