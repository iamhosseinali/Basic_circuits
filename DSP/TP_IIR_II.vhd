----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:12:54 12/22/2021 
-- Design Name: 
-- Module Name:    TP_IIR_II - Behavioral 
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

entity TP_IIR_II is
    Port ( 
	 
	 
					Input 	: in  signed (13 downto 0);
					clock 	: in  STD_LOGIC;
					output  	: out  signed (14 downto 0)
					
			);
end TP_IIR_II;

architecture Behavioral of TP_IIR_II is

					--- registering inputs --- 
	signal 	input_int 	:	signed(13 downto 0) := (others =>'0');
	
					--- registering outputs --- 
	signal 	output_int 	:	signed(14 downto 0) := (others =>'0');
	
	
					---feed_forward coefficients---
	 constant 	b0			: signed (16 downto 0) := to_signed (44,17);
	 constant 	b1			: signed (16 downto 0) := to_signed (-12,17);
	 constant 	b2			: signed (16 downto 0) := to_signed (59,17);
	 constant 	b3			: signed (16 downto 0) := to_signed (-12,17);
	 constant 	b4			: signed (16 downto 0) := to_signed (44,17);
	 
	 
					---feed_back coefficients---
	constant 	a1			: signed (16 downto 0) := to_signed (51730,17);
	constant 	a2			: signed (16 downto 0) := to_signed (-62420,17);
	constant 	a3			: signed (16 downto 0) := to_signed (33962,17);
	constant 	a4			: signed (16 downto 0) := to_signed (-7013,17);
	
	
	
							--- delay lines ----
	signal 	D0 	:	signed(31 downto 0) := (others =>'0');
	signal 	D1 	:	signed(31 downto 0) := (others =>'0');
	signal 	D2 	:	signed(31 downto 0) := (others =>'0');
	signal 	D3 	:	signed(31 downto 0) := (others =>'0');
	
	
							--- internal signals --- 
	signal 	allacc 	:	signed(31 downto 0) := (others =>'0');
	signal 	acc0 		:	signed(31 downto 0) := (others =>'0');
	signal 	acc1 		:	signed(31 downto 0) := (others =>'0');
	signal 	acc2 		:	signed(31 downto 0) := (others =>'0');
	signal 	acc3 		:	signed(31 downto 0) := (others =>'0');
	signal 	acc4 		:	signed(31 downto 0) := (others =>'0');

							
							
	
	
					



begin


allacc			<= input_int * b0 + D0;
output_int		<= allacc(28 downto 14);
output			<= output_int;


	process(clock)
	begin 
	
		if rising_edge (clock) then 
		
			input_int 				<= input;
			D0 						<= input_int * b1 + output_int * a1 + D1;
			D1							<= input_int * b2 + output_int * a2 + D2;
			D2							<= input_int * b3 + output_int * a3 + D3;
			D3							<= input_int * b4 + output_int * a4;
			
		end if;
		
	end process;

end Behavioral;

