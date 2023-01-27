----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:10:20 01/03/2022 
-- Design Name: 
-- Module Name:    Moving_average - Behavioral 
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

entity Moving_average is
    Port ( 
			
			clock 			: in  	std_logic;
			input_signal 	: in  	signed (13 downto 0);
         Output_signal 	: out  	signed (13 downto 0)
			
			);
end Moving_average;

architecture Behavioral of Moving_average is

				-- registering inputs ----
		
		signal input_signal_int 			: signed (13 downto 0) := (others => '0');
		
				--- refistering outputs ---
		
		signal output_signal_int 			: signed (13 downto 0) := (others => '0');
		
		
				--- internal signals --- 
		
		signal input_signal_D1				: signed (13 downto 0) := (others => '0');
		signal input_signal_D2				: signed (13 downto 0) := (others => '0');
		signal input_signal_D3				: signed (13 downto 0) := (others => '0');
		signal input_signal_D4				: signed (13 downto 0) := (others => '0');
		signal ACC								: signed (15 downto 0) := (others => '0');
		
		

begin

output_signal				<= output_signal_int;

	process(clock) 
	begin 
		if rising_edge (clock) then
		
			input_signal_int				<= input_signal;
			input_signal_D1				<= input_signal_int;
			input_signal_D2				<= input_signal_D1;
			input_signal_D3				<= input_signal_D2;
			input_signal_D4				<= input_signal_d3;
			
			ACC								<= ACC + input_signal_int - input_signal_D4;
			output_signal_int				<= ACC(15 downto 2);
		
		
		
		end if;
	end process;


end Behavioral;

