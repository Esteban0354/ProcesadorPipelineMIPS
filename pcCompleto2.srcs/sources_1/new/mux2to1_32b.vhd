----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.09.2024 19:57:43
-- Design Name: 
-- Module Name: mux2to1_32b - Behavioral
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

entity mux2to1_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end mux2to1_32b;

architecture Behavioral of mux2to1_32b is

begin
    muxOut <= A when sel='0' else
              B;

end Behavioral;
