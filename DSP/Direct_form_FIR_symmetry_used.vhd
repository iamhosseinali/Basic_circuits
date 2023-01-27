----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:40:58 12/16/2021 
-- Design Name: 
-- Module Name:    Direct_form_FIR - Behavioral 
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

entity Direct_form_FIR_symmetry_used is
    Port ( 
	 
				Input_signal  	: in  signed (13 downto 0);
				Output_signal  : out  signed (13 downto 0);
				clock 			: in  STD_LOGIC
				
				
			);
end Direct_form_FIR_symmetry_used;

architecture Behavioral of Direct_form_FIR_symmetry_used is

	--- registering inputs --- 
signal Input_signal_int : signed (13 downto 0) := (others =>'0');
	
	
	--- registering outputs --- 
signal Output_signal_int : signed (13 downto 0) := (others =>'0');

	
	
	--- internal signals--
signal 	FIR_accumulator	: signed (23 downto 0) := (others => '0');	
		
		--coefficients--
constant 	coef_b0		: signed (8 downto 0) := to_signed(31,9);
constant 	coef_b1		: signed (8 downto 0) := to_signed(87,9);

		----delay line registers---- 
signal Input_signal_D1 	: signed (13 downto 0) := (others =>'0');
signal Input_signal_D2 	: signed (13 downto 0) := (others =>'0');
signal Input_signal_D3 	: signed (13 downto 0) := (others =>'0');

		--- pipe line registers ---
signal product_Pipe0 	: signed (23 downto 0) := (others =>'0');
signal product_Pipe1 	: signed (23 downto 0) := (others =>'0');







begin

	Output_signal 				<= output_signal_int;

	process (clock)
	begin 
	
		if rising_edge (clock) then 
		
						--- inputs buffering---
			input_signal_int 		<= input_signal;
			
						--- delay lines--- 
			input_signal_D1		<= input_signal_int;
			input_signal_D2		<= input_signal_D1;
			input_signal_D3		<= input_signal_D2;
			
			
			
							--- FIR --- 
			product_Pipe0 			<= coef_b0 * (resize (input_signal_int,15) + input_signal_D3); 
			product_Pipe1 			<= coef_b0 * (resize (input_signal_D1,15) + input_signal_D2);		
			
			FIR_accumulator		<= product_Pipe0 + product_Pipe1;
			
			output_signal_int		<= FIR_accumulator(21 downto 8);	
		
		end if; 
		
	end process;

end Behavioral;

