----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/22/2019 07:31:36 PM
-- Design Name: 
-- Module Name: fsmTestRx - Behavioral
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

entity fsmTestRx is
    Port ( clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           rx_in : in STD_LOGIC);
end fsmTestRx;

architecture Behavioral of fsmTestRx is

component rxFsm is
    Port ( rxRdy : out STD_LOGIC;
           rxData : out STD_LOGIC_VECTOR (7 downto 0);
           baudEn : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           rx : in STD_LOGIC);
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

signal counter: std_logic_vector(9 downto 0);
signal baudEn: std_logic;
signal rxData: std_logic_vector(7 downto 0);
signal rxRdy: std_logic;

begin

fsm: rxFsm port map (rxRdy=>rxRdy,rxData=>rxData,baudEn=>baudEn,rst=>'0',clk=>clk,rx=>rx_in);
sev: SevenSegmentDisplay port map (Digit0=>rxData(3 downto 0),Digit1=>rxData(7 downto 4),Digit2=>"0000",Digit3=>"0000",clk=>clk,cat=>cat,an=>an);

process(clk)
begin
if clk='1' and clk'event then
    counter <= counter+1;
    if counter = "1010001011" then
        counter<="0000000000";
        baudEn<='1';
    else
        baudEn<='0';
    end if;
end if;
end process;

end Behavioral;
