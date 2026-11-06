----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Esteban Muñoz Serrano
-- 
-- Create Date: 03.10.2024 19:49:54
-- Design Name: 
-- Module Name: controlUnit - Behavioral
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


entity controlUnit is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           branch, pcWrite, memRead, memWrite, regWrite,
           iorD, irWrite, aluSrcA : out STD_LOGIC;
           regDst, aluSrcB, memToReg, pcSrc : out STD_LOGIC_VECTOR(1 downto 0);
           aluOp : out STD_LOGIC_VECTOR(3 downto 0));
end controlUnit;

architecture Behavioral of controlUnit is
    type stateType is (fetchST, decodeST, memAddrST, memReadST, memWBST,
                       memWriteST, executeST, aluWBST, jalST, beqST, jumpST,
                       andiST, iWBST, addiST, oriST, sltiST, luiST);
    signal currentState, nextState : stateType;

begin

    stateRegister: process (clock, reset)
    begin
        if (reset = '1') then
            currentState <= fetchST;
        elsif (clock'event and clock='1') then
            currentState <= nextState;
        end if;
    end process;
    
    nextStateFunction: process (currentState, opcode)
    begin
         
   case (currentState) is
      when fetchST =>
         nextState <= decodeST;
      when decodeST =>
         case (opcode) is
            when "100011" =>
                nextState <= memAddrST;
            when "101011" =>
                nextState <= memAddrST;
            when "000011" =>
                nextState <= jalST;
            when "000000" =>
                nextState <= executeST;
            when "000100" =>
                nextState <= beqST;
            when "000010" =>
                nextState <= jumpST;
            when "001100" =>
                nextState <= andiST;
            when "001000" =>
                nextState <= addiST;
            when "001101" =>
                nextState <= oriST;
            when "001010" =>
                nextState <= sltiST;
            when "001111" =>
                nextState <= luiST;
            when others =>
                nextState <= fetchST;
         end case;
      when memAddrST =>
         if (opcode = "100011") then
            nextState <= memReadST;
         else
            nextState <= memWriteST;
         end if;
      when memReadST =>
         nextState <= memWBST;
      when memWriteST =>
         nextState <= fetchST;
      when memWBST =>
         nextState <= fetchST;
      when jalST =>
         nextState <= fetchST;
      when executeST =>
         nextState <= aluWBST;
      when aluWBST =>
         nextState <= fetchST;
      when beqST =>
         nextState <= fetchST;
      when jumpST =>
         nextState <= fetchST;
      when andiST =>
         nextState <= iWBST;
      when iWBST =>
         nextState <= fetchST;
      when addiST =>
         nextState <= iWBST;
      when oriST =>
         nextState <= iWBST;
      when sltiST =>
         nextState <= iWBST;
      when luiST =>
         nextState <= iWBST;
      when others =>
         nextState <= fetchST;
   end case;
				
    
  end process;
  
  outputFunction: process(currentState)
  begin
  case (currentState) is
    when fetchST =>
        branch <= '0';
        pcWrite <= '1';
        memRead <= '1';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '1';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "01";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when decodeST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "11";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when memAddrST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "10";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when memReadST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '1';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '1';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when memWBST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '1';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "01";
        pcSrc <= "00";
        aluOp <= "0000";
     when memWriteST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '1';
        regWrite <= '0';
        iorD <= '1';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when executeST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0010";
     when aluWBST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '1';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "01";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when beqST =>
        branch <= '1';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "01";
        aluOp <= "0001";
     when jumpST =>
        branch <= '0';
        pcWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "10";
        aluOp <= "0000";
     when jalST =>
        branch <= '0';
        pcWrite <= '1';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '1';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "10";
        aluSrcB <= "00";
        memToReg <= "10";
        pcSrc <= "10";
        aluOp <= "0100";
     when andiST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "10";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0100";
     when addiST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "10";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when oriST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "10";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0011";
     when sltiST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "10";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0101";
     when luiST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '1';
        regDst <= "00";
        aluSrcB <= "10";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0110";
     when iWBST =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '1';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
     when others =>
        branch <= '0';
        pcWrite <= '0';
        memRead <= '0';
        memWrite <= '0';
        regWrite <= '0';
        iorD <= '0';
        irWrite <= '0';
        aluSrcA <= '0';
        regDst <= "00";
        aluSrcB <= "00";
        memToReg <= "00";
        pcSrc <= "00";
        aluOp <= "0000";
    
    end case;
   end process;

end Behavioral;
