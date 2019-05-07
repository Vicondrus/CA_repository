----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2019 08:56:36 PM
-- Design Name: 
-- Module Name: exUnit - Behavioral
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exUnit is
    Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           aluSrc : in STD_LOGIC;
           extImm : in STD_LOGIC_VECTOR (15 downto 0);
           pcIncr : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           aluOp : in STD_LOGIC_VECTOR (2 downto 0);
           brAddr : out STD_LOGIC_VECTOR (15 downto 0);
           zero : out STD_LOGIC;
           neg: out std_logic;
           aluRes : out STD_LOGIC_VECTOR (15 downto 0));
end exUnit;


architecture Behavioral of exUnit is

signal op2: std_logic_vector(15 downto 0);
signal aluCtrl: std_logic_vector(2 downto 0);
signal res: std_logic_vector(15 downto 0);

begin

brAddr<=pcIncr+extImm;
neg<=rd1(15);

process (rd2, extImm, aluSrc)
begin
    if aluSrc='1' then
        op2<=extImm;
    else
        op2<=rd2;
    end if;
end process;

alu: process(rd1, op2, aluCtrl, sa)
begin
    case aluCtrl is
    when "000" => res<=rd1+op2;
    when "001" => res<=rd1-op2;
    when "010" => case sa is
                  when '1' => res(15 downto 0)<=rd1(14 downto 0)&'0';
                  when others => res<=rd1;
                  end case;
    when "011" => case sa is
                  when '1' => res(15 downto 0)<='0'&rd1(15 downto 1);
                  when others => res<=rd1;
                  end case;
    when "100" => res<=rd1 and op2;
    when "101" => res<=rd1 or op2;
    when "110" => res<=rd1 xor op2;
    when others => case op2 is
                  when "0000" => res<=rd1;
                  when "0001" => res(15 downto 0)<=rd1(14 downto 0)&'0';
                  when "0010" => res(15 downto 0)<=rd1(13 downto 0)&"00";
                  when "0011" => res(15 downto 0)<=rd1(12 downto 0)&"000";
                  when "0100" => res(15 downto 0)<=rd1(11 downto 0)&"0000";
                  when "0101" => res(15 downto 0)<=rd1(10 downto 0)&"00000";
                  when "0110" => res(15 downto 0)<=rd1(9 downto 0)&"000000";
                  when "0111" => res(15 downto 0)<=rd1(8 downto 0)&"0000000";
                  when "1000" => res(15 downto 0)<=rd1(7 downto 0)&"00000000";
                  when "1001" => res(15 downto 0)<=rd1(6 downto 0)&"000000000";
                  when "1010" => res(15 downto 0)<=rd1(5 downto 0)&"0000000000";
                  when "1011" => res(15 downto 0)<=rd1(4 downto 0)&"00000000000";
                  when "1100" => res(15 downto 0)<=rd1(3 downto 0)&"000000000000";
                  when "1101" => res(15 downto 0)<=rd1(2 downto 0)&"0000000000000";
                  when "1110" => res(15 downto 0)<=rd1(1 downto 0)&"00000000000000";
                  when "1111" => res(15 downto 0)<=rd1(0)&"000000000000000";
                  when others => res<="0000000000000000";
                  end case;
    end case;
aluRes<=res;
end process alu;

zero<='1' when res=x"0000" else '0';

aluController: process(aluOp, func)
begin
    case aluOp is
    when "000" => aluCtrl <= func; --R type
    when "001" => aluCtrl <= "001"; --beq
    when "010" => aluCtrl <= "000"; --lw/sw
    when "011" => aluCtrl <= "000"; --addi
    when "100" => aluCtrl <= "110"; --xori
    when "101" => aluCtrl <= "000"; --blz
    when "110" => aluCtrl <= "000"; --
    when others => aluCtrl <= "000";
    end case;
end process aluController;

end Behavioral;
