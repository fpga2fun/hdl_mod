-----------------------------------------------------------------------------------
-- Purpose: Packages for SRAM model for Chap_6_Randomization/homework_solution
-- Author: Greg Tumbush
--
-- REVISION HISTORY:
-- $Log: package_utility.vhd,v $
-- Revision 1.1  2011/05/29 19:10:04  tumbush.tumbush
-- Check into cloud repository
--
-- Revision 1.1  2011/03/20 19:09:52  Greg
-- Initial check in
--
-----------------------------------------------------------------------------------
Library ieee,work; 
   Use ieee.std_logic_1164.all;
   Use IEEE.Std_Logic_Arith.all;
   Use IEEE.std_logic_TextIO.all;
   Use work.package_timing.all;

Library Std;
   Use STD.TextIO.all;

Package package_utility is

FUNCTION convert_string( S: in STRING) RETURN STD_LOGIC_VECTOR;
FUNCTION conv_integer1(S : STD_LOGIC_VECTOR) RETURN INTEGER;

End; -- package package_utility

Package body package_utility is  


------------------------------------------------------------------------------------------------
--Converts string into std_logic_vector 
------------------------------------------------------------------------------------------------

FUNCTION convert_string(S: in STRING) RETURN STD_LOGIC_VECTOR IS
	VARIABLE result : STD_LOGIC_VECTOR(S'RANGE);
		BEGIN
			FOR i	IN S'RANGE LOOP
				IF 	S(i) = '0' THEN
					result(i) := '0'; 
				ELSIF S(i) = '1' THEN 
					result(i) := '1';
				ELSIF S(i) = 'X' THEN
					result(i) := 'X';		
				ELSE
					result(i) := 'Z';
				END IF;
			END LOOP;
		RETURN result;
END convert_string;

------------------------------------------------------------------------------------------------
--Converts std_logic_vector into integer
------------------------------------------------------------------------------------------------

FUNCTION conv_integer1(S : STD_LOGIC_VECTOR) RETURN INTEGER IS
		VARIABLE result : INTEGER := 0;
		BEGIN
			FOR i IN S'RANGE LOOP
				IF S(i) = '1' THEN
					result := result + (2**i);
				ELSIF S(i) = '0' THEN
					result := result;
				ELSE
					result := 0;
				END IF;
			END LOOP;
			RETURN result;
		END conv_integer1;	




end package_utility;   
