----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:48:21 12/24/2021 
-- Design Name: 
-- Module Name:    TP_IIR_II_SOS - Behavioral 
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

entity TP_IIR_II_SOS is
    Port ( 
	 
					clock 	: 	in  STD_LOGIC;
					input 	: 	in  signed (13 downto 0);
					output 	: out  signed (14 downto 0)
			  
			  
			 );
end TP_IIR_II_SOS;

architecture Behavioral of TP_IIR_II_SOS is

		--- registering inputs --- 
		signal 		input_int 		: signed (13 downto 0) := (others => '0');
		
		--- registering outputs --- 
		signal 		output_int 		: signed (14 downto 0) := (others => '0');
		
		
				---- scaling factor --- 
				
		constant   scale_factor 	: signed (12 downto 0) := to_signed (11,13);
		
		
				--- internal signals ---
		signal 		input_scaled	: signed (26 downto 0) := (others => '0');
		signal 		couple			: signed (14 downto 0) := (others => '0');
				

begin

BiQuadfilter0: entity work.BiQuad 

generic map (
		
		b0 		=> 2048,
		b1 		=> 1407,
		b2 		=> 2048,
		
		a1			=> 2985,
		a2			=> -1108
		

)


PORT MAP(


		clock => clock,
		input => input_scaled(25 downto 12),
		output => couple 
	);
	
	
BiQuadfilter1: entity work.BiQuad 
generic map (
		
		b0 		=> 2048,
		b1 		=> -1965,
		b2 		=> 2048,
		
		a1			=> 3481,
		a2			=> -1621
		

)


PORT MAP(
		clock => clock,
		input => resize(couple,14),
		output => output_int  
	);
	
input_scaled 			<= input_int * scale_factor;
output					<= output_int;

	process(clock)
	begin 
		if rising_edge (clock) then 
			
			input_int 			<= input;
		
		
		
		end if;
	end process;

end Behavioral;

