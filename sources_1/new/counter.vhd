----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 12:12:52 PM
-- Design Name: 
-- Module Name: counter - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( clk : in STD_LOGIC;
          en: in STD_LOGIC;
          rst: in STD_LOGIC;
          dir: in STD_LOGIC;
          led: out STD_LOGIC_VECTOR(15 downto 0));
end counter;

architecture Behavioral of counter is

begin

count: process(clk,en,rst)
variable number: std_logic_vector(15 downto 0) := x"0000";
begin
    if rst='1' then
        number:=x"0000";
    elsif rising_edge(clk) then
        if en='1' then
            if dir='0' then
                number:=number+1;
            else
                number:=number-1;
            end if;
        end if;
    end if;
    led<=number;
end process count;


end Behavioral;
