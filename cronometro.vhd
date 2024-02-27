----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:28:37 02/25/2024 
-- Design Name: 
-- Module Name:    cronometro - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cronometro is
    Port ( init_pause : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           sdout : out  STD_LOGIC);
end cronometro;

architecture Behavioral of cronometro is
	signal state, next_state : std_logic_vector (1 downto 0);
begin
	SYNC_PRO: process(clk)
	begin
		if(clk'event and clk = '1') then
			if(rst = '1') then
				state <= "00";    --Estado inicial
			else
				state <= next_state;
			end if;
		end if;
	end process;
	
	NEXT_STATE_CODE: process(state,init_pause,stop)
	begin
		next_state <= state;
		
		case(state) is
			when "00" =>							--Estado inicial
				if(init_pause = '1') then
					next_state <= "01";     
				end if;
			when "01" =>							--Cronometro activo
				if(init_pause = '1') then
					next_state <= "10";
				elsif(stop = '1') then
					next_state <= "00";
				end if;
			when "10" =>							--Cronometro en pausa
				if(init_pause = '1') then
					next_state <= "01";
				elsif(stop = '1') then
					next_state <= "00";
				end if;
			when others =>
				next_state <= "00";
		end case;
	end process;
		
	with state select
		sdout <= '1' when "01",
					'0' when others;

end Behavioral;

