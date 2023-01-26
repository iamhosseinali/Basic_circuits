----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:44:22 09/11/2021 
-- Design Name: 
-- Module Name:    MUX_4_1_en_ - Behavioral 
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
use IEEE.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_4_1_en_ is
    Port (

				w0 	: 	in  STD_LOGIC;
				w1 	: 	in  STD_LOGIC;
				w2 	: 	in  STD_LOGIC;
				w3 	:	in  STD_LOGIC;
				en 	: 	in  STD_LOGIC;
				s 		: 	in  unsigned(1 downto 0);
				F 		: 	out  STD_LOGIC);

end MUX_4_1_en_;

architecture Behavioral of MUX_4_1_en_ is

	
	signal final : unsigned(2 downto 0) := (others =>'0'); 

begin

	final <= s & en;
	with final select 
	
		F <=  w0 when "001",
				w1 when "011",
				w2 when "101",
				w3 when "111",
				'0' when others;
					
end Behavioral;

