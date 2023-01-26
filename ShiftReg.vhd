----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:55:02 09/25/2021 
-- Design Name: 
-- Module Name:    ShiftReg - Behavioral 
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

entity ShiftReg is
    Port ( 
	 
	 
					input    	: in  STD_LOGIC;
					parallel_in : in  unsigned (7 downto 0);
					load  		: in  STD_LOGIC;
					reset  		: in  STD_LOGIC;
					clock  		: in  STD_LOGIC;
					output  		: out  unsigned (7 downto 0)
			  
			  );
end ShiftReg;

architecture Behavioral of ShiftReg is

	signal fakeoutput : unsigned (7 downto 0) := (others => '0');

begin

output <= 	fakeoutput  ;


	process(clock)
	begin 
	
		if (rising_edge (clock)) then 
		
			fakeoutput(7) <= input ;
			fakeoutput(6) <= fakeoutput(7);
			fakeoutput(5) <= fakeoutput(6);
			fakeoutput(4) <= fakeoutput(5);
			fakeoutput(3) <= fakeoutput(4);
			fakeoutput(2) <= fakeoutput(3);
			fakeoutput(1) <= fakeoutput(2);
			fakeoutput(0) <= fakeoutput(1);
		
		
		if (load = '1') then 
			
			fakeoutput <= parallel_in;
			
		end if;
		
		
		if (reset = '1') then 
		
			fakeoutput <= (others => '0');
			
		end if ;
			
		
		
		
		
		end if ;
	end process;


end Behavioral;

