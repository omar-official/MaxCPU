

use WORK.cpu_defs_pack.all;
use WORK.bit_vector_natural_pack.all;


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
-- The package shift_rotate_pack declares the following functions and procedures
--  i) procedure EXEC_SRL  Shift the value registered in Reg(Y) left by one bit and assign the result to Reg(X)
-- ii) procedure EXEC_SRA  Shift the value registered in Reg(Y) left by one bit through Carry and assign the result to Reg(X)
--iii) procedure EXEC_ROL  Rotate the value registered in Reg(Y) left by one bit and assign the result to Reg(X)
-- iv) procedure EXEC_ROLC Rotate the value registered in Reg(Y) left by one bit through Carry and assign the result to X
--  v) package bit_vector_natural_pack is used for conversion from natural to bit_vector and vice-versa
-- vi) packages cpu_defs_pack and bit_vector_natural_pack are needed
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--  i) procedure EXEC_ROR rotates Reg(Y) right by one bit and assigns the result to Reg(X) --> Carry is not relevant
-- ii) procedure EXEC_ldd rotates Reg(Y) right by one bit through Carry and assigns the result to Reg(X) -> takes Carry into account
--iii) package bit_vector_natural_pack is used for conversion from natural to bit_vector and vice-versa
-- iv) ackages "cpu_defs_pack" & "mem_def_pack" are needed for compilation
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

package shift_rotate_pack is

	procedure EXEC_ROL(
                  constant A:     in data_type; 
                  variable B:     inout data_type;
                  variable Z,C,N,O: out Boolean); 

	procedure EXEC_ROLC(
                  constant A:     in data_type;  
                  variable B:     inout data_type;  -- A:Reg(Y), B:Reg(X)
                  variable Carry: inout Boolean;
                  variable Z,C,N,O: out Boolean);

        procedure EXEC_SLL(
                  constant A:     in data_type; 
                  variable B:     inout data_type;
                  variable Z,C,N,O: out Boolean);
       
        procedure EXEC_SRA(
                  constant A:     in data_type; 
                  variable B:     inout data_type;
                  variable Carry: inout Boolean; 
                  variable Z,C,N,O: out Boolean);  
       ---------------------------------------------------------   
        
        procedure EXEC_ROR(
                  constant A:     in data_type; 
                  variable B:     inout data_type;
                  variable Z,C,N,O: out Boolean); 
	
        procedure EXEC_RORC(
                  constant A:     in data_type; 
                  variable B:     inout data_type;  -- A:Reg(Y), B:Reg(X) 
                  variable Carry: inout Boolean; 
                  variable Z,N,O: out Boolean); 

        procedure EXEC_SRL(
                  constant A:     in data_type; 
                  variable B:     inout data_type;
                  variable Z,C,N,O: out Boolean);

end shift_rotate_pack;


package body shift_rotate_pack is 

--Definition ROL
procedure EXEC_ROL( 
          constant A: in data_type;
          variable B: inout data_type;
          variable Z,C,N,O: out Boolean) is 

variable Reg_X, Reg_Y: bit_vector(addr_width-1 downto 0); --convert A & B into bit vectors and pack them in Reg(X) & Reg(Y)

begin 
          Z:= false;C:= false;N:= false;O:= false;
          Reg_Y:= natural2bit_vector(A, addr_width);  -- represents value of A in bits
	  Reg_X:= natural2bit_vector(B, addr_width);  -- preparing a bit vector that'll contain the result of rotation of A
          Reg_X(11 downto 1):=Reg_Y(10 downto 0);     -- performs rotation
          Reg_X(0):= Reg_Y(11);
          if Reg_X(11)='1' then  n:= true; end if;
	  B:= bit_vector2natural(Reg_X);              -- go back to natural
          if b=0 then z:= true; 
           end if;  
       

end EXEC_ROL;
--End ROL 

--Definition ROLC
procedure EXEC_ROLC(
          constant A:     in data_type; 
          variable B:     inout data_type;
          variable Carry: inout Boolean; 
          variable Z,C,N,O: out Boolean) is 

variable Reg_X, Reg_Y: bit_vector(addr_width-1 downto 0); --convert A & B into bit vectors and pack them in Reg(X) & Reg(Y)

begin
          
          Z:= false;C:= false;N:= false;O:= false;        
          Reg_Y:= natural2bit_vector(A, addr_width);  -- represents value of A in bits
	  Reg_X:= natural2bit_vector(B, addr_width);  -- preparing a bit vector that'll contain the result of rotation of A
          if Reg_Y(11)='1' then c:= TRUE; end if;
          Reg_X(11 downto 1):=Reg_Y(10 downto 0);
          Reg_X(0):= bit'val(Boolean'Pos(Carry));
      
             if Reg_Y(11)= '1' then 
                  Carry:= TRUE;
             else 
                  Carry:= FALSE; 
             end if;  
          if Reg_X(11)= '1' then n:=True; end if;
          B:= bit_vector2natural(Reg_X);              -- go back to natural
          if b=0 then z:= true; end if;  

end EXEC_ROLC;
--End ROLC

