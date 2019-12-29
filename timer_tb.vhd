LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY timer_tb IS
END timer_tb;
 
ARCHITECTURE behavior OF timer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Timer
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         Start : IN  std_logic;
         Finished : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Start : std_logic := '0';

 	--Outputs
   signal Finished : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Timer PORT MAP (
          Clock => Clock,
          Reset => Reset,
          Start => Start,
          Finished => Finished
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';
		
		start <= '1';
		wait for clock_period * 1;
		start <= '0';
		wait for clock_period * 1;
		
		wait for clock_period * 10;
		
		reset <= '1';
		wait for clock_period * 3;
		reset <= '0';
		wait for clock_period * 1;
		start <= '1';
		wait for clock_period * 5;
		start <= '0';
		
		reset <= '1';
		wait for clock_period * 5;
		reset <= '0';
		wait for clock_period * 1;
		
		start <= '1';
		wait for clock_period * 10;
		start <= '0';
		
		
		
		

      -- insert stimulus here 

      wait;
   end process;

END;
