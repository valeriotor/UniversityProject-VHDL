LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY contr_tb IS
END contr_tb;
 
ARCHITECTURE behavior OF contr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlloreMaster
    PORT(
              -- ingressi per ControlloreSequenze1
              Bitkey1: in STD_LOGIC;
              code1: in STD_LOGIC_VECTOR (3 downto 0);
              Enablekey1: in STD_LOGIC;
              EnterCode1: in STD_LOGIC;
              
              -- ingressi per ControlloreSequenze2
              Bitkey2: in STD_LOGIC;
              code2: in STD_LOGIC_VECTOR (3 downto 0) ;
              Enablekey2: in STD_LOGIC;
              EnterCode2: in STD_LOGIC;
              
              -- ingressi della macchina
              clock : in  STD_LOGIC;
              reset : in  STD_LOGIC;
              --uscisees
              safe_open : out  STD_LOGIC;
              timer_reset : out STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    -- input of ControlloreSequenze1
    signal Bitkey1 : std_logic := '0';
    signal code1 : STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
    signal Enablekey1 : std_logic := '0';
    signal EnterCode1 : STD_LOGIC :='0';
    -- input of ControlloreSequenze2
    signal Bitkey2 : std_logic := '0';
    signal code2 : STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
    signal Enablekey2 : std_logic := '0';
    signal EnterCode2 : STD_LOGIC :='0';

    --Outputs
   signal safe_open : std_logic;
   signal timer_reset : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: ControlloreMaster PORT MAP (
          clock => clock,
          reset => reset,
          -- input of ControlloreSequenze1
          Bitkey1 => Bitkey1,
          code1 => code1,
          Enablekey1 => Enablekey1,
          EnterCode1 => EnterCode1,
          --input of ControlloreSequenze2
          Bitkey2 => Bitkey2,
          code2 => code2,
          Enablekey2 => Enablekey2,
          EnterCode2 => EnterCode2,
          --outputs
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
        
        
        -- voglio il check_key_1 <= '1';
        Enablekey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period*2;
        code1 <= "0110";
        wait for clock_period;
        entercode1 <= '1';
        wait for clock_period*3;
        -- voglio check_key_2 <= '1';
        Enablekey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period*2;
        code2 <= "0110";
        wait for clock_period;
        entercode2 <= '1';
        wait for clock_period*3;
        
        --^^^controllo se avendo i 2 controllori a 1 la cassaforte si apre


        -- voglio il check_key_1 <= '0';
        Enablekey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period*2;
        code1 <= "1111";
        wait for clock_period;
        entercode1 <= '1';
        wait for clock_period*3;
        -- voglio check_key_2 <= '1';
        Enablekey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period*2;
        code2 <= "0110";
        wait for clock_period;
        entercode2 <= '1';
        wait for clock_period*3;
        
        --^^^controllo se avendo 1 controllore a 0 e l'altro a 1 la cassaforte resti chiusa
        
        
        -- voglio il check_key_1 <= '1';
        Enablekey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period*2;
        code1 <= "1010";
        wait for clock_period;
        entercode1 <= '1';
        wait for clock_period*3;
        -- voglio check_key_2 <= '0';
        Enablekey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period*2;
        code2 <= "1111";
        wait for clock_period;
        entercode2 <= '1';
        wait for clock_period*3;
        
        --^^^controllo se avendo i 2 controllori a 0 la cassaforte resti chiusa
        
        -- voglio il check_key_1 <= '0';
        Enablekey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period*2;
        code1 <= "1111";
        wait for clock_period;
        entercode1 <= '1';
        wait for clock_period*3;
        -- voglio check_key_2 <= '0';
        Enablekey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '1';
        wait for clock_period;
        Bitkey2 <= '0';
        wait for clock_period*2;
        code2 <= "1111";
        wait for clock_period;
        entercode2 <= '1';
        wait for clock_period*3;
        
        --^^^controllo se avendo 1 controllore a 1 e l'altro a 0 la cassaforte resti chiusa
      
      
      wait;
   end process;
	
END;
