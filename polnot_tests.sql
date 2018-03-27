/*
*/

SET SERVEROUTPUT ON

DECLARE
    expr VARCHAR2(80) := '3 + 4 * 2 / (1 - 5)^2';
BEGIN
    expr := pol_not.in_to_post(expr);
    dbms_output.put_line(expr); 
END;