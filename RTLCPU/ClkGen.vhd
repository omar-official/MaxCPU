entity ClkGen is
 generic( init_value : bit := '1';
            init_delay : time := 1 ns;
            T_high     : time := 1 ns;
            T_low      : time := 1 ns;
            T_active   : time := 100 ns );
port( clk : buffer bit:=init_value;
ACTIVE: in bit:='0' );
end ClkGen;

architecture dataflow of ClkGen is

begin

 

clk <= not init_value, init_value after init_delay
          when now = 0 ns else
       '1' after T_low 
          when clk = '0' and now > 0 ns and now < T_active and active ='1' else
       '0' after T_high 
          when clk = '1' and now > 0 ns and now < T_active and active='1' else
       clk;


end dataflow;

