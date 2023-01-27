----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:53:51 12/12/2021 
-- Design Name: 
-- Module Name:    am_modulator - Behavioral 
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

entity am_modulator is
    Port ( 
	 
				clock 	: in  STD_LOGIC;
				Output 	: out  signed (9 downto 0)
				
			);
end am_modulator;

architecture Behavioral of am_modulator is

	----registering outputs --- 
	signal 		output_int 	: signed (9 downto 0) := (others => '0');
	
	---- internal signals --- 
	signal 		cosine_94Hz	: std_logic_vector (6 downto 0) := (others => '0');
	signal 		sine_430KHz	: std_logic_vector (9 downto 0) := (others => '0');
	signal 		product		: signed (14 downto 0) := (others => '0');
	signal 		product1		: signed (18 downto 0) := (others => '0');
	signal 		sum			: signed (8 downto 0) := (others => '0');
	constant 	constant1	: signed (7 downto 0) := to_signed(26,8); --- '0.2'
	constant 	constant2	: signed (8 downto 0) := to_signed(128,9); ---'1'
	
	
	
	
COMPONENT dds_ip
  PORT (
    clk : IN STD_LOGIC;
    cosine : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
END COMPONENT;

COMPONENT dds_sine_ip
  PORT (
    clk : IN STD_LOGIC;
    sine : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;


begin

	cosine : dds_ip
  PORT MAP (
    clk => clock,
    cosine => cosine_94Hz
  );
  
  sine: dds_sine_ip
  PORT MAP (
    clk => clock,
    sine => sine_430KHz
  );
  
output			<= output_int;
  
process(clock)
begin 
  
	if rising_edge (clock) then 
		
		product		<= signed (cosine_94Hz) * constant1;
		sum			<= product(14 downto 6)+ to_signed(128,9);
		product1		<= sum * signed (sine_430KHz);
		output_int  <= product1(18 downto 9);
	
	end if;
	
end process;

	


end Behavioral;

