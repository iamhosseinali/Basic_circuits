--- this module works with 100 MHz clk and its SCK is 33.33 MHz 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HS_SPI_Controller is
    Port ( 
				Clock 							: in 	STD_LOGIC;
				Data_In 							: in 	unsigned (31 downto 0);
				Send 								: in 	STD_LOGIC;
				Command_Type 					: in 	unsigned (1 downto 0);
				Force_CS 						: in 	STD_LOGIC;
				Change_endian 						: in 	STD_LOGIC;
				Data_Out 						: out	unsigned (7 downto 0);
				Data_Out_Valid 				: out STD_LOGIC;
				Busy 								: out STD_LOGIC;
				MOSI 								: out	STD_LOGIC;
				MISO 								: in	STD_LOGIC;
				SCK 								: out	STD_LOGIC;
				CS 								: out	STD_LOGIC
           );
end HS_SPI_Controller;

architecture Behavioral of HS_SPI_Controller is

	signal	Data_In_Int						:	unsigned	(31 downto 0)			:=	(others=>'0');
	signal	index						:	integer := 24;
	signal	Data_In_Buff					:	unsigned	(31 downto 0)			:=	(others=>'0');
	signal	Send_Int							:	std_logic							:=	'0';
	signal	Change_endian_int					:	std_logic							:=	'0';
	signal	Send_Prev						:	std_logic							:=	'0';
	signal	Command_Type_Int				:	unsigned	(1 downto 0)			:=	(others=>'0');
	signal	Force_CS_Int					:	std_logic							:=	'0';
	signal	Force_CS_Buff					:	std_logic							:=	'0';
	signal	Data_Out_Int					:	unsigned	(7 downto 0)			:=	(others=>'0');
	signal	Data_Out_Valid_Int			:	std_logic							:=	'0';
	signal	Busy_Int							:	std_logic							:=	'0';
	signal	Busy_Int_1						:	std_logic							:=	'0';
	signal	Busy_Int_2						:	std_logic							:=	'0';
	signal	MOSI_Int							:	std_logic							:=	'0';
	signal	MISO_Int							:	std_logic							:=	'0';
	signal	SCK_Int							:	std_logic							:=	'0';
	signal	CS_Int							:	std_logic							:=	'0';
	
	
	
	type		SPI_Data_Bit_Width_Array is array (0 to 3) of unsigned(4 downto 0); 
	signal	SPI_Data_Bit_Width			:	SPI_Data_Bit_Width_Array		:=	
				(	to_unsigned(7,5),
					to_unsigned(15,5),
					to_unsigned(23,5),
					to_unsigned(31,5)
				);
				
	signal	SPI_Data_Bit_Width_Buff		:	unsigned	(4 downto 0)			:=	(others=>'0');	
	signal	SCK_Clock_Divider				:	unsigned	(3 downto 0)			:=	(others=>'0');	
	signal	SPI_Write_State				:	std_logic							:=	'0';
	signal	SCK_Disable						:	std_logic							:=	'0';
	signal	SPI_Transmission_End			:	std_logic							:=	'0';
	signal	Set_SCK_Disable				:	std_logic							:=	'0';
	signal	CS_Disable_Counter			:	unsigned	(2 downto 0)			:=	(others=>'1');

	signal	SPI_Data_Out_Bit_Width		:	unsigned	(2 downto 0)			:=	(others=>'0');	
			
						
