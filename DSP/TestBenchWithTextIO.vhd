--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:05:32 12/30/2021
-- Design Name:   
-- Module Name:   F:/Edu/FPGA/Projects/ISE Projects/DSP/FFT/Correlation/correlation/tb.vhd
-- Project Name:  correlation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: correlation
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- signed for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

use ieee.std_logic_textio.all;
use std.textio.all;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT correlation
    PORT(
         Input_data1 : IN  signed(7 downto 0);
         Input_data2 : IN  signed(7 downto 0);
         clock : IN  std_logic;
         start_correlation : IN  std_logic;
         output_correlation : OUT  signed(32 downto 0);
         output_valid : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Input_data1 : signed(7 downto 0) := (others => '0');
   signal Input_data2 : signed(7 downto 0) := (others => '0');
   signal clock : std_logic := '0';
   signal start_correlation : std_logic := '0';
	signal Start_Correlation_temp : std_logic := '0';
	signal Input_Vector_Counter : unsigned (9 downto 0) := (others=>'1');

 	--Outputs
   signal output_correlation : signed(32 downto 0);
   signal output_valid : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: correlation PORT MAP (
          Input_data1 => Input_data1,
          Input_data2 => Input_data2,
          clock => clock,
          start_correlation => start_correlation,
          output_correlation => output_correlation,
          output_valid => output_valid
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   Read_Input_Vector: process(Clock)
	
		file		input_text_a: text open read_mode is "F:\Edu\FPGA\DSP models\Correlation\Input_Vec_a.txt";
		file		input_text_b: text open read_mode is "F:\Edu\FPGA\DSP models\Correlation\Input_Vec_b.txt";
		variable LI1			: line;
		variable LI1_var		: integer;
		
	begin
	
		if rising_edge(Clock) then

			Start_Correlation				<=	'0';
		
			if (Start_Correlation_temp = '0') then
				Start_Correlation			<=	'1';
				Start_Correlation_temp	<=	'1';
				Input_Vector_Counter		<=	(others=>'0');
			end if;
			
			input_data1					<=	(others=>'0');
			input_data2					<=	(others=>'0');
			
			if (Input_Vector_Counter < to_unsigned(128,10)) then

				Input_Vector_Counter		<=	Input_Vector_Counter + 1;
				
				readline(input_text_a,LI1);
				read(LI1,LI1_var);
				input_data1				<= to_signed(LI1_var,8);

				readline(input_text_b,LI1);
				read(LI1,LI1_var);
				input_data2				<= to_signed(LI1_var,8);
				
			end if;
			
			
		end if;	
	end process;



	write_Output_Vector: process(Clock)
	
		file 		output_text	: text open write_mode is "F:\Edu\FPGA\DSP models\Correlation\Output_Vec_HDL.txt";
		variable LO1			: line;
		
	begin
	
		if rising_edge(Clock) then
		
			if (Output_Valid = '1') then
			
				write(LO1, to_integer(Output_Correlation));
				writeline(output_text , LO1);
			
			end if;
			
		end if;
	end process;

END;
