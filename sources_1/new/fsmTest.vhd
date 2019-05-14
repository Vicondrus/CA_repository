----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2019 06:12:13 PM
-- Design Name: 
-- Module Name: fsmTest - Behavioral
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

entity fsmTest is
    Port ( clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           btn1 : in STD_LOGIC;
           btn2 : in STD_LOGIC;
           --txRdy: out std_logic;
           tx_out : out std_logic
           );
end fsmTest;


architecture Behavioral of fsmTest is

component debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component txFsm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           baudEn : in STD_LOGIC;
           txData : in STD_LOGIC_VECTOR(7 downto 0);
           txEn:in std_logic;
           txRdy : out STD_LOGIC;
           tx : out STD_LOGIC);
end component;

signal en, rst: std_logic;
signal baudEn, txEn: std_logic;
signal count: std_logic_vector(13 downto 0);

begin

deb1: debouncer port map (btn=>btn1,clk=>clk,enable=>en);
deb2: debouncer port map (btn=>btn2,clk=>clk,enable=>rst);

dff: process(clk, bauden, en)
begin
       if clk='1' and clk'event then
        if en='1' then 
            txEn<='1'; 
        end if;
        if bauden='1' then 
            txEn<='0';
        end if;
       end if;
end process dff;

 --baud rate generator pt transmisie 
process(clk)
begin
if clk='1' and clk'event then
    if count="10100010110000" --10416 tacti:28B0
       then bauden<='1';
            count<="00000000000000";
       else 
        bauden<='0';
        count<=count+1;
       end if;
end if;
end process;

fsm: txFsm port map (txData=>sw(7 downto 0),txEn=>txEn,rst=>'0',baudEn=>baudEn,clk=>clk,tx=>tx_out);

end Behavioral;
