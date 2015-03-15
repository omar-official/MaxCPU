


use WORK.cpu_defs_pack.all;
use WORK.mem_defs_pack.all;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- The package mem_access_pack declares procedures for loading and storing data in the memory block
--  i) procedure EXEC_ldc loads the data from the memory block addressed by PC and saves the data to Reg(X)
-- ii) procedure EXEC_ldd loads the data from the memory block addressed by memory(PC) and saves the data to Reg(X)
--iii) procedure EXEC_ldr loads the data from the memory block addressed by Reg(Y) and saves the data to Reg(X)
-- iv) procedure EXEC_std stores the content of Reg(X) in the memory block addressed by memory(PC)
--  v) procedure EXEC_str stores the content of Reg(X) in the memory block addressed by Reg(Y)
-- in i), ii) and iv) PC is incremented by 1
-- packages "cpu_defs_pack" & "mem_def_pack" are needed for compilation
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


package mem_access_pack is
  -- declaration EXEC_ldc
  procedure EXEC_ldc(constant memory: in mem_type;
		variable Reg_X: out data_type;
		variable PC: inout addr_type;
		variable Z, N, O: out Boolean);
  -- declaration EXEC_ldd
  procedure EXEC_ldd(constant memory: in mem_type;
		variable Reg_X: out data_type;
		variable PC: inout addr_type;
		variable Z, N, O: out Boolean);
  -- declaration EXEC_ldr
  procedure EXEC_ldr(constant memory: in mem_type;
	        constant Reg_Y: in data_type;
		variable Reg_X: out data_type;
		variable Z, N, O: out Boolean);

  -- declaration EXEC_std
  procedure EXEC_std(variable memory: inout mem_type;
		variable Reg_X: in data_type;
		variable PC: inout addr_type);
  -- declaration EXEC_str
  procedure EXEC_str(variable memory: out mem_type;
		constant Reg_Y, Reg_X: in data_type);
end mem_access_pack;


package body mem_access_pack is
   -- Defintion ldc
   procedure EXEC_ldc(constant memory: in mem_type;
		variable Reg_X: out data_type;
		variable PC: inout addr_type;
		variable Z, N, O: out Boolean) is

  variable data_var: data_type:=0;  
   variable data_int:integer:=0;	
  begin
	data_var := memory(PC); -- take content from memory(PC)
 	Reg_X := data_var; -- store it in Reg(X)
	PC:=INC(PC); -- increment PC by 1
	if data_var >= 2**(data_width-1) then
 		data_int:= data_var -2**(data_width);
	end if;
	if data_int<0 then
		 N:=TRUE; 
	end if;
	if data_var=0 then 
		Z:=TRUE; 
	end if;
	O:=FALSE;
  end EXEC_ldc;
  -- end ldc

  -- Defintion ldd
  procedure EXEC_ldd(constant memory: in mem_type;
	        variable Reg_X: out data_type;
		variable PC: inout addr_type;
		variable Z, N, O: out Boolean) is
  variable address: data_type:=0;
  variable data_var: data_type:=0;
  variable data_int:integer:=0;	
  begin
	address := memory(PC); -- address is the value in memory(PC)
	data_var := memory(address); -- take content from memory(address)
	Reg_X := data_var;  -- store it in Reg(X)
	PC:=INC(PC); -- increment PC by 1
	if data_var >= 2**(data_width-1) then
 		data_int:= data_var -2**(data_width);
	end if;
	if data_int<0 then
		 N:=TRUE; 
	end if;
	if data_var=0 then 
		Z:=TRUE; 
	end if;
	O:=FALSE;
  end EXEC_ldd;
  -- end ldd

  -- Defintion ldr
  procedure EXEC_ldr(constant memory: in mem_type;
	        constant Reg_Y: in data_type;
		variable Reg_X: out data_type;
		variable Z, N, O: out Boolean) is
  variable address: data_type:=0;
  variable data_var: data_type:=0;
   variable data_int:integer:=0;	
begin
	address := Reg_Y; -- address is the value in Reg(Y)
	data_var := memory(address); -- take content from memory(address)
	Reg_X := data_var;  -- store it in Reg(X)
	if data_var >= 2**(data_width-1) then
 		data_int:= data_var -2**(data_width);
	end if;
	if data_int<0 then
		 N:=TRUE; 
	end if;
	if data_var=0 then 
		Z:=TRUE; 
	end if;
	O:=FALSE;
  end EXEC_ldr;
  -- end ldr

  -- std
  procedure EXEC_std(variable memory: inout mem_type;
		variable Reg_X: in data_type;
		variable PC: inout addr_type) is

  variable address:data_type:=0; 
  begin
  	address:=memory(PC); -- address is the value in memory(PC)
	memory(address):=Reg_X; -- assign content of Reg(X) in memory indexed by address
	PC:=INC(PC); -- increment PC by 1
  end EXEC_std;
  -- end std

  -- Defintion str
  procedure EXEC_str(variable memory: out mem_type;
		constant Reg_Y, Reg_X: in data_type) is
  variable address: data_type:=0;
  begin
  	address:= Reg_Y; 	-- address is the value in memory(PC)
	memory(address):= Reg_X;  -- assign content of Reg(X) in memory indexed by address
  end EXEC_str;
  -- end str
end mem_access_pack;


 		