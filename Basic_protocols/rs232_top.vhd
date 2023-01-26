----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:02:46 11/09/2021 
-- Design Name: 
-- Module Name:    rs232_top - Behavioral 
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

entity rs232_top is Port 

			( 
	 
	 
					data_out 	: out  	unsigned(7 downto 0);
					valid 		: out 	std_logic;
					send 			: in  	STD_LOGIC;
					clock  		: in  	STD_LOGIC;
					data_in 		: in  	unsigned(7 downto 0)
					
			 );
			 
end rs232_top;

architecture Behavioral of rs232_top is

component dcm
port
 (-- Clock in ports
  clock           	: in     std_logic;
  -- Clock out ports
  CLK_OUT1          	: out    std_logic;
  CLK_OUT2_CE       	: in     std_logic;
  CLK_OUT2          	: out    std_logic
 );
end component;

	---registering input signals---
	signal 	send_int			: 	std_logic := '0'; 
	signal 	data_in_int		: 	unsigned(7 downto 0) := (others=> '0'); 
	
	
	---registering output signals --- 
	signal 	data_out_int	:	unsigned(7 downto 0) := (others => '0');
	signal   valid_int 		:  std_logic	:= '0';
	
	
	---internal signals---
	signal 	clk_50				: std_logic	:= '0';
	signal 	clk_12				: std_logic	:= '0';
	signal 	clk_12_ce			: std_logic	:= '0';
	signal 	connection_signal	: std_logic	:= '0';
	

begin

	valid		<= valid_int;

	
clock_management : dcm
  port map
   (-- Clock in ports
    clock 			=> clock,
    -- Clock out ports
    CLK_OUT1 		=> CLK_50,
    CLK_OUT2_CE 	=> clk_12_ce,
    CLK_OUT2 		=> clk_12
	 );
	 
	 
rs232_tx: entity work.rs232_tx PORT MAP(
		Tx => connection_signal,
		busy => open,
		send => send,
		clock => clk_50,
		data_in => data_in
	);
	
	
rs232_Rx: entity work.rs232_Rx PORT MAP(
		Rx => connection_signal,
		clock =>clk_50,
		data_out => data_out,
		valid => valid_int
	);



end Behavioral;

