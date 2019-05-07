----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 12:52:13 PM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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

entity debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

component counter is
    Port ( clk : in STD_LOGIC;
          en: in STD_LOGIC;
          rst: in STD_LOGIC;
          dir: in STD_LOGIC;
          led: out STD_LOGIC_VECTOR(15 downto 0));
end component;

component Dff is
    Port ( D : in STD_LOGIC;
           en : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC);
end component;

signal q1: std_logic;
signal q2: std_logic;
signal q3: std_logic;
signal leds: std_logic_vector(15 downto 0):=x"0000";
signal en: std_logic;

begin

--count: counter port map (clk=>clk, en=>'1', rst=>'0', dir=>'1',led=>leds);

count1: process(clk)
begin
    if clk='1' and clk'event then
        leds<=leds+1;
    end if;
end process count1;

process (leds)
begin
    if leds=x"FFFF" then
        en<='1';
    else
        en<='0';
    end if;
end process;  

--D1: Dff port map (D=>btn,en=>en,clk=>clk,Q=>q1); 
D1: process (clk,en)
begin
    if rising_edge(clk) then
        if en='1' then
            q1<=btn;
        end if;
    end if;
end process D1; 
--D2: Dff port map (D=>q1,en=>'1',clk=>clk,Q=>q2); 
D2: process (clk)
begin
    if rising_edge(clk) then
            q2<=q1;
    end if;
end process D2; 
--D3: Dff port map (D=>q2,en=>'1',clk=>clk,Q=>q3);
D3: process (clk)
begin
    if rising_edge(clk) then
            q3<=q2;
    end if;
end process D3; 

process (q2,q3)
begin
    if q2='1' and q3='0' then
        enable<='1';
    else
        enable<='0';
    end if;
end process;

end Behavioral;
