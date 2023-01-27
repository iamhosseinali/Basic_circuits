----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:115:21 10/11/2021 
-- Design Name: 
-- Module Name:    fft-with-butterfly - Behavioral 
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

entity fft_with_butterfly is
    
	 Port ( 
	 
							
							----FFT input ports---
				clock 		: 	in  std_logic;
				x0_input_r 	:	in  signed (15 downto 0);
				x0_input_i 	: 	in  signed (15 downto 0);
				x1_input_r 	: 	in  signed (15 downto 0);
				x1_input_i 	: 	in  signed (15 downto 0);
				x2_input_r 	: 	in  signed (15 downto 0);
				x2_input_i 	: 	in  signed (15 downto 0);
				x3_input_r 	: 	in  signed (15 downto 0);
				x3_input_i 	: 	in  signed (15 downto 0);
				
							----FFT output ports---

				x0_output_r : out  signed (16 downto 0);
				x0_output_i : out  signed (16 downto 0);
				x1_output_r : out  signed (16 downto 0);
				x1_output_i : out  signed (16 downto 0);
				x2_output_r : out  signed (16 downto 0);
				x2_output_i : out  signed (16 downto 0);
				x3_output_r : out  signed (16 downto 0);
				x3_output_i : out  signed (16 downto 0)
			  
			  );
end fft_with_butterfly;

architecture Behavioral of fft_with_butterfly is
	
	
								---input signals ----
	
	signal			x0_input_r_int		:  	signed (15 downto 0) := (others=>'0');
	signal			x0_input_i_int		: 	  	signed (15 downto 0)	:= (others=>'0');
	signal			x1_input_r_int 	: 	  	signed (15 downto 0)	:= (others=>'0');
	signal			x1_input_i_int 	: 	  	signed (15 downto 0)	:= (others=>'0');
	signal			x2_input_r_int 	: 	  	signed (15 downto 0)	:= (others=>'0');
	signal			x2_input_i_int 	: 	  	signed (15 downto 0)	:= (others=>'0');
	signal			x3_input_r_int 	: 	  	signed (15 downto 0)	:= (others=>'0');
	signal			x3_input_i_int		: 	  	signed (15 downto 0)	:= (others=>'0');
	
								
								---output signals-----
	
	
	signal			x0_output_r_int 	:   	signed (16 downto 0)	:= (others=>'0');
	signal			x0_output_i_int 	:   	signed (16 downto 0)	:= (others=>'0');
	signal			x1_output_r_int 	:   	signed (16 downto 0)	:= (others=>'0');
	signal			x1_output_i_int 	:   	signed (16 downto 0)	:= (others=>'0');
	signal			x2_output_r_int	:	  	signed (16 downto 0)	:= (others=>'0');
	signal			x2_output_i_int	:  	signed (16 downto 0)	:= (others=>'0');
	signal			x3_output_r_int 	:   	signed (16 downto 0)	:= (others=>'0');
	signal			x3_output_i_int 	:   	signed (16 downto 0)	:= (others=>'0'); 
	
							
							----internal signals-----
	
	signal			Ar						:		signed (16 downto 0)	:= (others=>'0');
	signal			Ai						:		signed (16 downto 0)	:= (others=>'0');
	signal			Br						:		signed (16 downto 0)	:= (others=>'0');
	signal			Bi						:		signed (16 downto 0)	:= (others=>'0');
	signal			Dr						:		signed (16 downto 0)	:= (others=>'0');
	signal			Di						:		signed (16 downto 0)	:= (others=>'0');
	signal			Cr						:		signed (16 downto 0)	:= (others=>'0');
	signal			Ci						:		signed (16 downto 0)	:= (others=>'0');
	
	
	
						---internal signals for buffering----
						
						
	signal			Ar_int						:		signed (15 downto 0)	:= (others=>'0');
	signal			Ai_int						:		signed (15 downto 0)	:= (others=>'0');
	signal			Br_int						:		signed (15 downto 0)	:= (others=>'0');
	signal			Bi_int						:		signed (15 downto 0)	:= (others=>'0');
	signal			Dr_int						:		signed (15 downto 0)	:= (others=>'0');
	signal			Di_int						:		signed (15 downto 0)	:= (others=>'0');
	signal			Cr_int						:		signed (15 downto 0)	:= (others=>'0');
	signal			Ci_int						:		signed (15 downto 0)	:= (others=>'0');



	
	
	COMPONENT butterfly
	PORT(
		
		
		clock : IN std_logic;
		x0_input_r : IN signed(15 downto 0);
		x0_input_i : IN signed(15 downto 0);
		x1_input_r : IN signed(15 downto 0);
		x1_input_i : IN signed(15 downto 0);          
		
		
		A_output_r : OUT signed(16 downto 0);
		A_output_i : OUT signed(16 downto 0);
		B_output_r : OUT signed(16 downto 0);
		B_output_i : OUT signed(16 downto 0)
		
		);
	END COMPONENT;

