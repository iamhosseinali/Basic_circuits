----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:03 12/07/2021 
-- Design Name: 
-- Module Name:    I2C_FSM - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity I2C_FSM is
    Port ( 
	 
				clock  				: in  STD_LOGIC;
				send 					: in  STD_LOGIC;
				data_type  			: in  STD_LOGIC;
				RW 					: in  STD_LOGIC;
				data_in  			: in  unsigned  (15 downto 0);
				address_pointer 	: in  unsigned  (7 downto 0);
				
				SCL 					: out  STD_LOGIC;
				valid 				: out  STD_LOGIC;
				busy 					: out  STD_LOGIC;
				data_out  			: out  unsigned  (15 downto 0);
				SDA 					: inout  STD_LOGIC
				
			);
end I2C_FSM;

architecture Behavioral of I2C_FSM is

--- registering inputs ----
	
	signal 	RW_int 					: std_logic := '0';
	signal 	Data_type_int   		: std_logic := '0';
	signal 	send_int				 	: std_logic := '0';
	signal 	SDA_in_int			 	: std_logic := '0';
	signal 	data_in_int			 	: unsigned (15 downto 0):= (others => '0');
	signal 	address_pointer_int	: unsigned (7 downto 0):= (others => '0');
	
		--- registering outputs ---
	
	signal 	busy_int					: std_logic := '0';	
	signal 	SCL_int					: std_logic := '0';	
	signal 	valid_int				: std_logic := '0';	
	signal 	SDA_out_int				: std_logic := '0';	
	signal 	data_out_int			: unsigned (15 downto 0) := (others => '0');	
	
	
			---internal signals ---

	signal 		SDA_in							: std_logic := '0';
	signal 		SDA_out							: std_logic := '0';
	signal 		IObuff_RW_mode					: std_logic := '0'; 
	signal 		SCL_generate					: std_logic := '0';
	signal 		RW_buff							: std_logic := '0';
	signal 		send_pre					: std_logic := '0';
	signal 		RW_signal						: std_logic := '0';  --- write = '0' read = '1'
	signal 		data_type_buff					: std_logic := '0';  
	signal 		clock_counter					: unsigned(8 downto 0) := (others => '0');
	signal 		I2C_start_stop_counter		: unsigned(8 downto 0) := (others => '0');
	signal 		Address_pointer_buff			: unsigned(7 downto 0) := (others => '0');
	signal 		data_high_byte_buff			: unsigned(7 downto 0) := (others => '0');
	signal 		data_low_byte_buff			: unsigned(7 downto 0) := (others => '0');
	--signal 		I2C_state_machine				: unsigned(3 downto 0) := (others => '0');
	signal 		serial_bit_counter			: unsigned(2 downto 0) := (others => '0');
	signal 		I2C_clock_counter				: unsigned(5 downto 0) := (others => '0');
 	constant 	bus_address 					: unsigned(7 downto 0) := "00110101"; 

	type state_type is (start_gap_state,start_stop_gap_state,start_state,address_bus_state,RW_state,ACK_state_address_pointer_state,stop_state);
	signal I2C_state_machine : state_type ;
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
      T => IObuff_RW_mode            -- 3-state enable input, high=input, low=output 
   );
	
	
	SDA_out				<= SDA_out_int;
	busy					<= busy_int;
	SCL					<= SCL_int;
	valid					<= valid_int;
	data_out				<= data_out_int;
	
	
	process (clock)
	begin 
		
		if rising_edge (clock) then 
			RW_int							<= RW;
			IObuff_RW_mode					<= '0';
			address_pointer_int			<= address_pointer;
			data_type_int					<= data_type;
			send_int							<= send;
			send_pre							<= send_int;
			SDA_in_int						<= SDA_in;
			data_in_int						<= data_in;
			SCL_int							<= '1';
			clock_counter					<= clock_counter +1;
			I2C_start_stop_counter		<= I2C_start_stop_counter +1;
			SDA_out_int						<= '1';
			--- creating SCL --- 
			--- FPGA clock period 			= 10 ns 
			--- SCL period 					= 2.72 us => 272 clocks
			--- SCL low time 					= 1.5  us => 150 clocks
			--- SCL high time 				= 1.22 us => 122 clocks
			if (clock_counter < to_unsigned (150,9)) then 
				SCL_int			<= not SCL_generate;
			end if;
			
			if (clock_counter = to_unsigned (271,9)) then 
				clock_counter 				<= (others => '0');
				I2C_clock_counter 		<= I2C_clock_counter +1;
				serial_bit_counter		<= serial_bit_counter -1;
			end if;
			
			if (send_int = '1' and send_pre = '0' and busy_int = '0') then 
					
					busy_int					<= '1';
					data_type_buff			<= data_type_int; 			
					RW_buff					<= RW_int; 					
					data_low_byte_buff	<= data_in_int(7 downto 0); 
					data_high_byte_buff	<= data_in_int(15 downto 8); 
					address_pointer_buff	<= address_pointer_int;
					I2C_state_machine 	<= start_stop_gap_state;
					clock_counter 			<= (others => '0');
					
			end if;
		
		----FSM starts!!--
			case I2C_state_machine is 
				when start_stop_gap_state => 
					---wait for 1.31 us required between start and stop condition---
					if (clock_counter = to_unsigned (130,9)) then 
						
						I2C_state_machine		<= start_gap_state;
						SDA_out_int				<= '0';
					
					end if;
				when start_gap_state	=> 
					
					SDA_out_int				<= '0';
					
					if (clock_counter = to_unsigned (190,9)) then 
						SCL_generate			<= '1';
						clock_counter 			<= (others =>'0');
						I2C_state_machine		<= start_state;

					end if;

				when start_state =>
					SDA_out_int				<= '0';

					
					
				when address_bus_state => 
				when others => 
			
			end case;
			
			
			
		end if;
	
	end process;


end Behavioral;

