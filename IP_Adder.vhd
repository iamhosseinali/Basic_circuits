----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:25:51 09/28/2021 
-- Design Name: 
-- Module Name:    IP_Adder - Behavioral 
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

entity IP_Adder is


port 
(
	A_top		:in  		signed(15 downto 0);
	B_top		:in 		signed(15 downto 0);
	sum_top	:out		signed(16 downto 0);
	Add_top	:in		std_logic;
	clock		:in 		std_logic
	
	);
	
end IP_Adder;

architecture Behavioral of IP_Adder is

COMPONENT IP_Adder
  PORT (
    a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC;
    add : IN STD_LOGIC;
    s : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
  );
END COMPONENT;

signal sum_int : std_logic_vector (16 downto 0) := (others =>'0');

begin
sum_top <= signed(sum_int);

your_instance_name : IP_Adder
  PORT MAP (
    a 		=> 	std_logic_vector(a_top),
    b 		=> 	std_logic_vector(b_top),
    clk 		=> 	clock,
    add 		=> 	add_top,
    s 		=> 	sum_int
  );


end Behavioral;

