----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:28 12/23/2021 
-- Design Name: 
-- Module Name:    ChipScope - Behavioral 
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

entity ChipScope is
    Port ( 
	 
			clock 		: in  STD_LOGIC;
			UpDown	 	: in std_logic;
			counterdata	: out unsigned(3 downto 0)
	 
	 );
end ChipScope;

architecture Behavioral of ChipScope is

component ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    DATA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));

end component;


component icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));

end component;


component VIO
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    SYNC_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    SYNC_OUT : OUT STD_LOGIC_VECTOR(10 DOWNTO 0));
	end component;

	 
	 
COMPONENT free_running_counter
	PORT(
		reset : IN std_logic;
		clock : IN std_logic;
		up_down : IN std_logic;          
		output : OUT unsigned(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ALU_seq
	PORT(
		A : IN signed(3 downto 0);
		B : IN signed(3 downto 0);
		S : IN unsigned(2 downto 0);          
		F : OUT signed(3 downto 0)
		);
	END COMPONENT;

	
	
	
	signal 		CONTROL0 		: std_logic_vector(35 downto 0)		:= (others => '0');
	signal 		CONTROL1 		: std_logic_vector(35 downto 0)		:= (others => '0');
	signal 		SYNC_OUT 		: std_logic_vector(10 downto 0)		:= (others => '0');
	signal 		counter		 	: unsigned(3 downto 0)					:= (others => '1');
	signal 		F		 			: signed(3 downto 0)						:= (others => '0');

begin

	icon0 : icon
  port map (
    CONTROL0 => CONTROL0,
    CONTROL1 => CONTROL1);
	 
	 ila0 : ila
  port map (
    CONTROL => CONTROL0,
    CLK => clock,
    DATA => std_logic_vector(resize(counter,8)),
    TRIG0 => std_logic_vector(resize(counter,8)));
	 
	 vio0 : VIO
  port map (
    CONTROL => CONTROL1,
    CLK => clock,
    SYNC_IN => std_logic_vector(F),
    SYNC_OUT => SYNC_OUT);
	 
	 free_running_counter0: free_running_counter PORT MAP(
		reset => '0',
		clock => clock,
		up_down => UpDown,
		output => counter
	);
	
	ALU0: ALU_seq PORT MAP(
		A => signed(SYNC_OUT(10 downto 7)),
		B => signed(SYNC_OUT(6 downto 3)),
		S => unsigned(SYNC_OUT(2 downto 0)),
		F => F
	);
	
	counterdata		<= counter;
	
	

end Behavioral;

