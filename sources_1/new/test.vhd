----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2019 03:58:50 PM
-- Design Name: 
-- Module Name: test - Behavioral
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

entity test is
    Port(sw : in std_logic_vector(7 downto 0);
        output: out std_logic_vector(7 downto 0);
        clk: in std_logic
    );
end test;

architecture Behavioral of test is

signal count: std_logic_vector(2 downto 0):="000";
begin

counter: process(sw,clk)
begin
    if clk='1' and clk'event then
        if sw(3 downto 0) = sw(7 downto 4) then
            count<=count+1;
        end if;
    end if;
end process counter;
    
mux: process(sw,count)
begin
    case count(2 downto 1) is
    when "00" => output<=sw(5 downto 0)&"00";
    when "01" => output<="00"&sw(7 downto 2);
    when "10" => output<=x"05";
    when others=> output<="00000"&count;
    end case; 
end process mux;

end Behavioral;
