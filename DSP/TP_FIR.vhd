----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:58:12 12/19/2021 
-- Design Name: 
-- Module Name:    TP_FIR - Behavioral 
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

entity TP_FIR is
    Port ( 
	 
				Input 	: in  signed (13 downto 0);
				Output 	: out  signed (13 downto 0);
				clock 	: in  STD_LOGIC
				
				
			);
end TP_FIR;

architecture Behavioral of TP_FIR is

				---- registering inputs --- 
	signal 	Input_int	: signed(13 downto 0) := (others => '0');
	
				---registering outputs ---
	signal 	Output_int	: signed(13 downto 0) := (others => '0');
					
				--- delay lines  ---- 
	signal 		D0			: signed(22 downto 0) := (others => '0');
	signal 		D1			: signed(22 downto 0) := (others => '0');
	signal 		D2			: signed(22 downto 0) := (others => '0');

				---- coefficients --- 
	constant 	b0			: signed (8 downto 0) := to_signed (31,9);
	constant 	b1			: signed (8 downto 0) := to_signed (87,9);
	constant 	b2			: signed (8 downto 0) := to_signed (87,9);
	constant 	b3			: signed (8 downto 0) := to_signed (31,9);
	
					---- products ---- 
	signal 	product0		: signed (22 downto 0) := (others => '0');
	signal 	product1		: signed (22 downto 0) := (others => '0');
	signal 	product2		: signed (22 downto 0) := (others => '0');
	signal 	product3		: signed (22 downto 0) := (others => '0');
	
					--- accumulators---
	signal 	acc0			: signed (22 downto 0) := (others => '0');
	signal 	acc1			: signed (22 downto 0) := (others => '0');
	signal 	acc2			: signed (22 downto 0) := (others => '0');

					
				

begin

	output 		<= output_int;
	
	process(clock)
	begin 
		if rising_edge (clock) then
			input_int 		<= input;
		
			Acc0				<=  D0 + b0 * input_int;
			Acc1 				<=  D1 + b1 * input_int;
			Acc2				<=	 D2 + b2 * input_int;

			D0					<= Acc1;
			D1					<= Acc2;
			D2					<=	b3 * input_int;
			output_int		<= acc0(21 downto 8);
			
		
			--- pipe lin used ----			

--			product0			<= b0 * input_int;
--			product1			<= b1 * input_int;
--			product2			<= b2 * input_int;
--			product3			<= b3 * input_int;
--			
--			D2 				<= product0;
--			Acc2				<= D2 + product1;
--			D1					<= Acc2;
--			
--			
--			Acc1				<= D1 + product1;
--			D0					<= Acc1;
--			
--			Acc0				<= D0 + product0;
			

		
		end if; 
		
	end process;


end Behavioral;

