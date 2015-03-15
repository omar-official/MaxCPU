use std.textio.all;
use work.cpu_defs_pack.all;

package dump_memory_pack is 
  
  
procedure dump_memory(  variable Memory: in mem_type; variable DumpFile: out text);

end dump_memory_pack;
 
 
 package body dump_memory_pack is 
  procedure dump_memory(  variable Memory: in mem_type; variable DumpFile: out text) is

  variable v    : data_type;
  variable i    : addr_type := 0;
variable l:line;

 begin
  outest: loop 
     v := Memory(i);
     write(l,v);
    writeline(DumpFile, l);
     exit outest when
       i = 2**addr_width -1;
       i:=i+1;
   end loop;
     
end dump_memory;     
 end dump_memory_pack;
 
 