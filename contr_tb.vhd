LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY contr_tb IS
END contr_tb;
 
ARCHITECTURE behavior OF contr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controllore_sub
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         check_key_1 : IN  std_logic;
         check_key_2 : IN  std_logic;
         timer_end : IN  std_logic;
         timer_start : OUT  std_logic;
         safe_open : OUT  std_logic;
         timer_reset : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal check_key_1 : std_logic := '0';
   signal check_key_2 : std_logic := '0';
   signal timer_end : std_logic := '0';

 	--Outputs
   signal timer_start : std_logic;
   signal safe_open : std_logic;
   signal timer_reset : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controllore_sub PORT MAP (
          clock => clock,
          reset => reset,
          check_key_1 => check_key_1,
          check_key_2 => check_key_2,
          timer_end => timer_end,
          timer_start => timer_start,
          safe_open => safe_open,
          timer_reset => timer_reset
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
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;
		reset <= '0';
		
      wait for clock_period*3;
		
		timer_end <= '0';
		check_key_1 <= '1';
		check_key_2 <= '1';
		wait for clock_period*1;
--		check_key_2 <= '1';
--		wait for clock_period*5;

    	check_key_1 <= '0';
		wait for clock_period*2;
		check_key_1 <= '1';
      wait for clock_period*2;
		check_key_1 <= '0';
		wait for clock_period*2;
		check_key_2 <= '0';
		wait for clock_period*5;
		
		check_key_1 <= '1';
		wait for clock_period*2;
		check_key_2 <= '1';
		wait for clock_period*5;
		timer_end <= '1';
		wait for clock_period*2;
      wait;
   end process;

END;
