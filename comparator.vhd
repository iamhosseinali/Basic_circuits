----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:50:18 09/12/2021 
-- Design Name: 
-- Module Name:    comparator - Behavioral 
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is
    Port ( 
	 
	 
				A : in  unsigned (3 downto 0);
				B : in  unsigned (3 downto 0);
				AGB : out  STD_LOGIC;
				AEB : out  STD_LOGIC;
				ALB : out  STD_LOGIC);

end comparator;

architecture Behavioral of comparator is

begin

		AGB <= '1' when A>B else
		'0';
		
		AEB <= '1' when A=B else
		'0';
			
		ALB <= '1' when A<B else
		'0';

end Behavioral;

