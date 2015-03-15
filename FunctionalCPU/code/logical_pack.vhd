--logical_pack
use WORK.cpu_defs_pack.all;

use WORK.bit_vector_natural_pack.all;

package logical_pack is
 function "NOT" (constant A : data_type)
  return data_type;
 
  function "AND" (constant A, B : data_type)
  return data_type;
 function "OR" (constant A,B : data_Type)
   return data_type;
   
  function "XOR" (constant A,B : data_Type)
   return data_type;

function EXEC_REA(constant A : in data_type) return data_type;

function EXEC_REO(constant A : in data_type) return data_type;

function EXEC_REX(constant A : in data_type) return data_type;

end logical_pack;

package body logical_pack is
-- NOT function
function "NOT" (constant A : data_type)
  return data_type is
 
  begin
    return WORK.bit_vector_natural_pack.bit_vector2natural(
    NOT WORK.bit_vector_natural_pack.natural2bit_vector
    (A, data_width) );
end "NOT";
--end NOT

-- AND function
function "AND" (constant A,B : data_type)
  return data_type is
  use WORK.bit_vector_natural_pack.all;
  
  begin
    return bit_vector2natural(natural2bit_vector(A, data_width) AND natural2bit_vector(B, data_width));
 end "AND";
--end AND
--Definition OR 
function "OR" (constant A,B : data_Type)
   return data_type is
   use WORK.bit_vector_natural_pack.all;
   begin
   return bit_vector2natural(
          natural2bit_vector( A , data_width )OR
          natural2bit_vector( B , data_width ) );
 end "OR";    
--end OR
 
 


--Definition XOR
function "XOR" (constant A,B : data_Type)
   return data_type is
   use WORK.bit_vector_natural_pack.all;
   begin
   return bit_vector2natural(
          natural2bit_vector( A , data_width ) XOR
          natural2bit_vector( B , data_width ) );
 end "XOR";    
--end XOR 

--REA function
 function EXEC_REA(constant A : in data_type) return data_type is
variable reg_x: bit_vector((addr_width-1) downto 0);
variable k:bit;
variable t :data_type;
variable i :natural;
begin
reg_x:=natural2bit_vector(A,addr_width);
k:='1';
for i in addr_width-1 downto 0 loop
k:=K and reg_x(i);
end loop;

if (K='1') then t:=1;
else t:=0;
end if;
return t;

end EXEC_REA;

--end REA



--REO function

function EXEC_REO(constant A : in data_type) return data_type is
variable reg_x: bit_vector((addr_width-1)downto 0); 
variable k:bit;
variable i:natural;
variable t :data_type;
begin
reg_x:=natural2bit_vector(A,addr_width);
k:='0';
for i in (addr_width-1)downto 0 loop
k:=K or reg_x(i);
end loop;
if (K='1') then t:=1;
else t:=0;
end if;
return t;
end EXEC_REO;
--end REO

--REX function

function EXEC_REX(constant A : in data_type) return data_type is
variable reg_x: bit_vector((addr_width-1) downto 0);
variable k:bit; 
variable i :natural;
variable t :data_type;
begin
reg_x:=natural2bit_vector(A,addr_width);
k:=reg_x(addr_width-1);
for i in (addr_width-2 )downto 0 loop
k:=K xor reg_x(i) ;
end loop ;
if (K='1') then t:=1;
else t:=0;
end if;
return t;

end EXEC_REX;
 --REX end
end logical_pack;
