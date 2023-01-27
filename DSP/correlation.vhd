----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:00:41 12/28/2021 
-- Design Name: 
-- Module Name:    correlation - Behavioral 
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

entity correlation is
    Port ( 
	 
				Input_data1 			: in  signed (7 downto 0);
				Input_data2 			: in  signed (7 downto 0);
				clock 					: in  STD_LOGIC;
				start_correlation 	: in  STD_LOGIC;
				output_correlation 	: out  signed (32 downto 0);
				output_valid 			: out  STD_LOGIC
				
				
			);
end correlation;

architecture Behavioral of correlation is

					--- registering inputs--- 
		signal Input_data1_int 				: signed (7 downto 0) := (others=>'0');
		signal Input_data2_int 				: signed (7 downto 0) := (others=>'0');
		signal start_correlation_int		: STD_LOGIC := '0';
			
					---- registering outputs --- 
		signal output_correlation_int 	: std_logic_vector (32 downto 0) := (others =>'0');
		signal output_valid_int				: STD_LOGIC := '0';
		
		
					--- internal signals --- 
		signal ff0_out_mult_in_r			: std_logic_vector (15 downto 0) := (others => '0');
		signal ff0_out_mult_in_i			: std_logic_vector (15 downto 0) := (others => '0');
		
		signal ff1_out_mult_in_r			: std_logic_vector (15 downto 0):= (others => '0');
		signal ff1_out_mult_in_i			: std_logic_vector (15 downto 0):= (others => '0');
		signal Input_data1_pre 				: signed (7 downto 0) := (others=>'0');
		signal Input_data2_pre 				: signed (7 downto 0) := (others=>'0');
		signal mul_out_ifft_in_r 			: signed (24 downto 0) := (others=>'0');
		signal mul_out_ifft_in_i 			: signed (24 downto 0) := (others=>'0');
		signal start_fft0						: STD_LOGIC := '0';
		signal start_fft1						: STD_LOGIC := '0';
		signal start_correlation_pre		: STD_LOGIC := '0';
		signal ffts_done_indicator			: STD_LOGIC := '0';
		signal ffts_done_indicator_pre	: STD_LOGIC := '0';
		signal ffts_done_indicator_int	: STD_LOGIC := '0';
		signal fwd_inv_we						: STD_LOGIC := '0';


COMPONENT fft
  PORT (
    clk : IN STD_LOGIC;
    start : IN STD_LOGIC;
    xn_re : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    xn_im : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    fwd_inv : IN STD_LOGIC;
    fwd_inv_we : IN STD_LOGIC;
    rfd : OUT STD_LOGIC;
    xn_index : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
    dv : OUT STD_LOGIC;
    xk_index : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    xk_re : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    xk_im : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT ifft
  PORT (
    clk : IN STD_LOGIC;
    start : IN STD_LOGIC;
    xn_re : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
    xn_im : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
    fwd_inv : IN STD_LOGIC;
    fwd_inv_we : IN STD_LOGIC;
    rfd : OUT STD_LOGIC;
    xn_index : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
    dv : OUT STD_LOGIC;
    xk_index : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    xk_re : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
    xk_im : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
  );
END COMPONENT;

begin


fft0 : fft
  PORT MAP (
    clk 				=> clock,
    start			=> start_fft0,
    xn_re 			=> std_logic_vector (Input_data1_pre) ,
    xn_im 			=> (others =>'0'),
    fwd_inv 		=> '1',
    fwd_inv_we		=> '0',
    rfd 				=> open,
    xn_index 		=> open,
    busy 			=> open,
    edone 			=> open,
    done 			=> ffts_done_indicator,
    dv 				=> open,
    xk_index 		=> open,
    xk_re 			=> ff0_out_mult_in_r,
    xk_im 			=> ff0_out_mult_in_i
  );
  
  
fft1 : fft
  PORT MAP (
    clk 				=> clock,
    start			=> start_fft1,
    xn_re 			=> std_logic_vector(Input_data2_pre),
    xn_im 			=> (others => '0'),
    fwd_inv 		=> '1',
    fwd_inv_we		=> '0',
    rfd 				=> open,
    xn_index 		=> open,
    busy 			=> open,
    edone 			=> open,
    done 			=> open,
    dv 				=> open,
    xk_index 		=> open,
    xk_re 			=> ff1_out_mult_in_r,
    xk_im 			=> ff1_out_mult_in_i
  );
  
  ifft0 : ifft
  PORT MAP (
    clk 				=> clock,
    start 			=> ffts_done_indicator_pre,
    xn_re 			=> std_logic_vector (mul_out_ifft_in_r),
    xn_im 			=> std_logic_vector (mul_out_ifft_in_i),
    fwd_inv 		=> '0',
    fwd_inv_we		=> fwd_inv_we,
    rfd				=> open,
    xn_index 		=> open,
    busy 			=> open,
    edone 			=> open,
    done 			=> open,
    dv 				=> output_valid_int,
    xk_index 		=> open,
    xk_re 			=> output_correlation_int,
    xk_im 			=> open
  );

  
--  multiplier_conjugator0: entity work.multiplier_conjugator PORT MAP
--  (
--		real_input 	=> signed (ff0_out_mult_in_r),
--		imag_input 	=> signed (ff0_out_mult_in_i),
--		real_input1 => signed (ff1_out_mult_in_r),
--		imag_input1 =>	signed (ff1_out_mult_in_i),
--		real_output => mul_out_ifft_in_r,
--		imag_output => mul_out_ifft_in_i,
--		clock 		=> clock
--	);

	Inst_Multiply_Conjugate: entity work.Multiply_Conjugate PORT MAP(
		Clock => clock,
		X_Real => signed (ff0_out_mult_in_r),
		X_Imag => signed (ff0_out_mult_in_i),
		Y_Real => signed (ff1_out_mult_in_r),
		Y_Imag => signed (ff1_out_mult_in_i),
		F_Real => mul_out_ifft_in_r,
		F_Imag => mul_out_ifft_in_i
	);
	
output_correlation   <= signed (output_correlation_int);	
output_valid	   	<= output_valid_int;			
	
	process (clock) 
	begin 
	
		if rising_edge (clock) then 
		
			Input_data1_int 	    	<= Input_data1;			
			Input_data2_int			<= Input_data2;				
			Input_data1_pre			<= Input_data1_int;				
			Input_data2_pre			<= Input_data2_int;				
			start_correlation_int   <= start_correlation;
			start_correlation_pre   <= start_correlation_int;
			ffts_done_indicator_int <= ffts_done_indicator;
			ffts_done_indicator_pre <= ffts_done_indicator_int;
			start_fft0					<= '0';
			start_fft1					<= '0';
			fwd_inv_we					<= '0';
			
			if (start_correlation_int = '1' and start_correlation_pre = '0') then 
				
				start_fft0				<= '1';
				start_fft1				<= '1';
				fwd_inv_we				<= '1';
			
			end if;
 
		end if;
		
	end process;

end Behavioral;

