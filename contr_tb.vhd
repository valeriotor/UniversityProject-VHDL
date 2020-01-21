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
              safe_open : out  STD_LOGIC
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
          safe_open => safe_open
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
			
			--La seguente riga può essere de-commentata per verificare il componente in condizioni di sfasamento.
			--wait for 7 ns;
        
		  
        code1 <= "0110";
        code2 <= "0110";
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
        entercode2 <= '1';
        wait for clock_period*3;
        assert safe_open = '1' report "Incorrect output #1: expected 1, received " & std_logic'image(safe_open) severity error;
        
        --^^^controllo se avendo i 2 controllori a 1 la cassaforte si apre
			enablekey1<='0';
			wait for clock_period*2;
        assert safe_open = '0' report "Incorrect output #2: expected 0, received " & std_logic'image(safe_open) severity error;
			
			--^^^controllo se la cassaforte si chiude levando la chiave
			
        -- voglio il check_key_1 <= '0';
        code1 <= "1111";
        code2 <= "0110";
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
        entercode2 <= '1';
        wait for clock_period*3;
        assert safe_open = '0' report "Incorrect output #3: expected 0, received " & std_logic'image(safe_open) severity error;
        --^^^controllo se avendo 1 controllore a 0 e l'altro a 1 la cassaforte resti chiusa
        	
			Enablekey1 <= '0';
			Enablekey2 <= '0';
			wait for clock_period;
        
        code1 <= "1010";
        code2 <= "1111";
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
        entercode2 <= '1';
        wait for clock_period*3;
        assert safe_open = '0' report "Incorrect output #4: expected 0, received " & std_logic'image(safe_open) severity error;
        
        --^^^controllo se avendo i 2 controllori a 0 la cassaforte resti chiusa
        
			Enablekey1 <= '0';
			Enablekey2 <= '0';
			wait for clock_period;
		  
        code1 <= "1111";
        code2 <= "1111";
        -- voglio check_key_1 <= '0';
        Enablekey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
        wait for clock_period;
        Bitkey1 <= '1';
        wait for clock_period;
        Bitkey1 <= '0';
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
        wait for clock_period;
        entercode2 <= '1';
        wait for clock_period*3;
        assert safe_open = '0' report "Incorrect output #5: expected 0, received " & std_logic'image(safe_open) severity error;
        
        --^^^controllo se avendo 1 controllore a 1 e l'altro a 0 la cassaforte resti chiusa
			
			-- ADDENDUM: Test aggiuntivi creati in data 21/01
			
			
			Enablekey1 <= '0';
			Enablekey2 <= '0';
			wait for clock_period;
			
			code1 <= "0110";
			code2 <= "0110";
			Enablekey1 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			wait for clock_period;
			Bitkey1 <= '1';
			wait for clock_period;
			Bitkey1 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			wait for clock_period;
			entercode1 <= '1';
			wait for clock_period*25;
			Enablekey2 <= '1';
			wait for clock_period;
			Bitkey2 <= '0';
			wait for clock_period;
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey2 <= '0';
			wait for clock_period;
			entercode2 <= '1';
			wait for clock_period*3;
			assert safe_open = '0' report "Incorrect output #6: expected 0, received " & std_logic'image(safe_open) severity error;
			--^^ Questo test ha lo scopo di verificare se lo scadere del timer vieta effettivamente l'apertura della cassaforte. A scopo
			-- di debugging la durata del timer è stata impostata a 25.
			
			Enablekey1 <= '0';
			Enablekey2 <= '0';
			wait for clock_period;
			
			code1 <= "0110";
			code2 <= "0110";
			Enablekey1 <= '1';
			Enablekey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			Bitkey2 <= '0';
			wait for clock_period;
			Bitkey1 <= '1';
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '1';
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			Bitkey2 <= '0';
			wait for clock_period;
			entercode1 <= '1';
			entercode2 <= '1';
			wait for clock_period*3;
			assert safe_open = '1' report "Incorrect output #7: expected 1, received " & std_logic'image(safe_open) severity error;
			--^^ Questo test verifica che la cassaforte si apri se entrambi i controllori alzano il segnale al contempo
			
			Enablekey1 <= '0';
			Enablekey2 <= '0';
			wait for clock_period;
			
			code1 <= "0110";
			code2 <= "0110";
			Enablekey1 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			wait for clock_period;
			Bitkey1 <= '1';
			wait for clock_period;
			Bitkey1 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			wait for clock_period;
			entercode1 <= '1';
			wait for clock_period*2;
			Enablekey1 <= '0';
			wait for clock_period*15;
			Enablekey1 <= '1';
			Enablekey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			Bitkey2 <= '0';
			wait for clock_period;
			Bitkey1 <= '1';
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '1';
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			Bitkey2 <= '0';
			wait for clock_period;
			entercode1 <= '1';
			wait for clock_period*10; -- mi assicuro che sia nello stato S1 per un po'
			entercode2 <= '1';
			wait for clock_period*3;
			assert safe_open = '1' report "Incorrect output #8: expected 1, received " & std_logic'image(safe_open) severity error;
			--^^ Questo test verifica che, qualora una chiave dovesse essere messa e confermata, ma poi tolta prima dell'inserimento dell'altra, 
			-- il timer si resetti correttamente.
			-- Dunque dopo un certo numero di colpi di clock (15) dalla rimozione della chiave ritento di inserire le chiavi, assicurandomi di
			-- impiegare *almeno* un'altra decina di colpi di clock. Se il timer di prima non si dovesse essere resettato, terminerebbe ora 
			-- interrompendo l'apertura della cassaforte.
			
			Enablekey1 <= '0';
			Enablekey2 <= '0';
			wait for clock_period*15;
			code1 <= "0110";
			code2 <= "0110";
			Enablekey1 <= '1';
			Enablekey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			Bitkey2 <= '0';
			wait for clock_period;
			Bitkey1 <= '1';
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '1';
			Bitkey2 <= '1';
			wait for clock_period;
			Bitkey1 <= '0';
			Bitkey2 <= '0';
			wait for clock_period;
			entercode1 <= '1';
			wait for clock_period*12;
			entercode2 <= '1';
			wait for clock_period*3;
			assert safe_open = '1' report "Incorrect output #9: expected 1, received " & std_logic'image(safe_open) severity error;
			--^^ Questo test verifica (similmente all'ultimo test) il corretto reset del timer, ma stavolta nel caso dell'apertura della
			-- cassaforte (e non della rimozione di una chiave quando si era in attesa dell'altra).
			
      wait;
   end process;
	
END;
