----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2024 18:52:50
-- Design Name: 
-- Module Name: ramMemory - Behavioral
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
use IEEE.std_logic_unsigned.all;

entity ramMemory is
    Port ( clock : in STD_LOGIC;
           write : in STD_LOGIC;
           read : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (9 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end ramMemory;


architecture Behavioral of ramMemory is
    type   ram_type is array ( 0 to 1023 ) of std_logic_vector ( 31 downto 0 );
    signal ramMemory : ram_type := (X"00000000", X"8D280000", X"112A0200",
                                    X"00000000", X"8D280000", others => (others => '0'));
begin
    process (clock)
    begin
        if (clock'event and clock='1' and write='1') then
            ramMemory (conv_integer(address)) <= dataIn;
        end if;
    end process;
    
    dataOut <= ramMemory(conv_integer(address));
    
end Behavioral;

