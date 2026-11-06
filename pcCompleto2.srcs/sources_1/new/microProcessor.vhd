----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2024 19:23:26
-- Design Name: 
-- Module Name: microProcessor - Behavioral
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

entity microProcessor is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           address : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           write : out STD_LOGIC;
           read : out STD_LOGIC);
end microProcessor;

architecture Behavioral of microProcessor is

component register32b is
    Port ( dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           enable : in STD_LOGIC;
           clock : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component controlUnit
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           branch, pcWrite, memRead, MemWrite, regWrite, iorD, irWrite, aluSrcA : out STD_LOGIC;
           regDst, aluSrcB, memToReg, pcSrc : out STD_LOGIC_VECTOR(1 downto 0);
           aluOp : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component registerFile is
  Port (clock, wEnable : in std_logic;
        address1, address2, address3: in std_logic_vector(4 downto 0);
        dataIn : in std_logic_vector(31 downto 0);
        dataOut1, dataOut2 : out std_logic_vector(31 downto 0) );
end component;

component alu32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           zeroFlag : out STD_LOGIC;
           aluResult, aluResult2 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux2to1_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;
 
component mux4to1_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux4to1_5b is
    Port ( A : in STD_LOGIC_VECTOR (4 downto 0);
           B : in STD_LOGIC_VECTOR (4 downto 0);
           C : in STD_LOGIC_VECTOR (4 downto 0);
           D : in STD_LOGIC_VECTOR (4 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component signExtend is
    Port ( dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component aluControl is
    Port ( Aluop : in STD_LOGIC_VECTOR (3 downto 0);
           funct : in STD_LOGIC_VECTOR (5 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component ramMemory is
    Port ( clock : in STD_LOGIC;
           write : in STD_LOGIC;
           read : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (9 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal i_irWrite, i_branch, i_pcWrite, i_regWrite, i_iorD, i_aluSrcA, i_read, i_write, i_aluZero, i_pcEn : std_logic;
signal i_regDst, i_aluSrcB, i_memToReg, i_pcSrc : std_logic_vector (1 downto 0);
signal i_aluop, operationAlu : std_logic_vector (3 downto 0);
signal irOut, mdrOut, rfA, rfB, wRFdataIn,mux2Alu, se2Mux, mux4Alu, i_AluOut,i_AluOut2, pcOut, muxAddress, mux4PcSrc, tempMuxPc, aluRegOut, regA, regB : std_logic_vector (31 downto 0);
signal wRFaddress: std_logic_vector(4 downto 0);


begin
    IR: register32b
    port map(
        reset => reset,
        clock => clock,
        enable => i_irWrite,
        dataIn => dataIn,
        dataOut => irOut
    );

    MDR: register32b
    port map(
        reset => reset,
        clock => clock,
        enable => '1',
        dataIn => dataIn,
        dataOut => mdrOut
    );
    
    controlU: controlUnit
    port map(
        reset => reset,
        clock => clock,
        opcode => irOut(31 downto 26),
        branch => i_branch,
        pcWrite => i_pcWrite,
        memRead => i_read,
        memWrite => i_write,
        regWrite => i_regWrite,
        iorD => i_iorD,
        irWrite => i_irWrite,
        aluSrcA => i_aluSrcA,
        regDst => i_regDst,
        aluSrcB => i_aluSrcB,
        memToReg => i_memToReg,
        pcSrc => i_pcSrc,
        aluOp => i_aluOp
    );
    
    regFile: registerFile
    port map(
        clock => clock,
        wEnable => i_regWrite,
        address1 => irOut(25 downto 21),
        address2 => irOut(20 downto 16),
        address3 => wRFaddress,
        dataIn => wRFdataIn,
        dataOut1 => rfA,
        dataOut2 => rfB
    );
 ------------------------------------------------------------------------------------------------------------

    aluCtrl: aluControl
    port map(
        Aluop => i_aluop,
        funct => irOut(5 downto 0),
        operation => operationAlu
    );
        
    registerA: register32b
    port map(
        dataIn => rfA,
        dataOut => regA,
        enable => '1',
        clock => clock,
        reset => reset
    );
    
    muxRegA: mux2to1_32b
    port map(
        A => pcOut,
        B => regA,
        sel => i_aluSrcA,
        muxOut => mux2Alu
    );
    
    registerB: register32b
    port map(
        dataIn => rfB,
        dataOut => regB,
        enable => '1',
        clock => clock,
        reset => reset
    );
    --regB => dataOut;
    dataOut <= regB;
    se2Mux <= X"0000" & irOut(15 downto 0);
    muxRegB: mux4to1_32b
    port map(
        A => regB,
        B => "00000000000000000000000000000001",
        C => se2Mux,
        D => se2Mux,
        sel => i_aluSrcB,
        muxOut => mux4Alu
    );
    
    alu: alu32b
    port map(
        A => mux2Alu,
        B => mux4Alu,
        operation => operationAlu,
        zeroFlag => i_aluZero,
        aluResult => i_AluOut, 
        aluResult2 => i_AluOut2
    );


    aluReg: register32b
    port map(
        dataIn => i_AluOut,
        dataOut => aluRegOut,
        enable => '1',
        clock => clock,
        reset => reset
    );
    muxWr: mux4to1_5b
    port map(
        A => irOut(20 downto 16),
        B => irOut(15 downto 11),
        C => "11111",
        D => "00000",
        sel => i_regDst,
        muxOut => wRFaddress
    );
    
--    memory: ramMemory
--    port map(
--        clock => clock,
--        write => i_write,
--        read => i_read,
--        address => muxAddress(9 downto 0),
--        dataIn => dataIn,
--        dataOut => memOut
--    );
    
    write <= i_write;
    read <= i_read;
    
    pc: register32b
    port map(
        dataIn => mux4PcSrc,
        dataOut => pcOut,
        enable => i_pcWrite,
        clock => clock,
        reset => reset
    );
    
    muxPc: mux2to1_32b
    port map(
        A => pcOut,
        B => i_AluOut,
        sel => i_iorD,
        muxOut => address
    );
    
    tempMuxPc <=  pcOut(31 downto 26) & irOut(25 downto 0); 
    muxPcSrc: mux4to1_32b
    port map(
        A => i_AluOut,
        B => aluRegOut,
        C => tempMuxPc,
        D => X"00000000",
        sel => i_pcSrc,
        muxOut => mux4PcSrc
    );

    muxWd: mux4to1_32b
    port map(
        A => i_AluOut,
        B => mdrOut,
        C => pcOut,
        D => X"00000000",
        sel => i_memToReg,
        muxOut => wRFdataIn
    );
end Behavioral;
