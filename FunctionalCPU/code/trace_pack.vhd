use WORK.cpu_defs_pack.all;
use std.textio.all;

package trace_pack  is
procedure print_header(variable f : out text );

procedure print_tail(variable f : out text );

procedure write_PC_CMD(variable l: inout line;
constant PC: in data_type;
constant OP: in opcode_type;
constant X,Y,Z : in reg_addr_type);

procedure write_param(variable l: inout line;
constant param: in data_type);
procedure no_param(variable l: inout line);

procedure write_regs(variable l: inout line;
constant Reg: in reg_type;
constant Zero,Carry,Negative, Overflow : in Boolean );

function bool_character(b : Boolean) return character;
function hex_image( d : data_type ) return string;
function cmd_image( cmd : opcode_type ) return string;
end trace_pack;


package body trace_pack is
--- print header
procedure print_header(variable f : out text ) is
variable  l:line;
begin 
write( l, string'(
"PC   | Cmd  | XYZ | P    | R0   | R1   | R2   | R3   | ZCNO"));     
writeline(f, l);                      
write( l, string'(
"-----------------------------------------------------------"));
writeline(f, l);
end print_header;

--- print_tail
procedure print_tail(variable f : out text ) is
variable  l:line;
begin 
write( l, string'(
"----------------------------------------------------------"));
writeline(f, l);
end print_tail;

---write_pc_cmd
procedure write_PC_CMD(variable l: inout line;
constant PC: in data_type;
constant OP: in opcode_type;
constant X,Y,Z : in reg_addr_type) is
begin 
write(l, hex_image(PC), left, 4);
write(l, string'(" | "));
write(l, cmd_image(OP), left, 4);
write(l, string'(" | "));
write(l, X, left, 1);
write(l, Y, left, 1);
write(l, Z, left, 1);
write(l, string'(" | "));
end write_PC_CMD;

--- write_param
procedure write_param(variable l: inout line;
constant param: in data_type
) is
begin 
write(l, param, left, 5);
write(l, string'("| "));
end write_param;
---write no_param
procedure no_param(variable l: inout line
) is
begin 
write(l, string'("---- | "));
end no_param;

---write_regs
procedure write_regs(variable l: inout line;
constant Reg: in reg_type;
constant Zero,Carry,Negative, Overflow : in Boolean ) is
begin 
---
write(l,Reg(0), left, 4);
write(l, string'(" | "));
write(l,Reg(1), left, 4);
write(l, string'(" | "));
write(l,Reg(2), left, 4);
write(l, string'(" | "));
write(l,Reg(3), left, 4);
write(l, string'(" | "));

---
write(l, bool_character(Zero), left, 1);
write(l, bool_character(Carry), left, 1);
write(l, bool_character(Negative), left, 1);
write(l, bool_character(Overflow), left, 1);


end write_regs;

--- bool_character
function bool_character(b : Boolean) return character is
begin
if b then return 'T';
else return 'F';
end if;
end bool_character;

---hex_image
function hex_image( d : data_type )
   return string is
   constant hex_table : string(1 to 16):=
      "0123456789ABCDEF";
   variable result : string( 1 to 3 );
begin
   result(3):=hex_table(d mod 16 + 1);
   result(2):=hex_table((d / 16) mod 16 + 1);
   result(1):=hex_table(d / 256 + 1);
   return result;
end hex_image;
---cmd_image
function cmd_image( cmd : opcode_type )
   return string is
begin
   case cmd is
   when code_nop => return mnemonic_nop;
   when code_stop => return mnemonic_stop;
   when code_add =>  return mnemonic_add ;
   
  when code_addc =>  return mnemonic_addc ;
  
  when code_sub =>  return mnemonic_sub ;
    
  when code_subc =>  return mnemonic_subc ;
    
  when code_not =>  return mnemonic_not ;
    
  when code_and =>  return  mnemonic_and ;
      
  when code_or =>  return mnemonic_or ;
     
  when code_xor =>  return mnemonic_xor ;
      
  when code_rea =>  return mnemonic_rea ;
     
  when code_reo =>  return mnemonic_reo ;
      
  when code_rex =>  return mnemonic_rex ;
      
  when code_sll =>  return mnemonic_sll ;
     
  when code_srl =>  return mnemonic_srl ;
     
  when code_sra =>  return mnemonic_sra ;
    
  when code_rol =>  return mnemonic_rol ;
    
  when code_rolc =>  return mnemonic_rolc ;
   
  when code_ror =>  return mnemonic_ror ;
   
  when code_rorc =>  return mnemonic_rorc ;
   
  when code_ldc =>  return mnemonic_ldc ;
   
  when code_ldd =>  return mnemonic_ldd ;
  
  when code_ldr =>  return mnemonic_ldr ;
  
  when code_std =>  return mnemonic_std ;
  
  when code_str =>  return mnemonic_str ;
  
  when code_in =>  return mnemonic_in ;
  
  when code_out =>  return mnemonic_out ;

  when code_jmp =>  return mnemonic_jmp ;

  when code_jz =>  return mnemonic_jz ;
                            
  when code_jc =>  return mnemonic_jc ;                            
         
  when code_jn  =>  return mnemonic_jn ;
                            
  when code_jo =>  return mnemonic_jo ;
                                                        
  when code_jnz =>  return mnemonic_jnz ;                        
                            
  when code_jnc =>  return mnemonic_jnc ;
                          
  when code_jnn =>  return mnemonic_jnn ;
                            
   when code_jno =>  return mnemonic_jno ;

   when others =>
      assert FALSE
      report "Illegal command in cmd_image"
      severity warning;  
      return "";
   end case;
end cmd_image;



end trace_pack;
