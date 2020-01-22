----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:15:17 01/08/2020 
-- Design Name: 
-- Module Name:    ControlloreSequenze - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlloreSequenze is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           BitKey : in  STD_LOGIC;
           Code : in  STD_LOGIC_VECTOR (3 downto 0);
           EnableKey : in  STD_LOGIC;
           EnterCode : in  STD_LOGIC;
           Success : out  STD_LOGIC);
end ControlloreSequenze;

architecture Behavioral of ControlloreSequenze is

type state is (WAITING, READY, STEADY, NO_MATCH, MATCH);
signal curr_state, next_state : state := WAITING;
signal stored_key : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal counter : integer range 0 to 4 := 0;
 
begin

Mealy : process (curr_state, counter, EnterCode, EnableKey, Reset, Code, Stored_Key)
begin
	--if(rising_edge(Clock)) then
	Success <= '0';
	next_state <= WAITING;
		if(Reset = '0' AND EnableKey = '1') then
--			next_state <= WAITING;
--			Success <= '0';
--			--report "Stored Key RES/ENABLE: " & std_logic'image(stored_key(3)) & std_logic'image(stored_key(2)) & std_logic'image(stored_key(1)) & std_logic'image(stored_key(0));			
--		else
			--report "Stored Key: " & std_logic'image(stored_key(3)) & std_logic'image(stored_key(2)) & std_logic'image(stored_key(1)) & std_logic'image(stored_key(0));			
		
			-- TRANSIZIONI MEALY
			case curr_state is
				when WAITING =>
					next_state <= READY;
					--report "Timer Start/Timer End: " & std_logic'image(timer_start) & "/" & std_logic'image(timer_end);
				when READY =>
					--report "Timer Start/Timer End: " & std_logic'image(timer_start) & "/" & std_logic'image(timer_end);
					if(counter = 4) then
						next_state <= STEADY;
					else
						next_state <= READY;
					end if;
				when STEADY =>
					if(EnterCode = '1') then
						if(Code = stored_key) then
							next_state <= MATCH;
							Success <= '1';
						else
							next_state <= NO_MATCH;
						end if;
					else
						next_state <= STEADY;
					end if;
				when MATCH =>
					next_state <= MATCH;
					Success <= '1';
				when NO_MATCH =>
					next_state <= NO_MATCH;
			end case;
			-- FINE TRANSIZIONI MEALY
		end if;
	--end if;	
end process;

StateChange : process (Clock)
begin
	if(rising_edge(Clock)) then
		curr_state <= next_state;
	end if;
end process;

ReadKey : process (Clock)
begin
	if(rising_edge(Clock)) then
		if(Reset = '1' OR EnableKey = '0') then
			stored_key <= "0000";
			counter <= 0;
		elsif(counter = 4) then
			counter <= 0;
		elsif(curr_state = READY) then
			stored_key <= BitKey & stored_key(3) & stored_key(2) & stored_key(1);
			counter <= counter + 1;
		end if;
	end if;
end process;

end Behavioral;

