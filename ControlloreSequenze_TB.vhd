--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:38:32 01/09/2020
-- Design Name:   
-- Module Name:   /home/valeriotor/Scrivania/Valerio/Uni/XilinxWEBPACK/14.7/ISE_DS/Safe/ControlloreSequenze_TB.vhd
-- Project Name:  Safe
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ControlloreSequenze
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY ControlloreSequenze_TB IS
END ControlloreSequenze_TB;
 
ARCHITECTURE behavior OF ControlloreSequenze_TB IS 
	
	-- Utilizzato per facilitare il loop test
	signal LoopVector : std_logic_vector(3 downto 0) := "0000";
	
	-- Utilizzato per debugging Post-Route. Lo controllo prima e dopo degli assert per aggiungere rispettivamente
	-- un ritardo di 6 e 4 ns, così da tener conto del ritardo proprio della simulazione Post-Route.
	signal PostRoute : boolean := false;
	
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlloreSequenze
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         BitKey : IN  std_logic;
         Code : IN  std_logic_vector(3 downto 0);
         EnableKey : IN  std_logic;
         EnterCode : IN  std_logic;
         Success : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal BitKey : std_logic := '0';
   signal Code : std_logic_vector(3 downto 0) := (others => '0');
   signal EnableKey : std_logic := '0';
   signal EnterCode : std_logic := '0';

 	--Outputs
   signal Success : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ControlloreSequenze PORT MAP (
          Clock => Clock,
          Reset => Reset,
          BitKey => BitKey,
          Code => Code,
          EnableKey => EnableKey,
          EnterCode => EnterCode,
          Success => Success
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
		Reset <= '1';
      wait for 60 ns;	
		Reset <= '0';
      wait for Clock_period*4;
		
		Code <= "1011";
		EnableKey <= '1';
		wait for Clock_period;
		BitKey <= '1';
		wait for Clock_period;
		BitKey <= '1';
		wait for Clock_period;
		BitKey <= '0';
		wait for Clock_period;
		BitKey <= '1';
		wait for Clock_period;
		EnterCode <= '1';
		wait for Clock_period*2;
		if(PostRoute = true) then wait for 6 ns;	end if;
		assert (Success = '1') report "Incorrect output #1: expected 1, received " & std_logic'image(Success) severity error;
		if(PostRoute = true) then wait for 4 ns;	end if;
		Code <= "0001";
		wait for Clock_period;
		if(PostRoute = true) then wait for 6 ns;	end if;
		assert (Success = '1') report "Incorrect output #2: expected 1, received " & std_logic'image(Success) severity error;
		wait for Clock_period * 10;
		if(PostRoute = true) then wait for 4 ns;	end if;
		EnableKey <= '0';
		wait for Clock_period;
		if(PostRoute = true) then wait for 6 ns;	end if;
		assert (Success = '0') report "Incorrect output #3: expected 0, received " & std_logic'image(Success) severity error;
		if(PostRoute = true) then wait for 4 ns;	end if;
		-- ^^ Semplice controllo iniziale per verificare che il componente funzioni a dovere. #1 verifica che l'output si alzi,
		-- #2 verifica che l'output non si abbassi al cambiare del codice, #3 verifica che l'output si abbassi all'abbassarsi di
		-- EnableKey (che nel componente principale coinciderà con il sensore della chiave).
		
		EnterCode <= '0';
		EnableKey <= '1';
		wait for Clock_period;
		BitKey <= '0';
		wait for Clock_period;
		BitKey <= '0';
		wait for Clock_period;
		BitKey <= '0';
		wait for Clock_period;
		BitKey <= '0';
		wait for Clock_period;
		EnterCode <= '1';		
		wait for Clock_period*2;
		if(PostRoute = true) then wait for 6 ns;	end if;
		assert (Success = '0') report "Incorrect output #4: expected 0, received " & std_logic'image(Success) severity error;
		-- ^^ Verifico che un codice sbagliato non alzi l'uscita.
		
		EnableKey <= '0';
		wait for Clock_period;
		if(PostRoute = true) then wait for 4 ns;	end if;
		
		for i in 0 to 15 loop
			Code <= std_logic_vector(to_unsigned(i, Code'length));
			for j in 0 to 15 loop
				LoopVector <= std_logic_vector(to_unsigned(j, LoopVector'length));
				
				EnableKey <= '1';
				EnterCode <= '0';
				wait for Clock_Period;
				BitKey <= LoopVector(0);
				wait for Clock_Period;
				BitKey <= LoopVector(1);
				wait for Clock_Period;
				BitKey <= LoopVector(2);
				wait for Clock_Period;
				BitKey <= LoopVector(3);
				wait for Clock_Period;
				EnterCode <= '1';
				wait for Clock_Period*2;
						
				if(PostRoute = true) then wait for 6 ns;	end if;
				
				if(Code = LoopVector) then
					assert (Success = '1') report "Incorrect output #5: expected 1, received " & std_logic'image(Success) & " for i/j = " & integer'image(i) & "/" & integer'image(j) severity error;
				else
					assert (Success = '0') report "Incorrect output #5: expected 0, received " & std_logic'image(Success) & " for i/j = " & integer'image(i) & "/" & integer'image(j) severity error;
				end if;
				wait for Clock_Period;
				EnableKey <= '0';
				wait for Clock_Period;
						
				if(PostRoute = true) then wait for 4 ns;	end if;
				
			end loop;
		end loop;
		-- ^^ Verifico tutte le 256 combinazioni tra chiave e codice (4 bit ciascuno => 16x16 comb.). 
		
		-- Aggiungo una fase di 7 nanosecondi per vedere come se la cava con segnali di clock sfasati.
		wait for 7 ns;
		report "INIZIO SECONDO LOOP" severity note;
		
		for i in 0 to 15 loop
			Code <= std_logic_vector(to_unsigned(i, Code'length));
			for j in 0 to 15 loop
				LoopVector <= std_logic_vector(to_unsigned(j, LoopVector'length));
				
				EnableKey <= '1';
				EnterCode <= '0';
				wait for Clock_Period;
				BitKey <= LoopVector(0);
				wait for Clock_Period;
				BitKey <= LoopVector(1);
				wait for Clock_Period;
				BitKey <= LoopVector(2);
				wait for Clock_Period;
				BitKey <= LoopVector(3);
				wait for Clock_Period;
				EnterCode <= '1';
				wait for Clock_Period*2;				
						
				if(PostRoute = true) then wait for 6 ns;	end if;
				
				if(Code = LoopVector) then
					assert (Success = '1') report "Incorrect output #6: expected 1, received " & std_logic'image(Success) & " for i/j = " & integer'image(i) & "/" & integer'image(j) severity error;
				else
					assert (Success = '0') report "Incorrect output #6: expected 0, received " & std_logic'image(Success) & " for i/j = " & integer'image(i) & "/" & integer'image(j) severity error;
				end if;
				wait for Clock_Period;
				EnableKey <= '0';
				wait for Clock_Period;
				if(PostRoute = true) then wait for 4 ns;	end if;
			end loop;
		end loop;
		-- ^^ Effettuo direttamente un altro loop per verificare il componente in condizioni di sfasamento.
		
		wait;
   end process;

END;
