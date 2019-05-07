----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2019 10:37:46 AM
-- Design Name: 
-- Module Name: RegFileTest - Behavioral
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

entity RegFileTest is
    Port ( but1 : in STD_LOGIC;
           sw : in STD_LOGIC;
           an : out std_logic_vector(3 downto 0);
           cat : out std_logic_vector(6 downto 0);
           clk : in std_logic;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           res: in std_logic);
end RegFileTest;

architecture Behavioral of RegFileTest is

signal count: std_logic_vector(3 downto 0):=x"0";
signal rd1: std_logic_vector(15 downto 0);
signal rd2: std_logic_vector(15 downto 0);
signal en1: std_logic;
signal en2: std_logic;
signal en3: std_logic;
signal result: std_logic_vector(15 downto 0);

component RegFile is
port (
clk : in std_logic;
ra1 : in std_logic_vector (3 downto 0);
ra2 : in std_logic_vector (3 downto 0);
wa : in std_logic_vector (3 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
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

component debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

begin

demux: process(sw,en1)
begin
    case sw is
    when '0' => en2<=en1;
                en3<='0';
    when '1' => en2<='0';
                en3<=en1;
    end case;
end process demux;

counter: process(count)
begin
    if clk='1' and clk'event then
        if en2='1' then
            count<=count+1;
        end if;
        if res='1' then
            count<=x"0";
        end if;
    end if;
end process counter;

deb1: debouncer port map (btn=>but1,clk=>clk,enable=>en1);
--deb2: debouncer port map (btn=>but2,clk=>clk,enable=>en2);
reg: RegFile port map (clk=>clk,ra1=>count,ra2=>count,wa=>count,rd1=>rd1,rd2=>rd2,wen=>en3,wd=>result);
sev: SevenSegmentDisplay port map (clk=>clk,cat=>cat,an=>an,Digit0=>result(3 downto 0),Digit1=>result(7 downto 4),Digit2=>result(11 downto 8),Digit3=>result(15 downto 12));

result <= rd1+rd2;
led <= result;

end Behavioral;
