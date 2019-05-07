----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 05:14:27 PM
-- Design Name: 
-- Module Name: instructionDeocde - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instructionDeocde is
    Port ( regWrite : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_vector (15 downto 0);
           clk : in STD_LOGIC;
           extImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           writeAdd: in std_logic_vector (2 downto 0);
           sa : out STD_LOGIC);
end instructionDeocde;

architecture Behavioral of instructionDeocde is

component RegFile is
port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end component;

signal writeAddr: std_logic_vector(2 downto 0);

begin

reg: RegFile port map (clk=>clk,ra1=>instr(12 downto 10),ra2=>instr(9 downto 7), wa=>writeAddr,wd=>wd,wen=>regWrite,rd1=>rd1,rd2=>rd2);

writeAddr <= writeAdd;
--process (regDst,instr)
--begin
--    if regDst='1' then
--        writeAddr<=instr(6 downto 4);
--    else
--        writeAddr<=instr(9 downto 7);
--    end if;
--end process;

func<=instr(2 downto 0);
sa<=instr(3);
extImm<= "000000000" & instr(6 downto 0) when ExtOp='0' else instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6 downto 0);
end Behavioral;
