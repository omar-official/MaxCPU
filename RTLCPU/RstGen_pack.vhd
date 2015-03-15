package RstGen_pack is
   component RstGen
   generic( rst_level  : bit := '0';
            init_delay : time := 1 ns;
            T_rst    : time := 1 ns);
   port( rst : out bit ); 
   end component;
end RstGen_pack;

