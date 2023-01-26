----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:58:27 11/21/2021 
-- Design Name: 
-- Module Name:    SPI_controller - Behavioral 
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

entity SPI_controller is
		 Port ( 
					send  				: in  STD_LOGIC;
					clock 				: in  STD_LOGIC;
					data_in 				: in  unsigned (31 downto 0);
					MISO 					: in  STD_LOGIC;
					force_cs 			: in  STD_LOGIC; 		---	to specify whether u have an opcode or not 
																		--- 	'0' u dont have 
																		--- 	'1' u have 
					command_type  		: in  unsigned (1 downto 0);

					data_out 			: out  unsigned (7 downto 0);
					CS 					: out  STD_LOGIC;
					MOSI 					: out  STD_LOGIC;
					SClK 					: out  STD_LOGIC;
					busy 					: out  STD_LOGIC;
					data_out_valid  	: out  STD_LOGIC
					);
end SPI_controller;

architecture Behavioral of SPI_controller is


	--- registering input signals---
	
	signal 		send_int 			: std_logic	:= '0';
	signal 		force_cs_int  		: std_logic	:= '0';
	signal 		MISO_int		 		: std_logic	:= '0';
	signal 		command_type_int 	: unsigned (1 downto 0) := (others => '0');
	signal 		data_in_int		 	: unsigned (31 downto 0) := (others => '0');
	
	
	---registering output signals --
	
	signal 		CS_int 					: std_logic	:= '0';
	signal 		MOSI_int 				: std_logic	:= '0';
	signal 		SClK_int					: std_logic	:= '0';
	signal 		busy_int 				: std_logic	:= '0';
	signal 		data_out_valid_int	: std_logic	:= '0';
	signal 		data_out_int			: unsigned(7 downto 0) := (others =>'0');
	
	
	---internal signals---


	type 		SPI_data_in_width_array is array (0 to 3) of unsigned (4 downto 0);
	
	signal  	SPI_data_in_width : SPI_data_in_width_array := 
	(
	to_unsigned (7,5), 
	to_unsigned (15,5),
	to_unsigned (24,5),
	to_unsigned (31,5)
	);
	
	
	signal 	clock_counter 					: unsigned(4 downto 0) := (others => '0'); 
	signal 	CS_high_level_time 			: unsigned(1 downto 0) := (others => '1'); 
	signal 	send_int_pre 					: STD_LOGIC := '0'; 
	signal 	SCLK_enable 					: STD_LOGIC := '0'; 
	signal 	set_SCLK_enable 				: STD_LOGIC := '0'; 
	signal 	spi_write_state 				: STD_LOGIC := '0'; 
	signal 	force_cs_buff 					: STD_LOGIC := '0'; 
	signal 	the_end_state 					: STD_LOGIC := '0'; 
	signal 	opcode_byte_indicator 		: STD_LOGIC := '0'; 
	signal 	busy_int_pre 					: STD_LOGIC := '0'; 
	signal 	data_in_buff 					: unsigned(31 downto 0) := (others => '0'); 
	signal 	spi_data_in_width_buff 		: unsigned(4 downto 0) := (others => '0'); 
	signal 	spi_data_out_width_buff 	: unsigned(2 downto 0) := (others => '0'); 
	

begin

CS						<= CS_int and force_cs_buff;
MOSI					<= MOSI_int;
SCLK					<= SCLK_int and SCLK_enable;
data_out_valid		<= data_out_valid_int;
data_out				<= data_out_int;



	process(clock)
	begin
	
		if rising_edge (clock) then 
		
			--- creating SCLK --- 
			--- FPGA clock period 		= 8.33 ns 
			--- SCLK period 				= 50 ns 
			--- 6 clocks would create 	= 50 ns  
			
			send_int					<= send;
			send_int_pre			<= send_int;
			force_cs_int			<= force_cs;
			MISO_int					<= MISO;
			command_type_int		<= command_type;
			data_in_int				<= data_in;
			busy						<= busy_int;
			busy_int					<= busy_int_pre;
			clock_counter 			<=  clock_counter +1;
			SCLK_int					<= '1';
			data_out_valid_int	<= '0';
			CS_int 					<= '0';
			
			---writing state --- 
			
			if (clock_counter = to_unsigned(0,5) and spi_write_state = '1') then 
				
				---MSB first!!!
				MOSI_int 					<= data_in_buff(to_integer (spi_data_in_width_buff));
				spi_data_in_width_buff	<= spi_data_in_width_buff -1;
				SCLK_enable 				<=	set_SCLK_enable;

				if (spi_data_in_width_buff = to_unsigned(0,5)) then 
				
					the_end_state			<= '1';
			
				end if;

				if (the_end_state = '1') then 
				
					sclk_enable			<= '0';
					set_sclk_enable 	<= '0';
					spi_write_state	<= '0';
					the_end_state		<= '0';
					busy_int_pre		<= '0';
				
				end if;
			end if;
			
			--- reading state ---
			
			if (clock_counter = to_unsigned (5,5) and SCLK_enable = '1') then 
				
				data_out_int(to_integer (spi_data_out_width_buff)) 	<= MISO_int;
				spi_data_out_width_buff					  						<= spi_data_out_width_buff -1;
				
				
				if (spi_data_out_width_buff = to_unsigned(0,3)) then 
				
					data_out_valid_int 		<= (not opcode_byte_indicator) or (not force_cs_buff);
					opcode_byte_indicator	<= '0'; 
			
				end if;
			
			end if;
			
			
			if (clock_counter < to_unsigned(3,5)) then 

				SCLK_int 		<= '0';
			
			end if;
			
			if (clock_counter = to_unsigned(5,5)) then 
			
				clock_counter 		<= (others=> '0');
			
			end if;

			if (send_int = '1' and send_int_pre = '0' and busy_int_pre = '0') then 
			
				data_in_buff				<= data_in_int;
				force_cs_buff				<= force_cs_int;
				spi_data_in_width_buff 	<= spi_data_in_width(to_integer (command_type_int));
				busy_int_pre 				<= '1';
				CS_high_level_time 		<= (others=> '0');
				spi_data_out_width_buff	<= to_unsigned(7,3); 
				SCLK_enable					<= '0';
				set_SCLK_enable 			<= '1';
				spi_write_state			<= '1';
				clock_counter				<= (to_unsigned (1,5));	
				opcode_byte_indicator	<= '1';
			
			end if;
			
			if (CS_high_level_time < to_unsigned(2,2)) then 
			 
				CS_high_level_time 		<= CS_high_level_time + 1;
				CS_int						<= '1';
			
			end if;
		
		end if;
	end process;


end Behavioral;

