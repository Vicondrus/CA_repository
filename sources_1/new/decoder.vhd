----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 01:31:50 PM
-- Design Name: 
-- Module Name: decoder - Behavioral
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

entity decoder is
    Port ( a : in STD_LOGIC_VECTOR (2 downto 0);
           q : out STD_LOGIC_VECTOR (7 downto 0));
end decoder;

architecture Behavioral of decoder is

begin
    process (a)
    begin
        case a is
            when "000" => q<=x"01";
            when "001" => q<=x"02";
            when "010" => q<=x"04";
            when "011" => q<=x"08";
            when "100" => q<=x"10";
            when "101" => q<=x"20";
            when "110" => q<=x"40";
            when others => q<=x"80";
        end case;    
    end process;

end Behavioral;
