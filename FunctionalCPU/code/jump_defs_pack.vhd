




library ieee ;
use WORK.cpu_defs_pack.all;
use WORK.mem_defs_pack.all;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- The package jump_defs_pack declares function for changing the address by using jump commmand
--  i) procedure EXEC_jmp jumps directly to address
-- ii) procedure EXEC_j jumps only if Flag is set to address
--iii) procedure EXEC_jn jumps only if Flag is cleared to address
-- in ii), iii) PC is incremented by 1
-- packages "cpu_defs_pack" & "mem_def_pack" are needed for compilation
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

package jump_defs_pack is
	function EXEC_jmp(constant memory: mem_type; PC: addr_type) return addr_type;
	function EXEC_j (constant memory: mem_type; Flag:Boolean; PC: addr_type) return addr_type;
	function EXEC_jn(constant memory: mem_type; Flag:Boolean; PC: addr_type) return addr_type;
end jump_defs_pack;


-- package body
package body jump_defs_pack is
  -- definition EXEC_jmp
  function EXEC_jmp(constant memory: mem_type; PC: addr_type) return addr_type is
	variable address: addr_type:=0;
	begin
		address:=memory(PC);	-- get address
		return address;
  end EXEC_jmp;
  -- end EXEC_jmp

  -- definition EXEC_j
  function EXEC_j(constant memory: mem_type; Flag: Boolean; PC: addr_type) return addr_type is
	variable address: addr_type:=0;
	begin
		if Flag then
			address:=memory(PC);  -- get address only if flag is set
		else
			address:= PC + 1 mod 2**addr_width;  -- otherwise just increment PC by 1
		end if;
		return address;
  end EXEC_j;
  -- end EXEC_j

  -- definition EXEC_jn
  function EXEC_jn(constant memory: mem_type; Flag: Boolean; PC: addr_type) return addr_type is
	variable address: addr_type:=0;
	begin
		if NOT FLAG then
			address:=memory(PC);  -- get address only if flag is cleared
		else
			address:= PC + 1 mod 2**addr_width;    -- otherwise just increment PC by 1
		end if;
		return address;
  end EXEC_jn;
  -- end EXEC_jn

end jump_defs_pack;
-- end body



