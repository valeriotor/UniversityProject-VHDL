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
	if(reset = '1') then					-- Un reset abbassa sia output che segnali interni
		counter <= 0;
		toggle <= '0';
		Finished <= '0';
	elsif(Start = '1') then				-- Uno start è identico a un reset, eccetto che alza toggle per permettere il conteggio
		counter <= 0;
		toggle <= '1';
		Finished <= '0';
	elsif(counter = K - 1) then		-- Al valore desiderato si alza Finished (e counter si incrementa di nuovo)
		Finished <= '1';
		counter <= counter + 1;
	elsif(counter = K) then				-- Successivamente si effettua un reset del componente.
		Finished <= '0';
		counter <= 0;
		toggle <= '0';
	elsif(toggle = '1') then			-- Come ultimo caso, si incrementa counter solo se toggle è alto
		counter <= counter + 1;
	end if;
end if;

end process;
end Behavioral;

