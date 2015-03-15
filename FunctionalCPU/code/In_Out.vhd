use WORK.cpu_defs_pack.all; 
use STD.TEXTIO.all;
use WORK.trace_pack.all;

package In_Out is 
procedure Outi(variable f: out text; variable l: inout line; constant data:in data_type);
procedure INi(variable f: in text; variable l: inout line; variable data:out data_type);
end In_Out ;                  
                  
package body In_Out is 

procedure INi(variable f: in text; variable l: inout line; variable data:out data_type) is
   variable success : boolean;
   variable v       : data_type;
begin
       if (not endfile (f)) then
       	readline (f, l);
       	-- read values in each line
          read (l, v, success);
          if success then
            	data:=v;
          end if;
	end if;
end INi;


procedure Outi(variable f: out text; variable l: inout line; constant data:in data_type) is
begin
 
 write(l , data, left, 5);
  write(l , string'(" : Result in Hexadecimal #"));
 write( l , hex_image (data), left, 3);
 writeline(f, l);
end Outi;

end In_Out;