begin

first_butterfly: butterfly PORT MAP(

			--butterfly input signals-----
		
		clock 		=> clock,
		x0_input_r 	=> x0_input_r_int ,
		x0_input_i 	=> x0_input_i_int,
		x1_input_r 	=> x2_input_r_int,
		x1_input_i 	=> x2_input_i_int ,
		
			--butterfly output signals-----
 
		A_output_r 	=> Ar,
		A_output_i 	=> Ai,
		B_output_r 	=> Br,
		B_output_i 	=> Bi
	);
	
	
	second_butterfly: butterfly PORT MAP(
		
		
		--butterfly input signals-----

		
		clock => clock,
		x0_input_r => x1_input_r_int ,
		x0_input_i => x1_input_i_int,
		x1_input_r => x3_input_r_int,
		x1_input_i => x3_input_i_int ,
		
		--butterfly output signals-----

		
		A_output_r => Cr,
		A_output_i => Ci,
		B_output_r => Dr,
		B_output_i => Di
	);
	
	
	third_butterfly: butterfly PORT MAP(
		
		--butterfly input signals-----

		
		clock => clock,
		x0_input_r => Ar_int ,
		x0_input_i => Ai_int,
		x1_input_r => Cr_int,
		x1_input_i => Ci_int ,
		
		--butterfly output signals-----

		
		A_output_r => x0_output_r_int,
		A_output_i => x0_output_i_int,
		B_output_r => x2_output_r_int,
		B_output_i => x2_output_i_int
	);
	
	
	fourth_butterfly: butterfly PORT MAP(
		
		--butterfly input signals-----

		
		clock => clock,
		x0_input_r => Br_int,
		x0_input_i => Bi_int,
		x1_input_r => Dr_int,
		x1_input_i => Di_int ,
		
		--butterfly output signals-----

		
		A_output_r => x1_output_r_int,
		A_output_i => x1_output_i_int,
		B_output_r => x3_output_r_int,
		B_output_i => x3_output_i_int
	);



		

	


	process(clock)
	begin 
	
		if rising_edge(clock) then 
		
				------buffering input signals-----
				
				x0_input_r_int	<=	x0_input_r;
				x0_input_i_int	<=	x0_input_i;
				x1_input_r_int <=	x1_input_r;
				x1_input_i_int <=	x1_input_i;
				x2_input_r_int <=	x2_input_r;
				x2_input_i_int <=	x2_input_i;
				x3_input_r_int <=	x3_input_r;
				x3_input_i_int	<=	x3_input_i;
				
				
				------buffering intenal signals-----
				
				
				Ar_int 	<= resize(Ar,16);
				Ai_int 	<= resize(Ai,16);
				Br_int	<= resize(Br,16);
				Bi_int	<= resize(Bi,16);
				Cr_int	<= resize(Cr,16);
				Ci_int	<= resize(Ci,16);
				Dr_int	<= resize(Dr,16);
				Di_int	<= resize(Di,16);
				
				
				----buffering output signals-----

				x0_output_r	<=	x0_output_r_int;
				x0_output_i <=	x0_output_i_int;
				x1_output_r	<= x1_output_r_int;
				x1_output_i	<=	x1_output_i_int;
				x2_output_r	<=	x2_output_r_int;
				x2_output_i	<=	x2_output_i_int;
				x3_output_r	<=	x3_output_r_int;	
				x3_output_i	<=	x3_output_i_int;
				
				
				
		end if;
		
		
		end process;
end Behavioral;

