----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.09.2024 20:09:24
-- Design Name: 
-- Module Name: mux4to1_32b - Behavioral
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


entity mux4to1_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end mux4to1_32b;

architecture Behavioral of mux4to1_32b is

begin
--    muxOut <= A when sel="00" else
--                B when sel= "01" else
--                C when sel="10" else
--                D;
    with sel select
        muxOut <= A when "00",
                  B when "01",
                  C when "10",
                  D when others;

end Behavioral;
