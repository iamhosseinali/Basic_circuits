----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:44:53 09/14/2021 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    Port (

					A : in  signed (3 downto 0);
					B : in  signed (3 downto 0);
					S : in  unsigned (2 downto 0);
					F : out  signed (3 downto 0));
end ALU;

architecture Behavioral of ALU is

begin

		F <= (others=>'0') 	when S = "000" else 
			   B-A 				when S = "100" else
				A-B 				when S = "010" else 
				A+B 				when S = "110" else 
				A xor B 			when S = "001" else 
				A or B 			when S = "101" else 
				A and B 			when S = "011" else 
				(others=>'1');
				
			

end Behavioral;

