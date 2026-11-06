----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 10:35:02 PM
-- Design Name: 
-- Module Name: aluControl - Behavioral
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


entity aluControl is
    Port ( Aluop : in STD_LOGIC_VECTOR (3 downto 0);
           funct : in STD_LOGIC_VECTOR (5 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end aluControl;

architecture Behavioral of aluControl is
    signal temp: std_logic_vector (3 downto 0);
begin
    operation <= temp;
    controlador : process (funct, ALUOP)
        begin
            if (ALUOP = "0000") then
                temp <= "0010"; --suma
                
            elsif (ALUOP = "0001") then
                temp <= "0110"; --resta
                
            elsif (ALUOP = "0011") then
                temp <= "0001"; --or
                
            elsif (ALUOP = "0100") then
                temp <= "0000"; --and
                
            elsif (ALUOP = "0101") then
                temp <= "0111"; -- slt
                
            elsif (ALUOP = "0010") then -- tipo R
                if (funct = "100000") then
                    temp <= "0010";
                    
                elsif (funct = "100010") then
                    temp <= "0110";
                    
                elsif (funct = "100100") then
                    temp <= "0000";
                    
                elsif (funct = "100101") then
                    temp <= "0001";
                    
                elsif (funct = "100111") then
                    temp <= "0011";
                    
                elsif (funct = "101010") then
                    temp <= "0111";
                    
                elsif (funct = "000000") then
                    temp <= "0100";
                    
                elsif (funct = "000010") then
                    temp <= "0101";
                    
                elsif (funct = "010010") then
                    temp <= "1111";
                    
                elsif (funct = "001100") then
                    temp <= "1110";
                else
                    temp <= "0010";    
                end  if;
            else
                temp <= (others => '0');
            end if;
        end process;
end Behavioral;