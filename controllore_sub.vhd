library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity controllore_sub is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
	       check_key_1 : in  STD_LOGIC;
           check_key_2 : in  STD_LOGIC;
           timer_end : in  STD_LOGIC;
           timer_start : out  STD_LOGIC;
           safe_open : out  STD_LOGIC;
		   timer_reset : out STD_LOGIC);
end controllore_sub;

architecture Behavioral of controllore_sub is

type stato is (S0,S1,S2,S3);
signal curr_state,next_state : stato;

begin

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
			elsif(check_key_1 = '1' xor check_key_2 = '1') then	--se una delle due è 1 entra, non se lo sono entrambe
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
			elsif(check_key_1 = '1' xor check_key_2 = '1')) then
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

