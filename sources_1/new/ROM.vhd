----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2019 09:57:10 AM
-- Design Name: 
-- Module Name: ROM - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM is
    Port ( MPG : in STD_LOGIC;
           clk : in std_logic;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0));
end ROM;

architecture Behavioral of ROM is

type arr_type is array (0 to 255) of std_logic_vector(15 downto 0);

signal r_name: arr_type := (
x"0000", -- M bits, use hexadecimal representation when possible
x"0001", --
x"0002",
x"0004",
x"0010",
others => x"0000"
);
signal count: integer:=0;
signal en: std_logic;
signal output: std_logic_vector(15 downto 0);

component debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
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

begin
monopulse: debouncer port map (btn=>MPG,clk=>clk,enable=>en);
counter: process(MPG)
begin
    if clk='1' and clk'event then
        if en='1' then
            count<=count+1;
        end if;
    end if;
end process counter;

output<=r_name(count);
led<=output;

sev: SevenSegmentDisplay port map(clk=>clk,cat=>cat,an=>an,Digit0=>output(3 downto 0),Digit1=>output(7 downto 4),Digit2=>output(11 downto 8),Digit3=>output(15 downto 12));

end Behavioral;
