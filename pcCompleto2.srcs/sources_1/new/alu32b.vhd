----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2024 18:57:37
-- Design Name: 
-- Module Name: alu32b - Behavioral
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
use ieee.std_logic_signed.all;

entity alu32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           zeroFlag : out STD_LOGIC;
           aluResult, aluResult2 : out STD_LOGIC_VECTOR (31 downto 0));
end alu32b;

architecture Behavioral of alu32b is
    signal tempResult : std_logic_vector (31 downto 0);
    signal tempMult : std_logic_vector (63 downto 0);
begin
    tempMult <= (A * B);
    
    with operation select
        tempResult <= (A + B) when "0010",
                      (A - B) when "0110",
                      (A and B) when "0000",
                      (A or B) when "0001",
                      (tempMult(31 downto 0)) when "1000",
                      (A) when others;

    zeroFlag <= '1' when tempResult = X"00000000" else
                '0';
    aluResult <= tempResult;
    aluResult2 <= tempMult(63 downto 32);

end Behavioral;
