Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ControlloreMaster is
    Port ( 
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
			  safe_open : out  STD_LOGIC;
			  timer_reset : out STD_LOGIC);
end ControlloreMaster;

architecture Behavioral of ControlloreMaster is


-- definizione stati della macchina di Moore
type stato is (S0,S1,S2,S3);
signal curr_state,next_state : stato;


-- segnali interni per l'uscita dei 2 controllori di sequenza
signal check_key_1,check_key_2 : STD_LOGIC;


-- segnali interni per il timer
signal timer_end,timer_start : STD_LOGIC;


-- componenti utilizzati all'interno del ControlloreMaster
component ControlloreSequenze is
    port (Clock, Reset, BitKey, EnableKey, EnterCode: in STD_LOGIC;
             Code: in STD_LOGIC_VECTOR (3 downto 0);
          Success: out STD_LOGIC);
end component;

component Timer is
    generic (K: INTEGER);
    port (Clock, Reset, Start: in STD_LOGIC;
          Finished: out STD_LOGIC);
end component;


begin


C1: ControlloreSequenze 
	port map (Clock=> clock, Reset => reset, BitKey => Bitkey1, Code => code1, EnableKey => Enablekey1, EnterCode => EnterCode1, Success => check_key_1);
C2: ControlloreSequenze 
	port map (Clock=> clock, Reset => reset, BitKey => Bitkey2, Code => code2, EnableKey => Enablekey2, EnterCode => EnterCode2, Success => check_key_2);

T1: Timer 
	generic map(5000000)
	port map(Clock => clock, Reset => reset,Start => timer_start,Finished => timer_end);

processo_sincrono:process(clock)
begin
if(rising_edge(clock)) then
    if(reset = '1') then
        curr_state <= S0;
    else
        curr_state <= next_state;
    end if;
end if;
end process;


transizioni : process(curr_state,check_key_1,check_key_2,timer_end)
begin
--di norma le uscite sono basse
timer_start <= '0';
safe_open <= '0';
timer_reset <= '0';

    case(curr_state) is
        when S0 => 
            if(check_key_1 = '0' and check_key_2 = '0') then
                next_state <= S0;
            elsif(check_key_1 = '1' xor check_key_2 = '1') then --se una delle due è 1 entra, non se lo sono entrambe
                next_state <= S1;
                timer_start <= '1';
            elsif(check_key_1 = '1' and check_key_2 = '1') then
                next_state <= S2;
                safe_open <= '1';
            else
                next_state <= S0;
            end if;
            
        when S1 =>
            if((check_key_1 = '1' xor check_key_2 = '1') and timer_end = '0') then
                next_state <= S1;
            elsif(check_key_1 = '0' and check_key_2 = '0' and timer_end = '0') then
                next_state <= S0;
                timer_reset <= '1';
            elsif(timer_end = '1') then
                next_state <= S3;
            elsif(check_key_1 = '1' and check_key_2 = '1' and timer_end = '0') then
                next_state <= S2;
                safe_open <= '1';
                timer_reset <= '1';
            else
                next_state <= S3;
            end if;
            
        when S2 =>
            if(check_key_1 = '1' and check_key_2 = '1') then
                next_state <= S2;
                safe_open <= '1';
            elsif(check_key_1 = '1' xor check_key_2 = '1') then
                next_state <= S3;
                safe_open <= '0';
            elsif(check_key_1 = '0' and check_key_2 = '0') then
                next_state <= S0;
            else
                next_state <= S3;
            end if;
            
        when S3 =>
            if(check_key_1 = '0' and check_key_2 = '0') then
                next_state <= S0;
            else 
                next_state <= S3;
            end if;
            
    end case;
    
end process;

end Behavioral;

