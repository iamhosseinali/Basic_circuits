----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:31:07 09/18/2021 
-- Design Name: 
-- Module Name:    decoder_2_4_seq - Behavioral 
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

entity decoder_2_4_seq is
    Port (

				x : in  unsigned(1 downto 0);
           en : in  STD_LOGIC;
           y : out  unsigned(3 downto 0)
			  
			  );
           
end decoder_2_4_seq;

architecture Behavioral of decoder_2_4_seq is

begin


	process(x,en) 
	begin 
				

			case x is 
			when	 	"00" => y <= "0001";
			when	 	"01" => y <= "0010";
			when 		"10" => y <= "0100";
			when others   => y <= "1000";
			end case;
			
			if en = '0' then 
			 y <= "0000";
			 end if;
			
					
					
					
					
	end process;
	
	
	


end Behavioral;