begin

	 
	Data_Out							<=	Data_Out_Int;
	Busy								<=	Busy_Int or Busy_Int_1 or Busy_Int_2;
	MOSI								<=	MOSI_Int;
	SCK								<=	SCK_Int and SCK_Disable;
	CS									<=	CS_Int and Force_CS_Buff;	
		
	process(Clock)
	begin
	
		if rising_edge(Clock) then
		
			Data_In_Int							<=	Data_In;
			Send_Int								<=	Send;
			Send_Prev							<=	Send_Int;
			Command_Type_Int					<=	Command_Type;
			Force_CS_Int						<=	Force_CS;
			MISO_Int								<=	MISO; 
			CS_Int								<=	'0';
			SCK_Int								<=	'1';			
			SCK_Clock_Divider					<=	SCK_Clock_Divider + 1;
			Data_Out_Valid_Int				<=	'0';
			Busy_Int_1							<=	Busy_Int;
			Busy_Int_2							<=	Busy_Int_1;
			Data_Out_Valid						<=	Data_Out_Valid_Int;
			Change_endian_int					<= Change_endian;
				
			if (CS_Disable_Counter < to_unsigned(3,3)) then  --- SCSn High time (Tcs), the min is 30 ns  

				CS_Disable_Counter			<=	CS_Disable_Counter + 1;
				CS_Int							<=	'1';
				
			end if;
							
			if (SCK_Clock_Divider = to_unsigned(0,4) and SPI_Write_State = '1') then --- this is the write state
				
				MOSI_Int							<= Data_In_Buff(to_integer(SPI_Data_Bit_Width_Buff));
--				if (Change_endian_int	= '1') then 
--					MOSI_Int							<= Data_In_Buff(to_integer(SPI_Data_Bit_Width_Buff) - index );
--					if (SPI_Data_Bit_Width_Buff = to_unsigned(index + 1,5) ) then
--						index						<= index -16 ;
--					end if;
--				end if;
				SPI_Data_Bit_Width_Buff		<=	SPI_Data_Bit_Width_Buff - 1;
				SCK_Disable						<=	Set_SCK_Disable;
				if (SPI_Data_Bit_Width_Buff = to_unsigned(0,5)) then
					SPI_Transmission_End		<=	'1';
				end if;
				if (SPI_Transmission_End = '1') then
					
					SPI_Transmission_End		<=	'0';
					SCK_Disable					<=	'0';
					Busy_Int						<=	'0';
					Set_SCK_Disable			<=	'0';
					SPI_Write_State			<=	'0';
									
				end if;
				
			end if;		

			if (SCK_Clock_Divider = to_unsigned(0,4) and SCK_Disable = '1') then --- this is the SPI READ state, the max time between the falling edge of SCK and the data getting ready
			--- on "MISO" is called "Output Valid Time (Tov)" is 5 ns it means in the worst case it takes 5 ns for the module 
			---- to generate data after receving the falling edge of SCK.
				
				Data_Out_Int(to_integer(SPI_Data_Out_Bit_Width))	<=	MISO_Int;
				SPI_Data_Out_Bit_Width		<=	SPI_Data_Out_Bit_Width - 1;

				
				if (SPI_Data_Out_Bit_Width = to_unsigned(0,3)) then

					Data_Out_Valid_Int			<= '1';
								
				end if;
				
			end if;		
						
			if (SCK_Clock_Divider < to_unsigned(2,4)) then  ---- SCK Low time (Twl)
				SCK_Int							<=	'0';
			end if;

			if (SCK_Clock_Divider = to_unsigned(2,4)) then  --- SCK period
				SCK_Clock_Divider				<=	(others=>'0');

			end if;

			if (Send_Int = '1' and Send_Prev = '0' and Busy_Int = '0') then
			
				Data_In_Buff					<=	Data_In_Int;
				Force_CS_Buff					<=	Force_CS_Int;
				SPI_Data_Bit_Width_Buff		<=	SPI_Data_Bit_Width(to_integer(Command_Type_Int));
				SPI_Data_Out_Bit_Width		<=	to_unsigned(7,3);
				CS_Disable_Counter  			<=	(others=>'0');
				SCK_Clock_Divider				<=	to_unsigned(1,4); --6
				SPI_Write_State				<=	'1';
				Busy_Int							<=	'1';
				Set_SCK_Disable				<=	'1';
				SPI_Transmission_End			<=	'0';
				SCK_Disable						<=	'0';
										
			end if;	

		
		end if;
	end process;
	
end Behavioral;