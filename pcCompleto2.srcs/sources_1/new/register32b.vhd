----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.09.2024 19:45:01
-- Design Name: 
-- Module Name: register32b - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

entity register32b is
    Port ( dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           enable : in STD_LOGIC;
           clock : in STD_LOGIC;
           reset : in STD_LOGIC);
end register32b;

architecture Behavioral of register32b is

begin
    process (clock,reset)
    begin
        if (reset = '1') then
            dataOut <= X"00000000";
        elsif (clock'event and clock='1' and enable = '1') then
            dataOut <= dataIn;
        end if;
    end process;

end Behavioral;
