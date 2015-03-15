use std.textio.all;
use WORK.cpu_defs_pack.all;

package file_in_memory is
procedure init_memory( variable f:in text;
variable mem :out mem_type);
end file_in_memory;
package body file_in_memory is

procedure init_memory(
variable f:in text;
variable mem:out mem_type) is 
variable l :line;
variable success: boolean;
variable v: data_type ;
variable i : addr_type:=0;
begin 
outest : loop --read line by line 
exit when endfile(f);
readline (f,l);
success:= true;
--read values in each line 

while success loop 
read(l,v,success);
if success then

mem(i):=v;

exit outest when i= 2**addr_width-1;
i:=i+1;
end if;
end loop;
end loop;
end init_memory;

 end file_in_memory;