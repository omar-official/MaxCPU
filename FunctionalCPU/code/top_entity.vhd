use WORK.cpu_defs_pack.all;
use WORK.mem_defs_pack.all;
use WORK.bit_vector_natural_pack.all;
use WORK.arith_defs_pack.all;
use WORK.logical_pack.all;
use WORK.shift_rotate_pack.all;
use WORK.mem_access_pack.all;
use WORK.trace_pack.all;
use WORK.In_Out.all;
use WORK.file_in_memory.all;
use WORK.dump_memory_pack.all;
use WORK.jump_defs_pack.all;

entity CPU is 
end CPU;
architecture functional of CPU is

begin
  process
  use std.textio.all;
  ----
  file TraceFile 	: Text is out "C:\Modeltech_pe_edu_10.3c\examples\test\Project-2\CPU-Project\CPU\Trace.txt";
  file DumpFile 	: Text is out "C:\Modeltech_pe_edu_10.3c\examples\test\Project-2\CPU-Project\CPU\Dump.txt";
  file  MemoryFile 	: text is in  "C:\Modeltech_pe_edu_10.3c\examples\test\Project-2\CPU-Project\CPU\Memory.txt";
  file IOInputFile	: text is in  "C:\Modeltech_pe_edu_10.3c\examples\test\Project-2\CPU-Project\CPU\Input.txt";
  file IOOutputFile 	: text is out "C:\Modeltech_pe_edu_10.3c\examples\test\Project-2\CPU-Project\CPU\Output.txt";
  variable l, l_read, l_write : line;
  ----
variable Data : data_type;
variable zero,Carry,Negative,Overflow : boolean; 
variable Memory: mem_type :=
(0    => code_nop*(2**reg_addr_width)**3,
1     => code_stop*(2**reg_addr_width)**3,
others => 0);
variable Reg : reg_type;
variable instr : data_type;
variable OP : opcode_type;
variable X,Y,Z : reg_addr_type;
variable PC : addr_type := 0;
variable var : integer:=0;
use WORK.cpu_defs_pack.all;
  begin
  ----
init_memory(MemoryFile, Memory);
  print_header(TraceFile);
 ---
loop
 ----
    var:=var+1;
    Instr:=Memory(pc); 
    op:=Instr/(2**reg_addr_width)**3;
    X:=(Instr/(2**reg_addr_width)**2)mod 2**reg_addr_width;
    Y:=(Instr/2**reg_addr_width)mod 2**reg_addr_width;
    Z:=Instr mod 2**reg_addr_width; 
	----
	write_PC_CMD(l, PC, OP, X, Y, Z);
	PC:=INC(PC);
	----
    case op is
    when code_nop=> null;
	--- 
	NO_Param(l);
	---
    when code_stop=>
	NO_Param(l);
	write_regs(l, Reg, Zero, Carry, Negative, Overflow);
	writeline(TraceFile, l);
	print_tail(TraceFile);
        dump_memory(Memory, DumpFile);
	exit;
    when code_add=>EXEC_ADDC(Reg(Y),Reg(Z),FALSE,Reg(X),zero,Carry,Negative,Overflow);NO_Param(l);
    when code_addc=>EXEC_ADDC(Reg(Y),Reg(Z),Carry,Reg(X),Zero,Carry,Negative,overflow);NO_Param(l);
    when code_sub=>EXEC_SUBC(Reg(Y),Reg(Z),FALSE,Reg(X),zero,Carry,Negative,Overflow);NO_Param(l);
    when code_subc=>EXEC_SUBC(Reg(Y),Reg(Z),Carry,Reg(X),Zero,Carry,Negative,overflow);NO_Param(l);
     
    When code_not=>Data:="NOT"(Reg(Y));Reg(X):=Data;NO_Param(l);    
    When code_and=>Data:=Reg(Y) AND Reg(Z); Reg(X):= Data;NO_Param(l);  
    when code_or => Data:=Reg(Y)OR Reg(Z); Reg(X):=Data;NO_Param(l);
    When code_xor => Data:=Reg(Y)XOR Reg(Z); Reg(X):=Data;NO_Param(l);
    when code_rea=>Reg(X):=EXEC_REA(Reg(Y));NO_Param(l);
    when code_reo=>Reg(X):=EXEC_REO(Reg(Y)); NO_Param(l);
    when code_rex=> Reg(X):=EXEC_REX(Reg(Y));NO_Param(l);

   when code_sll=>EXEC_SLL(Reg(Y),Reg(X),Zero,Carry,Negative,Overflow);NO_Param(l);   
   when code_srl=>EXEC_SRL(Reg(Y),Reg(X),Zero,Carry,Negative,Overflow);NO_Param(l);   
   When code_sra=> EXEC_SRA(Reg(Y),Reg(X),Carry,Zero,Carry,Negative,Overflow);NO_Param(l);    
   when code_rol=>EXEC_Rol(Reg(Y),Reg(X),Zero,Carry,Negative,Overflow);NO_Param(l);    
   when code_rolc=>EXEC_ROLC(Reg(Y),Reg(X),Carry,Zero,Carry,Negative,Overflow);NO_Param(l);   
   when code_ror=>EXEC_ROR(Reg(Y),Reg(X),Zero,Carry,Negative,Overflow);NO_Param(l);   
   when code_rorc=> EXEC_RORC(Reg(Y),Reg(X),Carry,Zero,Negative,Overflow);NO_Param(l);
   
  when code_ldc=>write_Param(l,Memory(PC));EXEC_ldc(memory,Reg(X),PC,zero,Negative,Overflow);
  when code_ldd=> write_Param(l,Memory(Memory(PC)));EXEC_ldd(memory,Reg(X),PC,zero,Negative,Overflow);
  when code_ldr=>write_Param(l,Memory(Reg(Y)));EXEC_ldr(memory,Reg(Y),Reg(X),zero,Negative,Overflow);
  when code_std=> write_Param(l,Memory(Memory(PC)));EXEC_std( memory,Reg(X), PC);
  when code_str=> write_Param(l,Memory(Reg(Y)));EXEC_str( memory,Reg(Y), Reg(X));

  when code_in => INi(IOInputFile, l_read, Reg(X));write_Param(l,Reg(X));
  when code_out => OUTi(IOOutputFile, l_write, Reg(X));write_Param(l,Reg(X));

when code_jmp => PC:=Memory(PC);
when code_jz=> if zero then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);
when code_jnz=> if not zero then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);
when code_jc=> if carry then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);
when code_jnc=> if carry= False then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);
when code_jn => if negative    then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);
when code_jnn => if negative =False then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);
when code_jo=> if overflow then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);
when code_jno=> if overflow = False then PC:=Memory(PC);
                            else    PC:=INC(PC); end if;NO_Param(l);

when others => 
assert FALSE
report "Illegeal Operation"
severity error;
end case;
---
write_regs(l, Reg, Zero, Carry, Negative, Overflow);
writeline(TraceFile, l);
end loop;
wait;
end Process;
end functional;
----------------------------------------------------------------












 	
