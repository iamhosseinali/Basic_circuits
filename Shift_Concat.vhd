----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:30:31 09/26/2021 
-- Design Name: 
-- Module Name:    Shift_Concat - Behavioral 
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

entity Shift_Concat is
    Port ( 
	 
	 
				input  			:	in  STD_LOGIC;
				output 			: 	out  unsigned (7 downto 0);
				load  			: 	in  STD_LOGIC;
				reset  			: 	in  STD_LOGIC;
				parallel_in  	: 	in  unsigned (7 downto 0);
				clock  			: 	in  STD_LOGIC
				
			);
end Shift_Concat;

architecture Behavioral of Shift_Concat is

 signal shift : unsigned (7 downto 0) := (others => '0');
 
begin

output <= shift ;

	

	process(clock)
	begin 
	
		if rising_edge(clock) then 
		
		
			-- right shift 
			shift <= input & shift(7 downto 1);
			
			-- left shift 
			--shift <= shift (6 downto 0) & input;
			
			-- rotational right shift 
			--shift <= shift(0) & shift (7 downto 1);
			
			-- rotational left shift 
			--shift <= shift (6 downto 0) & shift (7);
		
		
		end if;
		
		
	end process;


end Behavioral;

