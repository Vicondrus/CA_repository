----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 08:19:56 PM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlUnit is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           WE : out STD_LOGIC;
           regSrc : out STD_LOGIC;
           aluSrc : out STD_LOGIC;
           beq : out STD_LOGIC;
           jmp : out STD_LOGIC;
           memReg : out STD_LOGIC;
           mWrite : out STD_LOGIC;
           aluOp : out STD_LOGIC_VECTOR (2 downto 0);
           blz: out std_logic;
           extOp : out STD_LOGIC);
end controlUnit;

architecture Behavioral of controlUnit is

begin

process (instr)
begin
    case instr is
    when "000" => WE<='1';
                  regSrc<='1';
                  aluSrc<='0';
                  beq<='0';
                  jmp<='1';
                  memReg<='0';
                  mWrite<='0';
                  extOp<='0';
                  aluOp<="000";
                  blz<='0';
    when "001" =>  WE<='1';
                  regSrc<='0';
                  aluSrc<='1';
                  beq<='0';
                  jmp<='1';
                  memReg<='0';
                  mWrite<='0';
                  extOp<='1';
                  aluOp<="011";
                  blz<='0';
     when "010" =>  WE<='1';
                  regSrc<='0';
                  aluSrc<='1';
                  beq<='0';
                  jmp<='1';
                  memReg<='1';
                  mWrite<='0';
                  extOp<='1';
                  aluOp<="010";
                  blz<='0';
     when "011" =>  WE<='0';
                  regSrc<='0';
                  aluSrc<='1';
                  beq<='0';
                  jmp<='1';
                  memReg<='1';
                  mWrite<='1';
                  extOp<='1';
                  aluOp<="010";
                  blz<='0';
     when "100" =>  WE<='0';
                  regSrc<='0';
                  aluSrc<='0';
                  beq<='1';
                  jmp<='1';
                  memReg<='0';
                  mWrite<='0';
                  extOp<='1';
                  aluOp<="001";
                  blz<='0';
     when "101" =>  WE<='1';
                  regSrc<='0';
                  aluSrc<='1';
                  beq<='0';
                  jmp<='1';
                  memReg<='0';
                  mWrite<='0';
                  extOp<='0';
                  aluOp<="100";
                  blz<='0';
     when "110" =>  WE<='0';
                  regSrc<='0';
                  aluSrc<='0';
                  beq<='0';
                  jmp<='1';
                  memReg<='0';
                  mWrite<='0';
                  extOp<='1';
                  aluOp<="101";
                  blz<='1';
     when others => WE<='0';
                  regSrc<='0';
                  aluSrc<='0';
                  beq<='0';
                  jmp<='0';
                  memReg<='0';
                  mWrite<='0';
                  extOp<='0';
                  aluOp<="111";
                  blz<='0';
    end case;
                  
end process;

end Behavioral;
