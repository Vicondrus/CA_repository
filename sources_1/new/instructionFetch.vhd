----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 05:47:36 PM
-- Design Name: 
-- Module Name: instructionFetch - Behavioral
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

entity instructionFetch is
    Port ( clk : in STD_LOGIC;
            en: in std_logic;
            res: in std_logic;
           brncAdd : in STD_LOGIC_VECTOR (15 downto 0);
           jmpAdd : in STD_LOGIC_VECTOR (15 downto 0);
           jmp : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pcIncr : out STD_LOGIC_VECTOR (15 downto 0));
end instructionFetch;

architecture Behavioral of instructionFetch is

type arr_type is array (0 to 255) of std_logic_vector(15 downto 0);

signal rom: arr_type :=(
b"000_001_010_101_0_000",
b"000_001_010_101_0_001",
b"000_001_010_101_1_010",
b"000_001_010_101_1_011",
b"000_001_010_101_0_100",
b"000_001_010_101_0_101",
b"000_001_010_101_0_110",
b"000_001_010_101_0_111",
b"001_001_101_1111111",
b"101_001_101_1111111",
b"010_000_001_0000000",
b"011_000_010_0000001",
b"100_001_100_0000100",
b"000_001_010_101_0_000",
b"000_001_010_101_0_000",
b"000_001_010_101_0_000",
b"110_101_000_0000010",
b"000_001_010_101_0_000",
b"000_001_010_101_0_000",
b"111_1111111111111",
others=>x"0000");

signal pc: std_logic_vector(15 downto 0):= x"0000";
signal pcAux: std_logic_vector(15 downto 0);
signal mux1: std_logic_vector(15 downto 0);
signal mux2: std_logic_vector(15 downto 0);

begin

pcAux<=pc+1;
muxs: process(pcAux,brncAdd,jmpAdd,jmp,PCSrc)
begin
    if PCSrc='0' then
        mux1<=pcAux;
    else
        mux1<=brncAdd;
    end if;
    
    if jmp='1' then
        mux2<=mux1;
    else
        mux2<=jmpAdd;
    end if;
    if res='1' then
        pc<=x"0000";
    else
        if clk='1' and clk'event then
            if en='1' then
                pc<=mux2;
            end if;
        end if;
    end if;  
end process muxs;

instruction<=rom(conv_integer(pc(7 downto 0)));
pcIncr<=pcAux;

end Behavioral;
