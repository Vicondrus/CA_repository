----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2019 04:24:34 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
 port ( clk : in std_logic;
 we : in std_logic;
 en : in std_logic;
 addr : in std_logic_vector(7 downto 0);
 di : in std_logic_vector(15 downto 0);
 do : out std_logic_vector(15 downto 0));
end RAM;
architecture syn of RAM is
 type ram_type is array (0 to 255) of std_logic_vector (15 downto 0);
 signal RAM: ram_type := (
 x"00AA",
 x"00BB",
 x"00CC",
 x"00DD",
 others=>x"FFFF");
begin
 process (clk)
 begin
 if clk'event and clk = '1' then
 if en = '1' then
 if we = '1' then
 RAM(conv_integer(addr)) <= di;
 do <= di;
 else
 do <= RAM( conv_integer(addr));
 end if;
 end if;
 end if;
 end process;
end syn;