--Definition SLL
procedure EXEC_SLL( 
          constant A: in data_type;
          variable B: inout data_type;
          variable Z,C,N,O: out Boolean) is 

variable Reg_X, Reg_Y: bit_vector(addr_width-1 downto 0); --convert A & B into bit vectors and pack them in Reg(X) & Reg(Y)

begin 
           Z:= false;C:= false;N:= false;O:= false;
          Reg_Y:= natural2bit_vector(A, addr_width);  -- represents value of A in bits
	  Reg_X:= natural2bit_vector(B, addr_width);  -- preparing a bit vector that'll contain the result of rotation of A
          if Reg_Y(11)='1' then c:= TRUE; end if;
          Reg_X(11 downto 1):=Reg_Y(10 downto 0);     -- performs rotation
          Reg_X(0):= '0';
	  B:= bit_vector2natural(Reg_X);              -- go back to natural
          if Reg_X(11)= '1' then n:=True; end if;
          if b=0 then z:= true; end if;  

end EXEC_SLL;
--End SLL

--Definition SRA
procedure EXEC_SRA( 
          constant A: in data_type;
          variable B: inout data_type;
          variable Carry: inout Boolean;  
          variable Z,C,N,O: out Boolean) is 

variable Reg_X, Reg_Y: bit_vector(addr_width-1 downto 0); --convert A & B into bit vectors and pack them in Reg(X) & Reg(Y)

begin 
            Z:= false;C:= false;N:= false;O:= false;
          Reg_Y:= natural2bit_vector(A, addr_width);  -- represents value of A in bits
	  Reg_X:= natural2bit_vector(B, addr_width);  -- preparing a bit vector that'll contain the result of rotation of A
          if Reg_Y(0)='1' then c:= TRUE;  end if;         
          Reg_X(10 downto 0):=Reg_Y(11 downto 1);     -- performs rotation
          Reg_X(0):=  Reg_Y(11);    -- LSB gets the binary value of Carry 
	  B:= bit_vector2natural(Reg_X);              -- go back to natural
          if Reg_X(11)= '1' then n:=True; end if;
          if b=0 then z:= true; end if; 

end EXEC_SRA;
--End SRA 

     




-- Definition EXEC_ROR

	procedure EXEC_ROR(
                  constant A: in data_type; 
                  variable B: inout data_type;
                  variable Z,C,N,O: out Boolean) is	

	variable reg_X, reg_Y: bit_vector(addr_width-1 downto 0);
	
        begin
		reg_Y:= natural2bit_vector(A, addr_width);			-- convert A & B to bit_vector
		reg_X:= natural2bit_vector(B, addr_width);
		reg_X := reg_Y(reg_Y'right) & reg_Y(reg_Y'left downto 1);        -- perform rotation without Carry
		B:= bit_vector2natural(reg_X);          			 -- go back to natural
                if Reg_X(11)= '1' then n:=True; else N:=FALSE; end if;		-- set/clear flags
                if B=0 then Z:= true; else Z:=FALSE; end if; 
		O:=FALSE; C:= FALSE;
	end EXEC_ROR;

-- end EXEC_ROR


-- Definition EXEC_RORC
	
        procedure  EXEC_RORC(
                   constant A:     in data_type; 
                   variable B:     inout data_type;
                   variable Carry : inout Boolean; 
                   variable Z,N,O: out Boolean) is

	variable reg_X, reg_Y: bit_vector(addr_width-1 downto 0);
	variable C: bit:='0';
	
begin	
                C:=bit'val(Boolean'pos(Carry));
		reg_Y:= natural2bit_vector(A, addr_width); -- convert A & B to bit_vector
		reg_X:= natural2bit_vector(B, addr_width); 
		reg_X := C & reg_Y(reg_Y'left downto 1);	-- perform rotation considering Carry
		B:= bit_vector2natural(reg_X);			-- go back to natural
		C:= reg_Y(reg_Y'right);
                if Reg_X(11)= '1' then n:=True; end if;		-- set/clear flags
                if B=0 then z:= true; end if; 
		Carry:=Boolean'val(bit'pos(C));
	end EXEC_RORC;

-- end EXEC_RORC




-- Definition SRL

 procedure EXEC_SRL( 
          constant A: in data_type;
          variable B: inout data_type;
          variable Z,C,N,O: out Boolean) is 

variable Reg_X, Reg_Y: bit_vector((addr_width-1) downto 0); --convert A & B into bit vectors and pack them in Reg(X) & Reg(Y)

begin --.................................................

          Z:= false;C:= false;N:= false;O:= false;
          Reg_Y:= natural2bit_vector(A, addr_width);  -- represents value of A in bits
	  if Reg_Y(0)='1' then c:= TRUE;  end if;  
	  Reg_X:= natural2bit_vector(B, addr_width);  -- preparing a bit vector that'll contain the result of rotation of A
          Reg_X(10 downto 0):=Reg_Y(11 downto 1);     -- performs rotation
          Reg_X(11):= '0';
           B:= bit_vector2natural(Reg_X);              -- go back to natural
           if Reg_X(11)= '1' then n:=True; end if;		-- set/clear flags
           if B=0 then z:= true; end if; 
end EXEC_SRL;

end shift_rotate_pack ;
