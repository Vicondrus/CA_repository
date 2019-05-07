----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2019 03:51:34 PM
-- Design Name: 
-- Module Name: memUnit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memUnit is
    Port ( memWrite : in STD_LOGIC;
           clk : in std_logic;
           aluRes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           aluReso : out STD_LOGIC_VECTOR (15 downto 0));
end memUnit;

architecture Behavioral of memUnit is

component RAM is
 port ( clk : in std_logic;
 we : in std_logic;
 en : in std_logic;
 addr : in std_logic_vector(7 downto 0);
 di : in std_logic_vector(15 downto 0);
 do : out std_logic_vector(15 downto 0));
end component;

begin

aluReso<=aluRes;
ram1: RAM port map (clk=>clk, we=>memWrite,en=>'1',addr=>aluRes(7 downto 0),di=>rd2,do=>memData);

end Behavioral;
