----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:55:44 09/01/2021 
-- Design Name: 
-- Module Name:    full_adder - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder is
    Port (
				A 		: in  	STD_LOGIC;
				B 		: in  	STD_LOGIC;
				Cin 	: in  	STD_LOGIC;
				Sum 	: out  	STD_LOGIC;
				Cout 	: out  	STD_LOGIC
				
			);

end full_adder;

architecture Behavioral of full_adder is

begin

	sum 	<= A xor B xor Cin;
	Cout	<= (A and B) or (A and Cin) or (B and Cin);
	
	


end Behavioral;


