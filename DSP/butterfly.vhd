----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:48 10/11/2021 
-- Design Name: 
-- Module Name:    butterfly - Behavioral 
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

entity butterfly is
    Port (
	 
						---butterfly input ports----
				
				clock 		: in 		std_logic;
				x0_input_r 	: in  	signed (15 downto 0);
				x0_input_i 	: in  	signed (15 downto 0);
				x1_input_r 	: in  	signed (15 downto 0);
				x1_input_i 	: in  	signed (15 downto 0);
				
						
						---butterfly output ports----

				
				A_output_r 	: out  	signed (16 downto 0);
				A_output_i 	: out  	signed (16 downto 0);
				B_output_r 	: out  	signed (16 downto 0);
				B_output_i 	: out  	signed (16 downto 0));

end butterfly;

architecture Behavioral of butterfly is

begin

	process(clock)
	begin 
	
		if rising_edge(clock) then 
		A_output_r <= (resize(x0_input_r,17) + x1_input_r);
		A_output_i <= (resize(x0_input_i,17) + X1_input_i);
		
		B_output_r <= -(x1_input_r)+(resize(x0_input_r,17));
		B_output_i <= -(x1_input_i)+(resize(x0_input_i,17));

		
		
		end if;
		
		
	end process;


end Behavioral;

