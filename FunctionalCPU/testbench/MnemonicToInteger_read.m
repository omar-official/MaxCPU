%% ===========================================================================
% Goal          : This file reads the prosessor commands from an excel file and
%                 converts these commands into binary numbers and then to
%                 integers. Next, the values are saved in a .txt file.
%
% Project       : CPU-Project (TUM)
% Author        : Kamel Shibli(ga32miw@mytum.de)
%
% $Revision     : 2.0 $  $Date: 2014/11/04$
%
% Reference:    : This implementation of ths function is based on the lecture 
%                 "Entwurf digitaler Systeme mit VHDL und SystemC"
%                 Institute for ELectronic Design Automation EDA
%                 TU Munich
%
% Description   : Instruction code is composed of 12 bits
%                 1-st 6 bits from left are reserved for the Opcode
%                 Last 6 bits are assigned to X, Y & Z (2 bits each)
%                 The binary value is determined from Opcode, X, Y & Z
%                 The integer values is determined by converting to decimal
%                 The integer values are saved in MemoryFile_read.txt
%
% Parameters    : input <- excel file (Mnemonic, Assembler code)
%                 output -> MemoryFile_read (integer values)
%
%
% Purpose       : The generated .txt file will be used for the CPU
%                 functional VHDL model to read data from input file
%                 and initialize the memory content (init_memory)
% ===========================================================================

clear all;

% read data from excel file
[ndata, text, alldata] = xlsread('ProssesorCommands_read.xlsx');

% get data for memory access
data = ndata(:,1);
index = find(data==0.1);
index_not = setdiff(1:length(data), index)';

% get command, content of registers X,Y and Z as well
com = text(:,1);
X   = text(:,2);
Y   = text(:,3);
Z   = text(:,4);

% Initialize parameters
L       = length(com);
OPcode  = zeros(L-1,6);
Reg_X   = zeros(L-1,2);
Reg_Y   = zeros(L-1,2);
Reg_Z   = zeros(L-1,2);
Reg_XYZ = zeros(L-1,6);
Matrix  = -1*ones(L-1, 2);
Out     = zeros(2^12, 1);

% for loop
for i = 2:L
    % Registers
    help = char(com(i));
    X_i = char(X(i));     Y_i = char(Y(i));    Z_i = char(Z(i));
