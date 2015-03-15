
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use WORK.cpu_defs_pack.all;
use WORK.mem_defs_pack.all;
use WORK.bit_vector_natural_pack.all;

package arith_defs_pack is
  procedure EXEC_ADDC(constant A,B : in data_type;
			constant CI       : in  boolean;
			variable R        : out data_type;
			variable Z,CO,N,O : out boolean );

procedure EXEC_SUBC(constant A,B : in data_type;
			constant CI       : in  boolean;
			variable R        : out data_type;
			variable Z,CO,N,O : out boolean );
end arith_defs_pack;

package body arith_defs_pack is
	  procedure EXEC_ADDC(constant A,B : in data_type;
			constant CI       : in  boolean;
			variable R        : out data_type;
			variable Z,CO,N,O : out boolean ) is

	  variable T: integer := A+B+Boolean'Pos( CI );
	  variable A_s, B_s, T_s : integer; 
	  begin
		if A >= 2**(data_width-1) then
 			 A_s:= A -2**(data_width);
 		else     
			A_s:= A;
		end if;
   		if B >= 2**(data_width-1) then     
			B_s := B -2**(data_width);   
		else     
			B_s := B;
	        end if;
   		T_s := A_s+B_s+Boolean'Pos( CI );

		if T >= 2**data_width then      
			R := T - 2**data_width;    
			CO := TRUE;   
		else   
   			R := T;     
			CO := FALSE;   
		end if;
   		if T mod 2**data_width = 0 then
      			Z := TRUE;  
 		else     
 			Z := FALSE;   
		end if;
   		if T_s < 0 then
      			N := TRUE;
   		else
      			N := FALSE;
   		end if;
   		if (T_s < -2**(data_width-1)) or (T_s >= 2**(data_width-1)) then
      			O := TRUE;
		   else
		        O := FALSE;
	        end if; 
 	  end EXEC_ADDC;

	  -- EXEC_SUBC
	  procedure EXEC_SUBC(constant A,B : in data_type;
			constant CI       : in  boolean;
			variable R        : out data_type;
			variable Z,CO,N,O : out boolean ) is

	variable T: integer := A-B-Boolean'Pos( CI );	  
	variable A_s, B_s, T_s : integer; 
	  begin
		if A >= 2**(data_width-1) then
 			 A_s:= A -2**(data_width);
 		else     
			A_s:= A;
		end if;
   		if B >= 2**(data_width-1) then     
			B_s := B -2**(data_width);   
		else     
			B_s := B;
	        end if;
   		T_s := A_s-B_s-Boolean'Pos( CI );

		if T < 0 then      
			R := T + 2**data_width;    
			CO := TRUE; 		-- borrow  
		else   
   			R := T;     
			CO := FALSE;   
		end if;  
		
   		if T = 0 then
      			Z := TRUE;  
 		else     
 			Z := FALSE;   
		end if;
   		if T_s < 0 then
      			N := TRUE;
   		else
      			N := FALSE;
   		end if;
   		if (T_s < -2**(data_width-1)) or (T_s >= 2**(data_width-1)) then
      			O := TRUE;
		   else
		        O := FALSE;
	        end if; 
 	  end EXEC_SUBC;
end arith_defs_pack;

