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

entity Timer is
	Generic(K : integer := 10);
   Port ( Clock : in  STD_LOGIC;
          Reset : in  STD_LOGIC;
          Start : in  STD_LOGIC;
          Finished : out  STD_LOGIC);
end Timer;

architecture Behavioral of Timer is

--segnale interno per tener traccia del conteggio
signal counter: integer range 0 to K;
--segnale interno per verificare il segnale di start
signal toggle : std_logic;

begin
--nella sensitivity list è aggiunto il segnale di clock
process (clock) begin
--esegue solo se rileva un fronte di salita 
if (rising_edge(clock)) then
--se il segnale di reset è alto, allora il contatore deve essere portato a zero e l'uscita
--Finished deve restare bassa
	if(reset = '1') then
		counter <= 0;
		--toggle si abbassa
		toggle <= '0';
		Finished <= '0';
--se Start è alto e il contatore è a zero, procede ad incrementare di 1 counter e mantiene bassa l'uscita finished
	elsif (Start = '1' and counter = 0) then
		counter <= counter + 1;
		--il segnale di start è arrivato correttamente, per cui toggle si alza
		toggle <= '1';
		Finished <= '0';
--quando counter ha assunto il valore desiderato, finished si alza e counter si riporta a 0
	elsif(counter = K - 1) then
		Finished <= '1';
		counter <= 0;
--se i segnali di start e reset sono entrambi a 0 ed inoltre lo start è arrivato in maniera valida,
--il contatore incrementa di uno il valore interno counter	
	elsif(Start = '0' and reset = '0' and toggle = '1') then
		counter <= counter + 1;
	end if;
end if;

end process;
end Behavioral;

