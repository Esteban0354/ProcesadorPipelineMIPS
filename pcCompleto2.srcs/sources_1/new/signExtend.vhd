----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.09.2024 20:22:26
-- Design Name: 
-- Module Name: signExtend - Behavioral
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

entity signExtend is
    Port ( dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end signExtend;

architecture Behavioral of signExtend is

begin
    dataOut <= X"0000"&dataIn when dataIn(15)='0' else
               X"FFFF"&dataIn;

end Behavioral;
