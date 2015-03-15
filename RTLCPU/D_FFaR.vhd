entity D_FFaR is -- FlipFlop with asynchronous reset
  port(   D  : in bit; 
          CLK: in bit;
          RST: in bit; 
          Enable : in bit;
          Q  : out bit );
end D_FFaR;

architecture RTL1 of D_FFaR is
begin
   process (CLK, RST)
  begin
      if RST = '0' then  Q <= '0' ;
      elsif CLK = '1'  and CLK'event then
      if ENABLE ='1' then  Q <= D;
    end if;
    end if;
 end process;
end RTL1;
