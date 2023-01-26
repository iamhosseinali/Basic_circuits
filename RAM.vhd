----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:40:56 10/12/2021 
-- Design Name: 
-- Module Name:    block_ram - Behavioral 
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

entity block_ram is

generic (
   address_width 	: integer := 4;
   ram_width 		: integer := 8  
);
    Port ( 
	 
				clock 		: in  STD_LOGIC;
				write_addr 	: in  unsigned (address_width -1 downto 0);
				read_addr 	: in  unsigned (address_width -1 downto 0);
				we 			: in  STD_LOGIC;
				ram_input 	: in  unsigned (ram_width -1 downto 0);
				ram_output 	: out unsigned (ram_width -1 downto 0)
				
			);
end block_ram;

architecture Behavioral of block_ram is

	type mem_type is array (0 to 2**address_width-1) of unsigned (ram_width -1 downto 0);
	signal mem_signal : mem_type := (others=>(others=>'0'));
	attribute ram_style : string;
	attribute  ram_style of mem_signal : signal is "block";

begin

process(clock)
	begin
		if rising_edge(clock) then
			if (WE = '1') then 
				mem_signal(to_integer (write_addr)) <= ram_input;
			end if; 
			
			ram_output <= mem_signal(to_integer(read_addr));
		
		
		end if; 
		
	end process;


end Behavioral;

