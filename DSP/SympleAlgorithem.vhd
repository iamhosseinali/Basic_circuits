----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:48:35 12/09/2021 
-- Design Name: 
-- Module Name:    DSP1 - Behavioral 
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

entity DSP1 is
    Port ( 
	 
				input 	: in  signed (13 downto 0);
				output 	: out  signed (16 downto 0);
				clock 	: in  STD_LOGIC
				
			);
end DSP1;

architecture Behavioral of DSP1 is


COMPONENT dds
  PORT (
    clk : IN STD_LOGIC;
    sine : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

 --- registering inputs --- 
  signal		input_int		: signed (13 downto 0) := (others => '0');
  
  
  --- registering outputs ---
  signal		output_int		: signed (16 downto 0) := (others => '0');
  
  ---internal signals --- 
  signal 	sine_2MHz 		: STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
  signal 	stage1 			: signed (20 downto 0) := (others => '0');
  
  --- constansts --- 
  constant 	pi 				: signed (8 downto 0) := to_signed (201,9);


begin

sine_2MHz_generator : dds
  PORT MAP (
    clk => clock,
    sine => sine_2MHz
  );
  
output 		<= output_int;
  
  process (clock)
  begin 
		if rising_edge (clock) then
		
			input_int 		<= input;
			stage1			<= pi * signed (sine_2MHz); 
			output_int 		<= stage1(20 downto 4)+ input_int;	
		
		end if;
	end process;
	

  
  
 


end Behavioral;

