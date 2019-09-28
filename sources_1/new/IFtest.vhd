----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 06:23:21 PM
-- Design Name: 
-- Module Name: IFtest - Behavioral
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

entity IFtest is
    Port ( rx_in : in std_logic;
           tx_out : out std_logic;
           btn1 : in STD_LOGIC;
           clk: in std_logic;
           btn2 : in STD_LOGIC;
           btn3: in std_logic;
           btn4: in std_logic;
           led: out std_logic_vector (15 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end IFtest;

architecture Behavioral of IFtest is

component instructionFetch is
    Port ( clk : in STD_LOGIC;
            en: in std_logic;
            res: in std_logic;
           brncAdd : in STD_LOGIC_VECTOR (15 downto 0);
           jmpAdd : in STD_LOGIC_VECTOR (15 downto 0);
           jmp : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pcIncr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component memUnit is
    Port ( memWrite : in STD_LOGIC;
           clk : in std_logic;
           aluRes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           aluReso : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component controlUnit is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           WE : out STD_LOGIC;
           regSrc : out STD_LOGIC;
           aluSrc : out STD_LOGIC;
           beq : out STD_LOGIC;
           jmp : out STD_LOGIC;
           memReg : out STD_LOGIC;
           mWrite : out STD_LOGIC;
           aluOp : out STD_LOGIC_VECTOR (2 downto 0);
           blz: out std_logic;
           extOp : out STD_LOGIC);
end component;

component instructionDeocde is
    Port ( regWrite : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_vector (15 downto 0);
           clk : in STD_LOGIC;
           extImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           writeAdd: in std_logic_vector (2 downto 0);
           sa : out STD_LOGIC);
end component;

component rxFsm is
    Port ( rxRdy : out STD_LOGIC;
           rxData : out STD_LOGIC_VECTOR (7 downto 0);
           baudEn : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           rx : in STD_LOGIC);
end component;

component debouncer is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
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

component exUnit is
    Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           aluSrc : in STD_LOGIC;
           extImm : in STD_LOGIC_VECTOR (15 downto 0);
           pcIncr : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           aluOp : in STD_LOGIC_VECTOR (2 downto 0);
           brAddr : out STD_LOGIC_VECTOR (15 downto 0);
           zero : out STD_LOGIC;
           neg: out std_logic;
           aluRes : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component txFsm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           baudEn : in STD_LOGIC;
           txData : in STD_LOGIC_VECTOR(7 downto 0);
           txEn:in std_logic;
           txRdy : out STD_LOGIC;
           tx : out STD_LOGIC);
end component;

type alpha_rom is array (0 to 15) of std_logic_vector (7 downto 0);
signal alphaDecode: alpha_rom := (
x"30",
x"31",
x"32",
x"33",
x"34",
x"35",
x"36",
x"37",
x"38",
x"39",
x"41",
x"42",
x"43",
x"44",
x"45",
x"46"
);

signal decoded: std_logic_vector(7 downto 0);
signal compReceived: std_logic_vector(7 downto 0);
signal en: std_logic;
signal res: std_logic;
signal result: std_logic_vector(15 downto 0);
signal instr: std_logic_vector(15 downto 0);
signal pc: std_logic_vector(15 downto 0);
signal regWrite: std_logic;
signal regEn: std_logic;
signal WE: std_logic;
signal rd1: std_logic_vector(15 downto 0);
signal rd2: std_logic_vector(15 downto 0);
signal regSrc: std_logic;
signal aluSrc: std_logic;
signal beq: std_logic;
signal jmp: std_logic;
signal memReg: std_logic;
signal mWrite: std_logic;
signal extOp: std_logic;
signal aluOp: std_logic_vector(2 downto 0);
signal extImm: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal wd: std_logic_vector (15 downto 0);
signal blz: std_logic;
signal zero, neg: std_logic;
signal brncAdd: std_logic_vector(15 downto 0);
signal aluRes: std_logic_vector(15 downto 0);
signal dataOut: std_logic_vector(15 downto 0);
signal jmpAdd: std_logic_vector(15 downto 0);
signal pcSrc: std_logic;
signal memEn,memEnAux: std_logic;
signal aluReso: std_logic_vector(15 downto 0);
signal pc_id: std_logic_vector(15 downto 0);
signal instruction_id: std_logic_vector(15 downto 0);
signal rt_ex: std_logic_vector(2 downto 0);
signal rd_ex: std_logic_vector(2 downto 0);
signal func_ex: std_logic_vector(2 downto 0);
signal extImm_ex: std_logic_vector(15 downto 0);
signal rd1_ex: std_logic_vector(15 downto 0);
signal rd2_ex: std_logic_vector(15 downto 0);
signal pc_ex: std_logic_vector(15 downto 0);
signal ex_ex: std_logic_vector(4 downto 0);
signal m_ex: std_logic_vector(2 downto 0);
signal wb_ex: std_logic_vector(1 downto 0);
signal wAdd_mem: std_logic_vector(2 downto 0);
signal rd2_mem: std_logic_vector(15 downto 0);
signal aluRes_mem: std_logic_vector(15 downto 0);
signal brncAddr_mem: std_logic_vector(15 downto 0);
signal zero_mem: std_logic;
signal neg_mem: std_logic;
signal sa_ex: std_logic;
signal m_mem: std_logic_vector(2 downto 0);
signal wb_mem: std_logic_vector(1 downto 0);
signal wAddr: std_logic_vector(2 downto 0);
signal wAdd_wb: std_logic_vector(2 downto 0);
signal aluRes_wb: std_logic_vector(15 downto 0);
signal readData_wb: std_logic_vector(15 downto 0);
signal wb_wb: std_logic_vector(1 downto 0);

signal baudEn, txEn: std_logic;
signal count: std_logic_vector(13 downto 0);
signal txTransEn, txRdy: std_logic := '0';
signal startAux: std_logic;
signal txReg: std_logic_vector(15 downto 0);
signal txWrite: std_logic_vector(7 downto 0);
signal txAux: std_logic_vector (2 downto 0);
signal rstAux: std_logic;

signal counter: std_logic_vector(9 downto 0);
signal baudEnRx, rxRdy: std_logic;
signal q: std_logic_vector(2 downto 0);
signal rxReg: std_logic_vector(15 downto 0);

begin

fsm: txFsm port map (txData=>txWrite,txEn=>txEn,rst=>'0',baudEn=>baudEn,clk=>clk,tx=>tx_out, txRdy=>txRdy);

--process(clk,en)
--begin
--    if clk = '1' and clk'event
--    then
--       if en = '1' then
--            txWrite<=alphaDecode(conv_integer(pc(3 downto 0)));
--       end if;
--    end if;
--end process;

decodeAscii: process(compReceived)
begin
    if compReceived >= 48 and compReceived <= 57 then
        decoded<=compReceived-48;
    elsif compReceived >=65 and compReceived <= 70 then
        decoded<=compReceived-65+10;
    end if;
end process decodeAscii;

process(clk)
begin
if clk='1' and clk'event then
    counter <= counter+1;
    if counter = "1010001011" then
        counter<="0000000000";
        baudEnRx<='1';
    else
        baudEnRx<='0';
    end if;
end if;
end process;

fsmRx: rxFsm port map (rxRdy=>rxRdy,rxData=>compReceived,baudEn=>baudEnRx,rst=>'0',clk=>clk,rx=>rx_in);

process(rxRdy,rx_in)
begin
    if rxRdy='1' then
       -- if rx_in='1' then
            rxReg(conv_integer(q)*4 + 3 downto conv_integer(q)*4)<=decoded(3 downto 0);
            q<=q+1;
            if q="100" then
                q<="000";
        --    end if;
        end if;
    end if;
end process;

process(clk,en)
begin
    if clk = '1' and clk'event
    then
       if en = '1' then
            txReg<=instr;
            startAux<='1';
       else
           startAux<='0';
       end if;
    end if;
end process;

process(txRdy, startAux)
begin
    
    if startAux = '1' then
        led(13)<='1';
        if txRdy='1' then
            if txAux < 4 then
                led(11)<='1';
                txWrite<=alphaDecode(conv_integer(txReg((conv_integer(txAux)*4 + 3) downto conv_integer(txAux)*4)));
                txAux <= txAux+1;
                txTransEn <= '1';
            else
                led(11)<='0';
                txTransEn <= '0';
                --startAux<='0';
                txAux<="000";
            end if;
        end if;
    else
        led(13)<='0';
    end if;
end process;

dff: process(clk, bauden, txTransEn)
begin
       if clk='1' and clk'event then
        if txTransEn='1' then 
            led(12)<='1';
            txEn<='1'; 
        else
            led(12)<='0';
        end if;
        if bauden='1' then 
            txEn<='0';
        end if;
       end if;
end process dff;

process(clk)
begin
if clk='1' and clk'event then
    if count="10100010110000" then 
        bauden<='1';
            count<="00000000000000";
       else 
        bauden<='0';
        count<=count+1;
       end if;
end if;
end process;

id_reg: process(clk)
begin
    if clk='1' and clk'event then
        if en ='1' then
            pc_id<=pc;
            instruction_id<=instr;
        end if;
    end if;
end process id_reg;

ex_reg: process(clk)
begin
    if clk='1' and clk'event then
        if en ='1' then
            pc_ex<=pc_id;
            rt_ex<=instruction_id(9 downto 7);
            rd_ex<=instruction_id(6 downto 4);
            func_ex<=func;
            extImm_ex<=extImm;
            rd1_ex<=rd1;
            rd2_ex<=rd2;
            sa_ex<=sa;
            ex_ex(2 downto 0)<=aluOp;
            ex_ex(3)<=aluSrc;
            ex_ex(4)<=regSrc;
            m_ex(0)<=mWrite;
            m_ex(1)<=beq;
            m_ex(2)<=blz;
            wb_ex(0)<=WE;
            wb_ex(1)<=memReg;
        end if;
    end if;
end process ex_reg;

mem_reg: process(clk)
begin
    if clk='1' and clk'event then
        if en ='1' then
            m_mem<=m_ex;
            wb_mem<=wb_ex;
            zero_mem<=zero;
            neg_mem<=neg;
            aluRes_mem<=aluRes;
            brncAddr_mem<=brncAdd;
            rd2_mem<=rd2_ex;
            wAdd_mem<=wAddr;
        end if;
    end if;
end process mem_reg;

wb_reg: process(clk)
begin
    if clk='1' and clk'event then
        if en ='1' then
            wb_wb<=wb_mem;
            aluRes_wb<=aluReso;
            readData_wb<=dataOut;
            wAdd_wb<=wAdd_mem;
        end if;
    end if;
end process wb_reg;

process (sw(0),WE,memReg,mWrite,aluOp,jmp,beq,blz,aluSrc,extOp,regSrc,zero,neg)
begin
    if sw(0)='1' then
        led(0)<= WE;
        led(1)<=memReg;
        led(2)<=mWrite;
        led(3)<=jmp;
        led(4)<=beq;
        led(5)<=aluSrc;
        led(6)<=extOp;
        led(7)<=regSrc;
        led(8)<=blz;
        led(9)<=zero;
        led(10)<=neg;
        led(15)<=wb_wb(0);
        led(14)<=txRdy;
    else
        led(2 downto 0)<=aluOp;
        led(3)<='0';
        led(4)<='0';
        led(5)<='0';
        led(6)<='0';
        led(7)<='0';
        led(8)<='0';
        led(9)<='0';
        led(10)<='0';
        led(15)<='0';
        led(14)<='0';
    end if;
end process;

deb1: debouncer port map (btn=>btn1,clk=>clk,enable=>en);
deb2: debouncer port map (btn=>btn2,clk=>clk,enable=>res);
deb3: debouncer port map (btn=>btn3,clk=>clk);
deb4: debouncer port map (btn=>btn4,clk=>clk,enable=>memEn);
ifu: instructionFetch port map (clk=>clk,en=>en,res=>res,brncAdd=>brncAddr_mem,jmpAdd=>jmpAdd,jmp=>jmp,PCSrc=>pcSrc,instruction=>instr,pcIncr=>pc);
idu: instructionDeocde port map (writeAdd=>wAdd_wb,regWrite=>wb_wb(0),instr=>instruction_id,regDst=>regSrc,extOp=>extOp,rd1=>rd1,rd2=>rd2,wd=>wd,clk=>clk,extImm=>extImm,func=>func,sa=>sa);

control: controlUnit port map (instr=>instruction_id(15 downto 13),regSrc=>regSrc,beq=>beq,mWrite=>mWrite,memReg=>memReg,extOp=>extOp,aluOp=>aluOp,jmp=>jmp,WE=>WE,aluSrc=>aluSrc,blz=>blz);

pcSrc<=(m_mem(1) and zero_mem) or (m_mem(2) and neg_mem);
jmpAdd<=pc_id(15 downto 13) & instruction_id(12 downto 0);

alu: exUnit port map (rd1=>rd1_ex,rd2=>rd2_ex,aluRes=>aluRes,sa=>sa_ex,aluSrc=>ex_ex(3),aluOp=>ex_ex(2 downto 0),func=>func_ex,pcIncr=>pc_ex,zero=>zero,neg=>neg,extImm=>extImm_ex,brAddr=>brncAdd);

memEnAux<=m_mem(0);

mem: memUnit port map (memWrite=>memEnAux,clk=>clk,aluRes=>aluRes_mem,rd2=>rd2_mem,memData=>dataOut,aluReso=>aluReso);

regWrite<=WE;

wAddr<=rt_ex when ex_ex(4)='0' else rd_ex;
wd<=readData_wb when wb_wb(1)='1' else aluRes_wb;

process (sw(7 downto 5),instr,pc,rd1,rd2,wd)
begin
    case sw(7 downto 5) is
    when "000" => result<=instr;
    when "001" => result<=pc;
    when "010" => result<=rxReg;
    when "011" => result<="0000000000000"&wAdd_wb;
    when "100" => result<=extImm;
    when "101" => result<=aluRes_wb;
    when "110" => result<=readData_wb;
    when others => result<=wd;
    end case;
end process;

sev: SevenSegmentDisplay port map (clk=>clk,cat=>cat,an=>an,Digit0=>result(3 downto 0),Digit1=>result(7 downto 4),Digit2=>result(11 downto 8),Digit3=>result(15 downto 12));

end Behavioral;
