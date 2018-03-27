CREATE OR REPLACE PACKAGE BODY pol_not AS

    TYPE expr_array IS TABLE OF VARCHAR2(38) INDEX BY PLS_INTEGER;
    TYPE ops_array  IS TABLE OF VARCHAR2(38) INDEX BY PLS_INTEGER;
    
    ops_stack ops_array;
    pointer PLS_INTEGER := -1;
    
    regexp CONSTANT VARCHAR2(80) := '[-\+\*\/\^\(\)]|(\d+)|(\d+(\.|,)\d+)|((\.|,)\d+)';
    
    PROCEDURE push (op VARCHAR2) AS
    BEGIN
        pointer := pointer + 1;
        ops_stack(pointer) := op;
    END;
    
    FUNCTION pop RETURN VARCHAR2 AS
    BEGIN
        IF pointer = -1 THEN
            RETURN NULL;
        END IF;
        
        pointer := pointer - 1;
        RETURN ops_stack(pointer+1);
    END;
    
    FUNCTION peak RETURN VARCHAR2 AS
    BEGIN
        IF pointer = -1 THEN
            RETURN NULL;
        END IF;
        
        RETURN ops_stack(pointer);
    END;
    
    PROCEDURE draw AS
    BEGIN
        FOR i IN REVERSE 0..pointer LOOP
            DBMS_OUTPUT.PUT('<' || ops_stack(i) || '> ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE();
    END;
    
    PROCEDURE clear AS
    BEGIN
        pointer := -1;
        ops_stack.DELETE();
    END;
    
    PROCEDURE normalize_expr (expr IN OUT VARCHAR2) AS
    BEGIN
        -- Remove spaces from expression
        expr := REGEXP_REPLACE(expr, '[ ]*', '');
        -- Replace unary minus with substraction from zero
        expr := REGEXP_REPLACE(expr, '^-', '0-');
        expr := REGEXP_REPLACE(expr, '\(-', '(0-');
    END;

    FUNCTION in_to_pre (expr VARCHAR2)
        RETURN VARCHAR2 AS
    BEGIN
        RETURN NULL;
    END;
    
    FUNCTION in_to_post (expr VARCHAR2)
        RETURN VARCHAR2 AS
        t_expr VARCHAR2(4000) := expr;
        r_expr VARCHAR2(4000) := '';
        temp VARCHAR2(80);
        expr_plan expr_array;
        curr_elem PLS_INTEGER := 1;
    BEGIN
        normalize_expr(t_expr);
        DBMS_OUTPUT.PUT_LINE(t_expr);
        DBMS_OUTPUT.PUT_LINE('amount of ops: '||REGEXP_COUNT(t_expr, regexp));
        FOR i IN 1..REGEXP_COUNT(t_expr, regexp) LOOP
            expr_plan(curr_elem) := REGEXP_SUBSTR(t_expr, regexp, 1, i);
            curr_elem := curr_elem + 1;
        END LOOP;
        
        FOR i IN 1..curr_elem-1 LOOP
            IF REGEXP_LIKE(expr_plan(i), '\d') THEN
                r_expr := r_expr || expr_plan(i) || ' ';
            ELSIF expr_plan(i) = '(' THEN
                push(expr_plan(i));
            ELSIF expr_plan(i) = ')' THEN
                LOOP
                    temp := pop();
                    EXIT WHEN temp = '(';
                    r_expr := r_expr || temp || ' ';
                END LOOP;
            ELSE
                IF expr_plan(i) IN ('+', '-') THEN
                    WHILE (peak() IS NOT NULL AND peak() != '(') LOOP
                        r_expr := r_expr || pop() || ' ';
                    END LOOP;
                ELSIF expr_plan(i) IN ('*', '/') THEN
                    WHILE (peak() IN ('*', '/', '^')) LOOP
                        r_expr := r_expr || pop() || ' ';
                    END LOOP;
                END IF;
                push(expr_plan(i));
            END IF;
            DBMS_OUTPUT.PUT_LINE('<'||expr_plan(i)||'>');
            DBMS_OUTPUT.PUT_LINE(r_expr);
            draw();
            DBMS_OUTPUT.PUT_LINE('------------');
        END LOOP;
        
        WHILE peak() IS NOT NULL LOOP
            r_expr := r_expr || pop() || ' ';
        END LOOP;
                
        clear();
        RETURN r_expr;
    END;
        
    FUNCTION pre_to_in (expr VARCHAR2)
        RETURN VARCHAR2 AS
    BEGIN
        RETURN NULL;
    END;
        
    FUNCTION pre_to_post (expr VARCHAR2)
        RETURN VARCHAR2 AS
    BEGIN
        RETURN NULL;
    END;
        
    FUNCTION post_to_in (expr VARCHAR2)
        RETURN VARCHAR2 AS
    BEGIN
        RETURN NULL;
    END;
        
    FUNCTION post_to_pre (expr VARCHAR2)
        RETURN VARCHAR2 AS
    BEGIN
        RETURN NULL;
    END;
        
END pol_not;