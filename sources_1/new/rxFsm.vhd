----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/22/2019 06:38:45 PM
-- Design Name: 
-- Module Name: rxFsm - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rxFsm is
    Port ( rxRdy : out STD_LOGIC;
           rxData : out STD_LOGIC_VECTOR (7 downto 0);
           baudEn : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           rx : in STD_LOGIC);
end rxFsm;

architecture Behavioral of rxFsm is

type state_type is (idle, start, bitt, stop, waitt);
signal state: state_type;
signal bitCnt: std_logic_vector(2 downto 0):="000";
signal baudCnt: std_logic_vector(3 downto 0):="0000";

begin

process(clk, rst, rx)
begin
    if rst='1' then
    state<=idle;
    elsif clk='1' and clk'event then
        if baudEn='1' then
            case state is
            when idle => baudCnt<="0000";
                         bitCnt<="000";
                         if rx='0' then
                            state<=start;
                         end if;
            when start => if rx='1' then
                            state<=idle;
                          elsif rx='0' and baudCnt = "0111" then
                            state<=bitt;
                          elsif baudCnt < "0111" then
                            baudCnt<=baudCnt+1;
                            state<=start;
                          end if;
            when bitt => baudCnt <= baudCnt + 1;
                         if bitCnt<"111" and baudCnt="1111" then
                            rxData(conv_integer(bitCnt))<=rx;
                            bitCnt<=bitCnt+1;
                            baudCnt<="0000";
                            state<=bitt;
                         elsif bitCnt="111" and baudCnt="1111" then
                            state<=stop;
                            baudCnt<="0000";
                         end if;
            when stop => if baudCnt < "1111" then
                            baudCnt<=baudCnt+1;
                            state<=stop;
                         else
                            state<=waitt;
                            baudCnt<="0000";
                         end if;
            when waitt => if baudCnt < "0111" then
                            baudCnt<=baudCnt+1;
                            state<=waitt;
                          else
                            state<=idle;
                          end if;
            when others => state<=idle;
            end case; 
        end if;
    end if;
end process;

process(state)
begin
    case state is
    when idle => rxRdy<='0';
    when start => rxRdy<='0';
    when bitt => rxRdy<='0';
    when stop => rxRdy<='1';
    when waitt=> rxRdy<='1';
    end case;
end process;


end Behavioral;
