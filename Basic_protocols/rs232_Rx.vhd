----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:18 11/09/2021 
-- Design Name: 
-- Module Name:    rs232_Rx - Behavioral 
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

				---baud rate 				= 9600
				---bit width 				= 104 us 
				---clock 					= 50 Mhz 
				---perioed 					= 20 ns 
				---clocks per bitwidth 	= 5207

entity rs232_Rx is

generic 
(
baud_rate_9600 : unsigned (12 downto 0) := (to_unsigned(5206,13));
half_baud_rate_9600	: unsigned (11 downto 0) := (to_unsigned(2603,12))

);
    Port 
	 
	 ( 
	 
				Rx 			: in  	STD_LOGIC;
				clock 		: in  	STD_LOGIC;
				
				data_out 	: out  	unsigned (7 downto 0);
				valid  		: out  	STD_LOGIC
				
		);
end rs232_Rx;

architecture Behavioral of rs232_Rx is


	---registering input signals ----

	signal 		Rx_int 	: std_logic 	:= '0'; 

	---registering output signals----

	signal 		data_out_int	: unsigned (15 downto 0) := (others => '0');
	signal 		valid_int 		: std_logic := '0';

	---internal signals ---
	signal	clock_counter						: unsigned 	(12 downto 0) 	:= (others 	=> '0');
	signal	bit_width_counter					: unsigned 	(3 downto 0) 	:= (others 	=> '0');
	signal	Rx_int_prev							: std_logic := '0';
	signal	packet_detection					: std_logic := '0';
	signal	find_half_bit_state				: std_logic := '0';
	signal	parity								: std_logic := '0';
	signal	valid_parity						: std_logic := '0';

		

begin

	data_out 		<= data_out_int(7 downto 0);
	valid 			<= valid_int;
	valid_parity 	<= data_out_int(0) xor data_out_int(1) xor data_out_int(2) xor data_out_int(3) xor data_out_int(4) xor 
	data_out_int(5) xor data_out_int(6) xor data_out_int(7);  
	
	process(clock)
	begin
	
		if rising_edge (clock) then
		
				Rx_int 				<= Rx;
				Rx_int_prev			<= Rx_int;
				clock_counter		<= clock_counter +1;
				valid_int			<= '0';

				
				if  (clock_counter = baud_rate_9600 ) then 
					
					clock_counter 													<= (others => '0');
					bit_width_counter												<= bit_width_counter +1;
					data_out_int(to_integer (bit_width_counter)) 		<= Rx_int; 
					parity															<= parity xor Rx_int; 

				end if;
				
				
				---start bit detection----
				
				if (Rx_int = '0' and Rx_int_prev = '1' and packet_detection = '0') then
					
					clock_counter 			<= (others => '0');
					bit_width_counter		<= (others => '0');
					packet_detection 		<= '1';
					find_half_bit_state	<= '1';
					parity					<= '0';
				
				end if ;
				
				
				---stop bit detection---
				
				if (bit_width_counter = to_unsigned(9,4) and packet_detection = '1') then 
					
					packet_detection 				<= '0';
					valid_int 						<= not parity;
				
				end if; 
				
				---- half bit detection ---
				
				if (find_half_bit_state = '1' and clock_counter = half_baud_rate_9600 ) then 
				
					clock_counter 						<= (others => '0');
					find_half_bit_state 				<= '0';

				end if ;
		end if;
	end process;

end Behavioral;

