----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:44:23 09/16/2021 
-- Design Name: 
-- Module Name:    Mux4-1sequential - Behavioral 
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

entity Mux4_1sequential is
    Port ( w0 : in  STD_LOGIC;
           w1 : in  STD_LOGIC;
           w2 : in  STD_LOGIC;
           w3 : in  STD_LOGIC;
           S : in  unsigned (1 downto 0);
           F : out  STD_LOGIC);
end Mux4_1sequential;

architecture Behavioral of Mux4_1sequential is
		
	

begin

 F <= w0 when s = "00" else 
		w1 when s = "01" else 
		w2 when s = "10" else 
		w3 when s = "11" else
		'0';
		



--	process(w0,w1,w2,w3,s)
--	begin 
--		
--		F <= w3;
--		
--		if 	s = "00" then
--			F <= w0;
--		elsif s = "01" then 
--			F <= w1;
--		elsif s = "10" then 
--			F <= w2;
--		end if;
--		
--	end process;
--		


end Behavioral;

