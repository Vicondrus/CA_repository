----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 01:05:26 PM
-- Design Name: 
-- Module Name: Main - Behavioral
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

entity Main is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           sw : in std_logic_vector (7 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           cat: out std_logic_vector (6 downto 0);
           an: out std_logic_vector (3 downto 0));
end Main;

architecture Behavioral of Main is

component debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;


component decoder is
    Port ( a : in STD_LOGIC_VECTOR (2 downto 0);
           q : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component SevenSegmentDisplay is
    Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal mpg_enable: std_logic;
signal count: std_logic_vector(1 downto 0) := "00";
signal ext: std_logic_vector(15 downto 0);
signal aux1: std_logic_vector(15 downto 0):= x"000"&sw(3 downto 0);
signal aux2: std_logic_vector(15 downto 0):= x"000"&sw(7 downto 4);
signal aux3: std_logic_vector(15 downto 0):= x"00"&sw(7 downto 0);

begin
deb: debouncer port map (btn=>en,clk=>clk,enable=>mpg_enable);
counter: process(clk)
begin
    if clk='1' and clk'event then
        if mpg_enable='1' then
            count<=count+1;
        end if;
    end if;
end process counter;
alu: process(aux1, aux2, aux3, count)
begin
    case count is
    when "00" => ext<=aux1+aux2;
    when "01" => ext<=aux1-aux2;
    when "10" => ext(15 downto 0)<=aux3(13 downto 0)&"00";
    when others => ext(15 downto 0)<="00"&aux3(15 downto 2);
    end case;
end process alu;
sev: SevenSegmentDisplay port map (Digit0 => ext(3 downto 0), Digit1 => ext(7 downto 4), Digit2 => ext(11 downto 8), Digit3 => ext(15 downto 12), clk=> clk, cat=>cat, an=>an);

led(7)<='1' when ext=0 else '0';

end Behavioral;
