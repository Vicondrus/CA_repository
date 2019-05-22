library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity txFsm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           baudEn : in STD_LOGIC;
           txData : in STD_LOGIC_VECTOR(7 downto 0);
           txEn: in std_logic;
           txRdy : out STD_LOGIC;
           tx : out STD_LOGIC);
end txFsm;

architecture Behavioral of txFsm is

type state_type is (idle, start, bitt, stop);
signal state : state_type;
signal bit_cnt:std_logic_vector(2 downto 0);    
begin

process1:process (clk,rst,txEn)
begin
    if (rst ='1') then
           state <=idle;
    elsif (clk='1' and clk'event ) then
        if baudEn='1' then
        case state is
            when idle => if (txEn = '1') then
                            state <= start;
                             bit_cnt<="000";
                       else
                            state <= idle;
                       end if;
                      
            when start => state <= bitt; 
            
            when bitt =>  if (bit_cnt < "111") then
                                          state <= bitt;
                                          bit_cnt <= bit_cnt+1;
                                   else
                                          state <= stop;
                                   end if;
                                   
            when stop =>  state <= idle;     
        end case;
        end if;
    end if;
end process process1;

process2:process(state)
begin
    case state is
        when idle => tx<='1'; txRdy<='1';
        when start => tx<='0'; txRdy<='0';
        when bitt => tx<=txData(conv_integer(bit_cnt)); txRdy<='0';
        when stop => tx<='1'; txRdy<='0';
     
    end case;
end process process2;


end Behavioral;
