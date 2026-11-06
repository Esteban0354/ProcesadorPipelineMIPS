----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2024 19:52:33
-- Design Name: 
-- Module Name: testALU - Behavioral
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

entity testALU is
    Port ( sel1 : in STD_LOGIC;
           sel2 : in STD_LOGIC;
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           leds : out STD_LOGIC_VECTOR (15 downto 0);
           zeroFlag : out STD_LOGIC);
end testALU;

architecture Behavioral of testALU is
component alu32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           zeroFlag : out STD_LOGIC;
           aluResult, aluResult2 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal tempA, tempB,tempResult : std_logic_vector (31 downto 0);
signal tempZeroF : std_logic;
begin
    tempA <= X"00000064" when sel1 = '0' else
             X"00000014";
    tempB <= X"000001F4" when sel1 = '0' else
             X"00000014";
            
    U1: alu32b
    port map(
        A => tempA,
        B => tempB,
        operation => operation,
        zeroFlag => tempZeroF,
        aluResult => tempResult
    );

    leds <= tempResult(15 downto 0) when sel2='0' else
            tempResult(31 downto 16);
    zeroFlag <= not tempZeroF;
end Behavioral;
