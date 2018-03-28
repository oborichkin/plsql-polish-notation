/*
*/

SET SERVEROUTPUT ON

BEGIN
    dbms_output.put_line('<1 + 1> converts to <' || pol_not.in_to_post('1 + 1') || '>');
    dbms_output.put_line('<1 - 1> converts to <' || pol_not.in_to_post('1 - 1') || '>');
    dbms_output.put_line('<1 * 1> converts to <' || pol_not.in_to_post('1 * 1') || '>');
    dbms_output.put_line('<1 / 1> converts to <' || pol_not.in_to_post('1 / 1') || '>');
    dbms_output.put_line('<1 ^ 1> converts to <' || pol_not.in_to_post('1 ^ 1') || '>');
    
    dbms_output.put_line('---------------------------------------------------------------------------');
    
    dbms_output.put_line('<1 + 2 + 3 + 4> converts to <' || pol_not.in_to_post('1 + 2 + 3 + 4') || '>');
    dbms_output.put_line('<1 - 2 - 3 - 4> converts to <' || pol_not.in_to_post('1 - 2 - 3 - 4') || '>');
    dbms_output.put_line('<1 * 2 * 3 * 4> converts to <' || pol_not.in_to_post('1 * 2 * 3 * 4') || '>');
    dbms_output.put_line('<1 / 2 / 3 / 4> converts to <' || pol_not.in_to_post('1 / 2 / 3 / 4') || '>');
    dbms_output.put_line('<1 ^ 2 ^ 4 ^ 4> converts to <' || pol_not.in_to_post('1 ^ 2 ^ 3 ^ 4') || '>');
    
    dbms_output.put_line('---------------------------------------------------------------------------');
    
    dbms_output.put_line('<1 * (2 + 3) / 4> converts to <' || pol_not.in_to_post('1 * (2 + 3) / 4') || '>');
    dbms_output.put_line('<1 ^ 2 + 3 * 4> converts to <' || pol_not.in_to_post('1 ^ 2 + 3 * 4') || '>');
    dbms_output.put_line('<1 * 2 ^ 3 * 4> converts to <' || pol_not.in_to_post('1 * 2 ^ 3 * 4') || '>');
    dbms_output.put_line('<(1 / 2) ^ (3 / 4)> converts to <' || pol_not.in_to_post('(1 / 2) ^ (3 / 4)') || '>');
    dbms_output.put_line('<1 ^ 2 + 4 ^ 4> converts to <' || pol_not.in_to_post('1 ^ 2 + 3 ^ 4') || '>');
END;

BEGIN
    dbms_output.put_line(pol_not.post_to_pre('1 2 ^ 3 4 ^ + '));
    dbms_output.put_line(pol_not.pre_to_post(pol_not.post_to_pre('1 2 ^ 3 4 ^ + ')));
END;