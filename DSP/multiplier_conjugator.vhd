----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:51:55 12/30/2021 
-- Design Name: 
-- Module Name:    multiplier_conjugator - Behavioral 
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

entity multiplier_conjugator is
    Port ( 
						real_input 		: in 		signed (15 downto 0);
						imag_input 		: in  	signed (15 downto 0);
						real_input1 	: in 	 	signed (15 downto 0);
						imag_input1 	: in  	signed (15 downto 0);
						real_output 	: out  	signed (24 downto 0);
						imag_output 	: out  	signed (24 downto 0);
						
						clock 			: in  	STD_LOGIC
						
				);
end multiplier_conjugator;

architecture Behavioral of multiplier_conjugator is

			--- registering inputs -- 
		signal 		real_input_int				: signed (15 downto 0) := (others =>'0');
		signal 		imag_input_int				: signed (15 downto 0) := (others =>'0');
		signal 		real_input1_int			: signed (15 downto 0) := (others =>'0');
		signal 		imag_input1_int			: signed (15 downto 0) := (others =>'0');
		
			--- registering outputs--- 
			
		signal 		real_output_int			: signed (32 downto 0) := (others =>'0');
		signal 		imag_output_int			: signed (32 downto 0) := (others =>'0');
		
	
	
				--- internal signal --- 
		
		signal 		XrYr			: signed (31 downto 0) := (others =>'0');
		signal 		XiYi			: signed (31 downto 0) := (others =>'0');
		
		signal 		XrYi			: signed (31 downto 0) := (others =>'0');
		signal 		XiYr			: signed (31 downto 0) := (others =>'0');
		
		
	
	

begin

	real_output				<= real_output_int(31 downto 7);
	imag_output				<= imag_output_int(31 downto 7);
	
	
			process(clock)
			begin 
			
				if rising_edge (clock) then 
				
					real_input_int				<= real_input;
					imag_input_int				<= imag_input;
					real_input1_int			<= real_input1;
					imag_input1_int			<= imag_input1;
					
					
					XrYr							<= real_input_int * real_input1_int;
					XiYi							<= imag_input_int * imag_input1_int;
					
					XrYi							<= real_input_int * imag_input1_int;
					XiYr							<= imag_input_int * real_input1_int;
					
					real_output_int			<= resize(XrYr,33) + XiYi; --- turning "-" to "+" makes it a conjugator
					imag_output_int			<= resize(XrYi,33) - XiYr; --- turning "+" to "-" makes it a conjugator
				
				end if;
				
			end process;

end Behavioral;

