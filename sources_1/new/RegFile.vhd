----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2019 10:32:18 AM
-- Design Name: 
-- Module Name: RegFile - Behavioral
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

entity RegFile is
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
end RegFile;
architecture Behavioral of RegFile is
type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (
x"00",
x"01",
x"02",
x"04",
x"01",
x"FFFF",
others => x"00"
);
begin
process(clk)
begin
if rising_edge(clk) then
if wen = '1' then
reg_file(conv_integer(wa)) <= wd;
end if;
end if;
end process;
rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));
end Behavioral; 
