entity RstGen is
   generic( rst_level  : bit := '0';
            init_delay : time := 1 ns;
            T_rst    : time := 1 ns);
   port( rst : out bit );
end RstGen;

architecture dataflow of RstGen is
begin
   
rst <= not rst_level,
       rst_level after init_delay,
       not rst_level after init_delay + T_rst;

end dataflow;
