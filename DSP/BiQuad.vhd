----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:53:52 12/24/2021 
-- Design Name: 
-- Module Name:    BiQuad - Behavioral 
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

entity BiQuad is


generic 

(

			--- feed forward --- 
		b0 				: integer := 12;
		b1 				: integer := 12;
		b2 				: integer := 12;
		
		
		
			--- feed back --- 
		a1 				: integer := 12;
		a2 				: integer := 12
		
);
    Port ( 
	 
					clock 	: in  STD_LOGIC;
					input 	: in  signed (13 downto 0);
					output 	: out  signed (14 downto 0));
end BiQuad;

architecture Behavioral of BiQuad is


		--- registering inputs --- 
		signal 		input_int 		: signed (13 downto 0) := (others => '0');
		
		--- registering outputs --- 
		signal 		output_int 		: signed (14 downto 0) := (others => '0');
		
			--- delay line --- 
		signal 		D0 				: signed (27 downto 0) := (others => '0');
		signal 		D1 				: signed (27 downto 0) := (others => '0');
		
			--- accumulator -- 
		signal 		allacc 			: signed (27 downto 0) := (others => '0');
	
		



begin

allacc 				<= D0 + input_int * to_signed (b0,13);
output_int 			<= allacc(25 downto 11);
output				<= output_int;


	process(clock)
	begin 
		if rising_edge (clock) then 
		
			input_int 		<= input;
			D0 				<= input_int * to_signed (b1,13) + output_int * to_signed (a1,13) + D1;
			D1 				<= input_int * to_signed (b2,13) + output_int * to_signed (a2,13);
		
		
		end if;
	end process;end Behavioral;

