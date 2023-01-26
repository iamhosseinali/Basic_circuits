----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:04:19 12/07/2021 
-- Design Name: 
-- Module Name:    FSM - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mealy_FSM is
    Port (

			  clock 		: in  STD_LOGIC;
           x 			: in  STD_LOGIC;
           reset 		: in  STD_LOGIC;
           parity 	: out  STD_LOGIC);
end mealy_FSM;

architecture Behavioral of mealy_FSM is

	type state_type is (S0,S1);
	signal state,next_state : state_type;

begin

	SYNC_PROC : process(clock)
	begin 
		
		if rising_edge (clock) then
			
			State 	<= next_state;
			
			if (reset = '1') then 
				
				State	<= S0;
			
			end if;
		
		end if;
	
	end process;
	
	NEXT_STATE_DECODE : process(state,x)
	begin 
		parity 	<= '0';
		
		case state is 
			when S0 => 
				if (x = '1') then 
					parity <= '1'; 
					next_state <= S1; 
				else 
					next_state <= S0; 
				end if;
			when S1 => 
				if (x = '1') then 
					next_state <= S0; 
				else 
					parity <= '1'; 
					next_state <= S1; 
				end if; 
			when others => 
				next_state <= S0; 
		end case; 
	end process;
		
 
end Behavioral;

