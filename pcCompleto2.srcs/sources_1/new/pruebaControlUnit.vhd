library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;



entity pruebaControlUnit is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           controlSignals : out STD_LOGIC_VECTOR (19 downto 0);
           clockOut : out STD_LOGIC);
end pruebaControlUnit;

architecture Behavioral of pruebaControlUnit is
component controlUnit
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           branch, pcWrite, memRead, MemWrite, regWrite,
           iorD, irWrite, aluSrcA : out STD_LOGIC;
           regDst, aluSrcB, memToReg, pcSrc : out STD_LOGIC_VECTOR(1 downto 0);
           aluOp : out STD_LOGIC_VECTOR(3 downto 0));
end component;
    signal divClock : std_logic;
    signal countValue, newValue : std_logic_vector(31 downto 0);
    
begin
    U2: process (clock, reset)
    begin
        if (reset = '1') then
            countValue <= X"00000000";
        elsif (clock'event and clock='1') then
            countValue <= newValue;
        end if;
    end process;
    
    newValue <= countValue + 1;
    divClock <= countValue(27);
    clockOut <= divClock;
    
    
    U1: controlUnit
    port map(
        reset => reset,
        clock => divClock,
        opcode => opcode,
        branch => controlSignals(0),
        pcWrite => controlSignals(1),
        memRead => controlSignals(2),
        memWrite => controlSignals(3),
        regWrite => controlSignals(4),
        iorD => controlSignals(5),
        irWrite => controlSignals(6),
        aluSrcA => controlSignals(7),
        regDst(0) => controlSignals(8),
        regDst(1) => controlSignals(9),
        aluSrcB(0) => controlSignals(10),
        aluSrcB(1) => controlSignals(11),
        memToReg(0) => controlSignals(12),
        memToReg(1) => controlSignals(13),
        pcSrc(0) => controlSignals(14),
        pcSrc(1) => controlSignals(15),
        aluOp(0) => controlSignals(16),
        aluOp(1) => controlSignals(17),
        aluOp(2) => controlSignals(18),
        aluOp(3) => controlSignals(19)
    );



end Behavioral;