%     if i==L
%            dbstop in MnemonicToInteger_read.m at 60
%     end
    switch help
        case {'NOP','STOP'}
        XX = [0 0]; YY = XX; ZZ = YY;
        case {'ADD', 'ADDC', 'SUB', 'SUBC', 'AND', 'OR', 'XOR'}
            if strcmp(X_i,'R0')
                XX = [0 0];
            elseif strcmp(X_i,'R1')
                XX = [0 1];
            elseif strcmp(X_i,'R2')
                XX = [1 0];
            else
                XX = [1 1];
            end
            if strcmp(Y_i,'R0')
                YY = [0 0];
            elseif strcmp(Y_i,'R1')
                YY = [0 1];
            elseif strcmp(Y_i,'R2')
                YY = [1 0];
            else
                YY = [1 1];
            end
            if strcmp(Z_i,'R0')
                ZZ = [0 0];
            elseif strcmp(Z_i,'R1')
                ZZ = [0 1];
            elseif strcmp(Z_i,'R2')
                ZZ = [1 0];
            else
                ZZ = [1 1];
            end
        case {'REA', 'REO', 'REX', 'SLL', 'SRL', 'SRA',  ...
        	  'ROLC', 'ROR' , 'RORC', 'LDR', 'STR'}
            if strcmp(X_i,'R0')
                XX = [0 0];
            elseif strcmp(X_i,'R1')
                XX = [0 1];
            elseif strcmp(X_i,'R2')
                XX = [1 0];
            else
                XX = [1 1];
            end
            if strcmp(Y_i,'R0')
                YY = [0 0];
            elseif strcmp(Y_i,'R1')
                YY = [0 1];
            elseif strcmp(Y_i,'R2')
                YY = [1 0];
            else
                YY = [1 1];
            end
            ZZ = [0 0];
        case {'LDC', 'LDD', 'STD', 'IN', 'OUT'}
            if strcmp(X_i,'R0')
                XX = [0 0];
            elseif strcmp(X_i,'R1')
                XX = [0 1];
            elseif strcmp(X_i,'R2')
                XX = [1 0];
            else
                XX = [1 1];
            end
            YY = [0 0]; ZZ = YY;
        otherwise
    end  
    Reg_X(i-1,:)     = XX;
    Reg_Y(i-1,:)     = YY;
    Reg_Z(i-1,:)     = ZZ;
    Reg_XYZ(i-1,:)   = [XX YY ZZ];
    XX = [0 0]; YY   = XX; ZZ = YY;
    % end Registers 

    % OPcode
    switch help
        case 'NOP'
            OP = de2bi(0,6, 'left-msb');
        case 'STOP'         
            OP = de2bi(1,6, 'left-msb');
        case 'ADD'
            OP = de2bi(2,6, 'left-msb');
        case 'ADDC'
            OP = de2bi(3,6, 'left-msb');
        case 'SUB'
            OP = de2bi(4,6, 'left-msb');
        case 'SUBC'
            OP = de2bi(5,6, 'left-msb');
        case 'NOT'
            OP = de2bi(6,6, 'left-msb');
        case 'AND'
            OP = de2bi(7,6, 'left-msb');
        case 'OR'
            OP = de2bi(8,6, 'left-msb');
        case 'XOR'
            OP = de2bi(9,6, 'left-msb');
        case 'REA'
            OP = de2bi(10,6, 'left-msb');
        case 'REO'
            OP = de2bi(11,6, 'left-msb');
        case 'REX'
            OP = de2bi(12,6, 'left-msb');
        case 'SLL'
            OP = de2bi(13,6, 'left-msb');
        case 'SRL'
            OP = de2bi(14,6, 'left-msb');
        case 'SRA'
            OP = de2bi(15,6, 'left-msb');
        case 'ROL'
            OP = de2bi(16,6, 'left-msb');
        case 'ROLC'
            OP = de2bi(17,6, 'left-msb');
        case 'ROR'
            OP = de2bi(18,6, 'left-msb');
        case 'RORC'
            OP = de2bi(19,6, 'left-msb');
        case 'LDC'
            OP = de2bi(32,6, 'left-msb');
        case 'LDD'
            OP = de2bi(33,6, 'left-msb');
        case 'LDR'
            OP = de2bi(34,6, 'left-msb');
        case 'STD'
            OP = de2bi(35,6, 'left-msb');
        case 'STR'
            OP = de2bi(36,6, 'left-msb');
        case 'IN'
            OP = de2bi(37,6, 'left-msb');
        case 'OUT'
            OP = de2bi(38,6, 'left-msb');
        case 'JMP'
            OP = de2bi(48,6, 'left-msb');
        case 'JZ'
            OP = de2bi(49,6, 'left-msb');
        case 'JC'
            OP = de2bi(50,6, 'left-msb');
        case 'JN'
            OP = de2bi(51,6, 'left-msb');
        case 'JO'
            OP = de2bi(52,6, 'left-msb');
        case 'JNZ'
            OP = de2bi(53,6, 'left-msb');
        case 'JNC'
            OP = de2bi(54,6, 'left-msb');
        case 'JNN'
            OP = de2bi(55,6, 'left-msb');
        case 'JNO'
            OP = de2bi(56,6, 'left-msb');
    end  
    OPcode(i-1, :) = OP;
    % end OPcode
end
% end loop

% get binary and integer value
Binary          = [OPcode Reg_XYZ];
Integer         = bi2de(Binary, 'left-msb');
Matrix(:,1)     = Integer;
Matrix(index_not,2) = ndata(index_not, 1);
Matrix          = Matrix';
Matrix          = Matrix(:);
Matrix(Matrix<0)= []; 

Out(1:length(Matrix), 1) = Matrix;

% fill with data
a = 0;
data_width = 12;
b =  2^data_width - length(Matrix); 
c = 2^data_width-1;
RAM = round(a + c*rand(b,1));
Out(length(Matrix)+1:end) = RAM;

% save to .txt file
fileID = fopen('Memory.txt','w');
fprintf(fileID,'%d \r\n',Out);
fclose(fileID);

