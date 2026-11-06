----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2024 19:11:47
-- Design Name: 
-- Module Name: registerFile - Behavioral
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
use ieee.std_logic_unsigned.all;

entity registerFile is
  Port (clock, wEnable : in std_logic;
        address1, address2, address3: in std_logic_vector(4 downto 0);
        dataIn : in std_logic_vector(31 downto 0);
        dataOut1, dataOut2 : out std_logic_vector(31 downto 0) );
end registerFile;

architecture Behavioral of registerFile is
    type memoryType is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regFile : memoryType;
begin

    process (clock, wEnable)
    begin
        if (clock'event and clock='1' and wEnable='1') then
            regFile (conv_integer(address3)) <= dataIn;
        end if;
    end process;
    
    dataOut1 <= x"00000000" when address1= "00000" else
                regFile(conv_integer(address1));
    dataOut2 <= x"00000000" when address2= "00000" else
                regFile(conv_integer(address2));
    
end Behavioral;
