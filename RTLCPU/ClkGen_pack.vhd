package ClkGen_pack is
   component ClkGen 
   generic( init_value : bit := '1';
            init_delay : time := 1 ns;
            T_high     : time := 1 ns;
            T_low      : time := 1 ns;
            T_active   : time := 100 ns );
   port( clk : buffer bit:=init_value );
   end component;
end ClkGen_pack;

