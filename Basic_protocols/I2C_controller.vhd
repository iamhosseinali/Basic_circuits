----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:00:05 11/29/2021 
-- Design Name: 
-- Module Name:    I2C_controller - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

entity I2C_controller is
 
    Port ( 
	 
				clock  			: in  STD_LOGIC;
				RW 				: in  STD_LOGIC; --- u wanna read or write in one of the registers with specific address pointer
				address 			: in  unsigned (7 downto 0);  --- address of the specific register in one of the slaves (address pointer).
				data_in  		: in  unsigned  (15 downto 0);
				data_in_length : in  STD_LOGIC; --- high = 16 bits , low = 8 bits 
				send  			: in  STD_LOGIC;
				
				busy  			: out  STD_LOGIC;
				data_out  		: out  unsigned  (15 downto 0);
				SCL 				: out  STD_LOGIC;
				data_out_valid : out  STD_LOGIC;
				SDA 				: inout  STD_LOGIC
				
				
			);
end I2C_controller;

architecture Behavioral of I2C_controller is

		--- registering inputs ----
	
	signal 	RW_int 					: std_logic := '0';
	signal 	data_in_length_int 	: std_logic := '0';
	signal 	send_int				 	: std_logic := '0';
	signal 	SDA_in_int			 	: std_logic := '0';
	signal 	data_in_int			 	: unsigned (15 downto 0):= (others => '0');
	signal 	address_int			 	: unsigned (7 downto 0):= (others => '0');
	
		--- registering outputs ---
	
	signal 	busy_int					: std_logic := '0';	
	signal 	SCL_int					: std_logic := '0';	
	signal 	data_out_valid_int	: std_logic := '0';	
	signal 	SDA_out_int				: std_logic := '0';	
	signal 	data_out_int			: unsigned (15 downto 0) := (others => '0');	
	
	
			---internal signals ---

	signal 		SDA_in							: std_logic := '0';
	signal 		SDA_out							: std_logic := '0';
	signal 		IObuff_RW_mode					: std_logic := '0'; 
	signal 		SCL_generate					: std_logic := '0';
	signal 		RW_buff							: std_logic := '0';
	signal 		send_int_pre					: std_logic := '0';
	signal 		RW_signal						: std_logic := '0';  --- write = '0' read = '1'
	signal 		data_in_length_buff			: std_logic := '0';  
	signal 		clock_counter					: unsigned(8 downto 0) := (others => '0');
	signal 		I2C_start_stop_counter		: unsigned(8 downto 0) := (others => '0');
	signal 		Address_buff					: unsigned(7 downto 0) := (others => '0');
	signal 		data_high_byte_buff			: unsigned(7 downto 0) := (others => '0');
	signal 		data_low_byte_buff			: unsigned(7 downto 0) := (others => '0');
	signal 		I2C_state_machine				: unsigned(3 downto 0) := (others => '0');
	signal 		serial_bit_counter			: unsigned(2 downto 0) := (others => '0');
	signal 		I2C_clock_counter				: unsigned(5 downto 0) := (others => '0');
 	constant 	slave_address 					: unsigned(7 downto 0) := "00110101"; 

begin

