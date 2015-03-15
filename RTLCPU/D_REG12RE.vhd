entity D_REG12RE is 
port (
D_IN : in bit_vector(11 downto 0);
RST : in bit;
Enable : in bit;
clk : in bit;
Q_out : out bit_vector (11 downto 0) );
end D_REG12RE;
architecture RTL of D_REG12RE  is
begin 
process (RST,CLK)
begin 
if RST='0' then Q_out<=B"0000_0000_0000";
elsif CLK ='1' and CLK'event then 
if ENABLE ='1' then Q_out <= D_IN;
end if;
end if;
end process ; 
end RTL;
