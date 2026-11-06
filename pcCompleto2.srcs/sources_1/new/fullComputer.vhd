----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2024 20:11:34
-- Design Name: 
-- Module Name: fullComputer - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fullComputer is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           dataOut : out STD_LOGIC_VECTOR (15 downto 0));
end fullComputer;

architecture Behavioral of fullComputer is

component microProcessor is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           address : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           write : out STD_LOGIC;
           read : out STD_LOGIC);
end component;

component ramMemory is
    Port ( clock : in STD_LOGIC;
           write : in STD_LOGIC;
           read : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (9 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component register32b is
    Port ( dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           enable : in STD_LOGIC;
           clock : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component mux2to1_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal i_Address, muxOutMem,muxOutReg, memDataOut, muxOutCPU,regDataOut, processorDataOut, i_dataIn: std_logic_vector (31 downto 0);
signal i_write, i_read, memWrite, regWrite : std_logic;

begin

    processor: microProcessor
    port map(
        reset => reset,
        clock => clock,
        dataIn => i_dataIn,
        address => i_Address,
        dataOut => processorDataOut,
        write => i_write,
        read => i_read
    );
    
    ram: ramMemory
    port map(
        clock => clock,
        write => memWrite,
        read => i_read,
        address => i_Address (9 downto 0),
        dataIn => i_dataIn,
        dataOut => memDataOut
    );


    memWrite <= not i_write and i_Address(12);
    regWrite <= i_write and i_Address(12);
    i_dataIn <= X"0000" & dataIn;
    
    muxMemtoProc: mux2to1_32b
    port map(
        A => memDataOut,
        B => i_dataIn,
        sel => i_Address(12),
        muxOut => muxOutCPU
    );
    
    regOutputs: register32b
    port map(
        dataIn => processorDataOut,
        dataOut => regDataOut,
        enable => regWrite,
        clock => clock,
        reset => reset
    );
    
    dataOut <= regDataOut(15 downto 0);
    
end Behavioral;
