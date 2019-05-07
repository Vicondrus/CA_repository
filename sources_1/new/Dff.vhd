----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 12:49:08 PM
-- Design Name: 
-- Module Name: Dff - Behavioral
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

entity Dff is
    Port ( D : in STD_LOGIC;
           en : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC);
end Dff;

architecture Behavioral of Dff is

begin
process (clk,en)
begin
    if rising_edge(clk) then
        if en='1' then
            Q<=D;
        end if;
    end if;
end process;
        

end Behavioral;
