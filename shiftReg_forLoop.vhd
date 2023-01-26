----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:40:18 09/25/2021 
-- Design Name: 
-- Module Name:    shiftReg_forLoop - Behavioral 
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

entity shiftReg_forLoop is


 generic 
 (
 reg_width : integer := 8
 
 );
    Port ( 
	 
				parallel_in  : in  unsigned (reg_width-1 downto 0);
           load : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           output  : out  unsigned (reg_width-1 downto 0);
           input  : in  STD_LOGIC;
           clock  : in  STD_LOGIC
			  
			  
			  );
end shiftReg_forLoop;

architecture Behavioral of shiftReg_forLoop is

--signal I : integer :=0;

signal fakeoutput : unsigned(reg_width-1 downto 0) := (others=> '0');

begin

output <= fakeoutput;


	process (clock)
	begin 
	
		if (rising_edge (clock)) then 
		
			
			fakeoutput(reg_width-1) <= input; 
		
		
		
		for I in 0 to reg_width-2 loop
		
			fakeoutput(I) <= fakeoutput (I+1); 
		
		end loop;
		
		
		
		if (load = '1') then 
		
		fakeoutput <= parallel_in;
		
		end if; 
		
		
		
		if (reset = '1') then
		
		fakeoutput <= (others => '0');
		
		end if;
		
		
		
		end if;
	
	
	
	
	
	end process;

end Behavioral;

