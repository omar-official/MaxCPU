--Omar
package bit_vector_natural_pack is

subtype index_type is positive range 1 to 31;


function bit_vector2natural 
( bv : bit_vector ) return natural;

function natural2bit_vector
(nat : natural;
size : index_type ) return bit_vector;

end bit_vector_natural_pack;

package body bit_vector_natural_pack is

function bit_vector2natural 
( bv : bit_vector ) return natural is

variable result : natural :=0;
begin 
assert bv'left  >= 0 AND bv'left < 31;
assert bv'right = 0;
for i in bv'left downto 0 loop
result := result*2 + bit'pos(bv(i));
end loop;
return result;

end bit_vector2natural;

function natural2bit_vector
(nat : natural;
size : index_type ) return bit_vector is
variable tmp : natural := nat;
variable result : bit_vector(
                                size - 1 downto 0 );

begin 
  for i in 0 to size-1 loop
result(i) := bit'val(tmp mod 2);
tmp := tmp / 2;

end loop;
assert tmp =0;
return result ;
end natural2bit_vector;
end bit_vector_natural_pack;

