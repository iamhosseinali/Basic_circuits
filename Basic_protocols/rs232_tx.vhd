----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:01 11/09/2021 
-- Design Name: 
-- Module Name:    rs232_tx - Behavioral 
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

entity rs232_tx is

generic 
(
baud_rate_9600 : unsigned (12 downto 0) := (to_unsigned(5206,13))

);
    Port ( 
	 
	 
	 
					Tx 		: out  	STD_LOGIC;
					busy 		: out  	STD_LOGIC;
					
					send 		: in  	STD_LOGIC;
					clock  	: in  	STD_LOGIC;
					data_in 	: in  	unsigned(7 downto 0)
					
			 );
end rs232_tx;

architecture Behavioral of rs232_tx is


	--- registering output signals --- 
	
	signal 	Tx_int	: std_logic := '0';
	signal	busy_int	: std_logic := '0';
	
	
	
	---reistrering input signals ----

	signal 	send_int			: std_logic := '0';
	signal	data_in_int		: unsigned (7 downto 0) := (others => '0');

	
	
	----internal signals ---
	
	signal 	send_int_prev		: std_logic 	:= '0'; 
	signal 	parity				: std_logic 	:= '0'; 
	signal 	creating_parity	: std_logic 	:= '0'; 
	signal 	creating_packet	: std_logic 	:= '0'; 
	signal 	start_sending		: std_logic 	:= '0'; 
	signal 	packet				: unsigned	(11 downto 0) 	:= (others	=> '0'); 
	signal	clock_counter		: unsigned 	(12 downto 0) 	:= (others 	=> '0');
	signal	bit_width_counter	: unsigned 	(3 downto 0) 	:= (others 	=> '0');
	
	

begin

	Tx 	<= Tx_int;
	busy	<= busy_int;
	
		process(clock)
		begin 
		
			if rising_edge (clock) then
				
				data_in_int			<= data_in;
				send_int 			<= send;
				send_int_prev		<= send_int;
				clock_counter 		<= clock_counter +1;
				Tx_int				<= '1';
				creating_packet	<= '0';
				
				if  (clock_counter = baud_rate_9600 ) then 
					
					clock_counter 			<= (others => '0');
					bit_width_counter		<= bit_width_counter +1;
				
				end if; 
				
				
				if (send_int = '1' and send_int_prev = '0' and busy_int ='0') then 
				
					busy_int 			<= '1';
					parity 				<= data_in_int(0) xor data_in_int(1) xor data_in_int(2) xor data_in_int(3)
												xor data_in_int(4) xor data_in_int(5) xor data_in_int(6) xor data_in_int(0);
					creating_packet	<= '1';
					
				end if ;
				
				
				if (creating_packet = '1') then 
					
					packet 					<= '1' & '1' & parity & data_in_int & '0' ; 
					start_sending			<= '1';
					bit_width_counter		<= (others=> '0');
					clock_counter 			<= (others=> '0');

				
				end if ;
				
				
				if (start_sending = '1') then 
				
					Tx_int		<= packet(to_integer(bit_width_counter));
					
				end if;
				
				
				if (bit_width_counter = to_unsigned (11,4)) then 
				
					bit_width_counter 		<= (others => '0');
					busy_int 					<= '0';
					start_sending 				<= '0';
					
				end if ;
					
			end if;
		end process;
	


end Behavioral;

