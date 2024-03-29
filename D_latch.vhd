----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:37:50 09/21/2021 
-- Design Name: 
-- Module Name:    D_latch - Behavioral 
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

entity D_latch is
    Port (

				D 		: 		in  	STD_LOGIC;
				clk  	: 		in  	STD_LOGIC;
				Q 		: 		out  	STD_LOGIC
				
			);

end D_latch;

architecture Behavioral of D_latch is

begin

	process(clk,D)
	begin 
	
		if (clk = '1') then 
		
			Q <= D;
			
		end if;
		
	end process;
	
	


end Behavioral;

