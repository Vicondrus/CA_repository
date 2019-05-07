----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2019 04:35:49 PM
-- Design Name: 
-- Module Name: RAMTest - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAMTest is
    Port (but1 : in std_logic;
           but2: in std_logic;
           clk: in std_logic;
           cat: out std_logic_vector(6 downto 0);
           an: out std_logic_vector(3 downto 0);
           res: in std_logic;
           led: out std_logic_vector(15 downto 0)
     );
end RAMTest;

architecture Behavioral of RAMTest is

component SevenSegmentDisplay is
    Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component RAM is
 port ( clk : in std_logic;
 we : in std_logic;
 en : in std_logic;
 addr : in std_logic_vector(7 downto 0);
 di : in std_logic_vector(15 downto 0);
 do : out std_logic_vector(15 downto 0));
end component;

signal count: std_logic_vector (7 downto 0):=x"00";
signal en1: std_logic;
signal en2: std_logic;
signal output: std_logic_vector(15 downto 0);
signal aux: std_logic_vector(15 downto 0);

begin

deb1: debouncer port map (btn=>but1,clk=>clk,enable=>en1);
deb2: debouncer port map (btn=>but2,clk=>clk,enable=>en2);

counter: process(count)
begin
    if clk='1' and clk'event then
        if en1='1' then
            count<=count+1;
        end if;
        if res='1' then
            count<=x"00";
        end if;
    end if;
end process counter;

sev: SevenSegmentDisplay port map (clk=>clk,Digit0=>aux(3 downto 0),cat=>cat,an=>an,Digit1=>aux(7 downto 4),Digit2=>aux(11 downto 8),Digit3=>aux(15 downto 12));

rom1: RAM port map(clk=>clk,we=>en2,en=>'1',addr=>count,do=>output,di(15 downto 0)=>aux);
led<=aux;
aux<=output(13 downto 0)&"00";

end Behavioral;
