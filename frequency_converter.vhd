library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity frequency_converter is
--alla frequenza desiderata è assegnato un valore di default del tutto arbritrario
	Generic (desired_freq : integer := 1250);
    Port ( clock_in : in  STD_LOGIC;
           clock_out : out  STD_LOGIC);
end frequency_converter;

architecture Behavioral of frequency_converter is

--segnali interni alla macchina
--cnt per contare i cicli di clock
--switch per cambiare il valore dell'uscita
signal cnt : integer range 0 to desired_freq;
signal switch : std_logic := '0';

begin
--nella sensitivity list è presente il segnale di clock in ingresso
process(clock_in) begin
--entra solo se si rileva un fronte di salita del segnale di clock
	if (rising_edge(clock_in)) then
--quando il contatore ha raggiunto il numero di cicli desiderato
--si inverte il valore di switch e si resetta il conteggio
		if (cnt = desired_freq - 1) then
			switch <= not switch;
			cnt <= 0;
		else
--altrimenti si incrementa di uno il contatore
			cnt <= cnt + 1;
		end if;
	end if;
end process;
--l'uscita clock_out diventa il valore del segnale interno switch alla fine del processo
clock_out <= switch;

end Behavioral;