IOBUF_inst : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => SDA_in,     -- Buffer output
      IO => SDA,   -- Buffer inout port (connect directly to top-level port)
      I => SDA_out,     -- Buffer input
      T => IObuff_RW_mode      -- 3-state enable input, high=input, low=output 
   );
	
	
	SDA_out				<= SDA_out_int;
	busy					<= busy_int;
	SCL					<= SCL_int;
	data_out_valid		<= data_out_valid_int;
	data_out				<= data_out_int;
	
	process(clock)
	begin 
	
		if rising_edge (clock) then 
			
			RW_int							<= RW;
			IObuff_RW_mode					<= '0';
			address_int						<= address;
			data_in_length_int			<= data_in_length;
			send_int							<= send;
			send_int_pre					<= send_int;
			SDA_in_int						<= SDA_in;
			data_in_int						<= data_in;
			SCL_int							<= '1';
			clock_counter					<= clock_counter +1;
			I2C_start_stop_counter		<= I2C_start_stop_counter +1;
			SDA_out_int						<= '1';
			
			--- creating SCL --- 
			--- FPGA clock period 			= 8.33 ns 
			--- SCL period 					= 2.72 us => 327 clocks
			--- SCL low time 					= 1.5  us => 180 clocks
			--- SCL high time 				= 1.22 us => 147 clocks
			
			
			
									--- generating SCL---
			
			if (clock_counter < to_unsigned(89,9) or clock_counter > to_unsigned (235,9)) then 
			
				SCL_int 				<= not SCL_generate;
			
			end if;
			
			
			if (clock_counter = to_unsigned (326,9)) then 
			
				clock_counter 				<= (others => '0');
				I2C_clock_counter 		<= I2C_clock_counter +1;
				serial_bit_counter		<= serial_bit_counter -1;
			
			end if;
			
			
			
			--- I2C state machine starts!!!---
			
			case I2C_state_machine is 
			
				when "0000" => 
					
					--- do nothing! ---
			
				when "0001" =>
				
					---wait for 1.31 us required between start and stop condition---
					
					if (I2C_start_stop_counter = to_unsigned (155,9)) then --- 1.31 us 
					
						I2C_state_machine 		<= to_unsigned (2,4);
						I2C_start_stop_counter	<= (others => '0');
					
					end if;
					
				when "0010" =>
					-- Start condition by reseting SDA for 0.61 us. Then wait for another 0.75 us to reach the begining of data.
					SDA_out_int				<= '0';
					
					if (I2C_start_stop_counter > to_unsigned (72,9)) then 	--- 0.61 us 
					
						SCL_int				<= '0';
					
					end if;
					
					if (I2C_start_stop_counter = to_unsigned (162,9)) then --- 1.36 us
					
						I2C_state_machine 		<= to_unsigned (3,4);
						clock_counter 				<= (others =>'0');
						SCL_generate				<= '1';
						I2C_clock_counter 		<= (others => '0');
						serial_bit_counter		<= to_unsigned (6,3); --- 7 bits are dedicatde to slave address bit and it is MSB first!! 
						
					end if;
					
				when "0011" => 
					--sending slave address--
					SDA_out_int 					<= slave_address(to_integer (serial_bit_counter)); 
					if (I2C_clock_counter = to_unsigned (7,6)) then
						
						I2C_state_machine 			<= to_unsigned (4,4);
					
					end if;

				when "0100" => 
					--sending RW-- 
					SDA_out_int 					<= RW_signal;
					if (I2C_clock_counter = to_unsigned (8,6)) then 
						
						I2C_state_machine 			<= to_unsigned (5,4);
						if (RW_signal = '1') then 
							
							I2C_state_machine			<= to_unsigned (7,4);
							I2C_clock_counter 		<= to_unsigned (17,6);
							
						end if;
					
					end if;
					
				when "0101" => 
					--- recieving acknowledge---
					--- no need to read acknowledge cause we got only one slave hare---
					IObuff_RW_mode 					<= '1';
					if (I2C_clock_counter = to_unsigned (9,6)) then 
						
						I2C_state_machine 			<= to_unsigned (6,4);
						serial_bit_counter 			<= to_unsigned (7,3); ---8 bits are dedicatde to address pointer and it is MSB first!!
					
					end if;
					
				when "0110" => 
					--- sending address_pointer ---
					--- no need to assigne "IObuff_RW_mode" '0' cause its arleady put to '0' before ifs.
					SDA_out_int 			<= address_buff (to_integer (serial_bit_counter));
					
					if (I2C_clock_counter = to_unsigned (17,6)) then 
						
							I2C_state_machine 			<= to_unsigned (7,4);
					end if;
					
				when "0111" => 
					--- recieving acknowledge---
					--- no need to read acknowledge cause we got only one slave hare---

					IObuff_RW_mode 					<= '1';
					if (I2C_clock_counter = to_unsigned (18,6)) then 
						
							I2C_state_machine 			<= to_unsigned (9,4);
							serial_bit_counter 			<= to_unsigned (7,3);---8 bits are dedicatde to data and it is MSB first!!							
							if (Data_in_length_buff = '0') then  --- if input data is one byte 
							
								I2C_state_machine 			<= to_unsigned (11,4);
								I2C_clock_counter				<= to_unsigned (27,6);
							
							end if;
							
							if (RW_buff = '1' and RW_signal = '0') then 
								
								I2C_state_machine 			<= to_unsigned (8,4);
								
							end if; 

							
							
					end if;
					
					when "1000" => 
						-- When read mode is selected, go back to start condition.
						if (clock_counter = to_unsigned (162,9)) then --- 1.36 us is spent  
						
								I2C_state_machine 			<= to_unsigned (1,4);
								I2C_start_stop_counter 		<= (others => '0');
								RW_signal 						<= '1';
								SCL_generate					<= '0';
						end if;
							

					
				when "1001" => 
					--- sending/recieving high byte
					SDA_out_int 			<= data_high_byte_buff(to_integer (serial_bit_counter));
					IObuff_RW_mode			<= RW_buff; -- in read mode the above statement does nothing :)
					
					if (clock_counter = to_unsigned (162,9)) then  ---1.36 us which is exactly in half of the high time of the SCL period
					
						data_out_int (8 + to_integer (I2C_clock_counter))				<= SDA_in_int;
						
					end if;
					
					if (I2C_clock_counter = to_unsigned (26,6)) then 
					
							I2C_state_machine 			<= to_unsigned (10,4);
							
					end if;
					
					
				when "1010" => 
					---recieving acknowledge---
					IObuff_RW_mode										<=	not RW_Buff;
					SDA_out_int 										<= '0'; --- cause we need one more byte from slave 
					
					if (I2C_clock_counter = to_unsigned (27,6)) then 
					
						I2C_state_machine 			<= to_unsigned (11,4);
						serial_bit_counter			<= to_unsigned (7,3);

					end if;
					
					
				when "1011" => 
					--- sending/recieving low byte
					SDA_out_int 			<= data_low_byte_buff(to_integer (serial_bit_counter));
					IObuff_RW_mode			<= RW_buff; -- in read mode the above statement does nothing :)
					if (I2C_clock_counter = to_unsigned (35,6)) then 
					
						I2C_state_machine 			<= to_unsigned (12,4);

					end if;
					
					if (clock_counter = to_unsigned (162,9)) then  ---1.36 us which is exactly in half of the high time of the SCL period
					
						data_out_int (to_integer (I2C_clock_counter))				<= SDA_in_int;
						
					end if; 
					
				when "1100" => 
					---recieving acknowledge---
					IObuff_RW_mode										<=	not RW_Buff;
					
					if (I2C_clock_counter = to_unsigned (36,6)) then 
							
						I2C_state_machine 					<= to_unsigned (13,4);
						I2C_Start_Stop_Counter				<=	(others=>'0');
						Data_Out_Valid_Int					<=	RW_Buff;					
					
					end if; 
					
				when "1101" => 
					---stop condition 
					SDA_out_int 			<= '0';
					if (I2C_start_stop_counter = to_unsigned (162,9)) then --- 1.36 us 
							
						I2C_state_machine 					<= to_unsigned (14,4);
						SCL_generate							<= '0';
						RW_signal 								<= '0';
						busy_int 								<= '0';
						
					end if;
					
				when "1110" => 
					--- putting SDA to '1' and SDA_out_int is already put to '1' before ifs
				when others =>
				end case;						
			
			
			
			
			if (send_int = '1' and send_int_pre = '0' and busy_int = '0') then 
			
				busy_int 						<= '1';
				data_high_byte_buff			<= data_in_int(15 downto 8);
				data_low_byte_buff			<= data_in_int(7 downto 0);
				address_buff					<= address_int;
				RW_buff							<= RW_int;
				Data_in_length_buff			<= data_in_length_int;
				I2C_state_machine 			<= to_unsigned (1,4);
				I2C_start_stop_counter		<= (others => '0');
			
			end if;
			
		
		end if;
		
	end process;


end Behavioral;

