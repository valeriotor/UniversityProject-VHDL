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
		wait for clock_period * 10;
		assert (Finished = '1') report "Incorrect output #1: expected 1, received " & std_logic'image(Finished) severity error;
		wait for clock_period * 1;
		assert (Finished = '0') report "Incorrect output #2: expected 0, received " & std_logic'image(Finished) severity error;
		-- ^^ Verifico correttezza dell'impulso di uscita (sia l'istante d'uscita (#1) sia il suo essere impulsivo (#2))
		
		
		wait for 20 ns;
		reset <= '1';
		wait for clock_period * 3;
		reset <= '0';
		wait for clock_period * 1;
		
		start <= '1';
		wait for clock_period * 1;
		start <= '0';
		for i in 0 to 9 loop
			assert (Finished = '0') report "Incorrect output #3: expected 0, received " & std_logic'image(Finished) severity error;
			wait for clock_period;
		end loop;	
		-- ^^ Verifico che il segnale d'uscita non sia generato prima del dovuto
		
		
		wait for 20 ns;
		reset <= '1';
		wait for clock_period * 5;
		reset <= '0';
		wait for clock_period * 1;
		
		start <= '1';
		wait for clock_period * 5;
		start <= '0';
		wait for clock_period * 5;
		assert (Finished = '0') report "Incorrect output #4: expected 0, received " & std_logic'image(Finished) severity error;
		-- ^^ Verifico che il mantenimento del segnale di start non causi problemi
		
		
		wait for 20 ns;
		reset <= '1';
		wait for clock_period * 5;
		reset <= '0';
		wait for clock_period * 1;
		
		wait for clock_period / 2;
		start <= '1';
		wait for clock_period * 1;
		start <= '0';
		wait for clock_period * 9;
		wait for 1 ns;
		assert (Finished = '1') report "Incorrect output #5: expected 1, received " & std_logic'image(Finished) severity error;
		-- ^^ Verifico che segnali di start sfasati non diano problemi
		
		
		wait for 20 ns;
		reset <= '1';
		wait for clock_period * 5;
		reset <= '0';
		wait for clock_period * 1;
		
		start <= '1';
		wait for clock_period * 9 / 10;
		start <= '0';
		wait for clock_period / 10;
		wait for clock_period * 10; -- 10 colpi di clock dall'alzarsi di start
		assert (Finished = '1') report "Incorrect output #6: expected 1, received " & std_logic'image(Finished) severity error;
		-- ^^ Verifico che segnali di start corti non diano problemi
		-- NOTA: questo test non passerà (in simulazione Behavioral). È un limite progettuale che Start debba durare ALMENO un colpo di clock.
		-- (questo supponendo il caso peggiore in cui si alzi immediatamente dopo il rising_edge del clock).
		
		
		-- NOTA: Gli assert usati perdono valore in caso di simulazione Post-Route. Questo è dovuto alla (imprevedibile) differenza tra l'istante
		-- in cui viene effettuato l'assert e quello in cui effettivamente cambia il valore (differenza dovuta ai ritardi della simulazione).
		-- Un controllo manuale è più appropriato.
		-- L'ultimo controllo manuale post-route è stato effettuato il 31/12 e ha confermato la robustezza del componente. È stato inoltre
		-- rilevato un ritardo tra istante teorico e istante pratico di circa 7.2 ns.

      wait;
   end process;

END;
