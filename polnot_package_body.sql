CREATE OR REPLACE PACKAGE BODY pol_not AS
    
    TYPE expr_array IS TABLE OF VARCHAR2(38) INDEX BY PLS_INTEGER;
    TYPE varchar_array  IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    
    -- Stack for simplifying alghorithms
    stack varchar_array;
    pointer PLS_INTEGER := -1;
    
    regexp CONSTANT VARCHAR2(80) := '[-\+\*\/\^\(\)]|(\d+)|(\d+(\.|,)\d+)|((\.|,)\d+)';
    
    -- Push elem to stack
    PROCEDURE push (elem VARCHAR2) AS
    BEGIN
        pointer := pointer + 1;
        stack(pointer) := elem;
    END;
    
    -- Pop elem from stack
    FUNCTION pop RETURN VARCHAR2 AS
    BEGIN
        IF pointer = -1 THEN
            RETURN NULL;
        END IF;
        
        pointer := pointer - 1;
        RETURN stack(pointer+1);
    END;
    
    -- Look at the top element of stack
    FUNCTION peak RETURN VARCHAR2 AS
    BEGIN
        IF pointer = -1 THEN
            RETURN NULL;
        END IF;
        
        RETURN stack(pointer);
    END;
    
    -- Print into serveroutput current state of stack.
    -- Use for debugging purpouses
    PROCEDURE draw AS
    BEGIN
        FOR i IN REVERSE 0..pointer LOOP
            DBMS_OUTPUT.PUT('<' || stack(i) || '> ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE();
    END;
    
    -- Clear stack:
    --      - Delete elements
    --      - Reset pointer
    -- Don't forget to clear stack after/before working with it
    PROCEDURE clear AS
    BEGIN
        pointer := -1;
        stack.DELETE();
    END;
    
    -- Normalizes infix expression
    --      - Removes whitespaces
    --      - Replace unary minus with substraction from zero
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
        r_expr VARCHAR2(4000);
    BEGIN
        -- in_to_pre(expr) = post_to_pre(in_to_post(expr))
        -- Works, but slower than normal algorithm
        -- TODO: Replace this with normal algorithm
        r_expr := in_to_post(expr);
        r_expr := post_to_pre(r_expr);
        
        RETURN r_expr;
    END;
    
    FUNCTION in_to_post (expr VARCHAR2)
        RETURN VARCHAR2 AS
        t_expr VARCHAR2(4000) := expr;
        r_expr VARCHAR2(4000) := '';
        temp VARCHAR2(80);
        expr_plan expr_array;
        curr_elem PLS_INTEGER := 1;
    BEGIN
        clear();
        normalize_expr(t_expr);
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
        END LOOP;
        
        WHILE peak() IS NOT NULL LOOP
            r_expr := r_expr || pop() || ' ';
        END LOOP;
                
        clear();
        RETURN r_expr;
    END;
        
    FUNCTION pre_to_in (expr VARCHAR2)
        RETURN VARCHAR2 AS
        r_expr VARCHAR2(4000);
    BEGIN
        -- pre_to_in(expr) = post_to_in(pre_to_post(expr))
        -- Works, but slower than normal algorithm
        -- TODO: Replace this with normal algorithm
        r_expr := pre_to_post(expr);
        r_expr := post_to_in(r_expr);
        
        RETURN r_expr;
    END;
        
    FUNCTION pre_to_post (expr VARCHAR2)
        RETURN VARCHAR2 AS
        left_first  VARCHAR(4000);
        left_second VARCHAR2(4000);
        temp   VARCHAR2(38);
    BEGIN
        FOR i IN REVERSE 1..REGEXP_COUNT(expr, '[^[:space:]]+') LOOP
            temp := REGEXP_SUBSTR(expr, '[^[:space:]]+', 1, i);
            IF REGEXP_LIKE(temp, '\d') THEN
                push(temp);
            ELSE
                left_first := pop();
                left_second := pop();
                temp := left_first || ' ' || left_second || ' ' || temp;
                push(temp);
            END IF;
        END LOOP;
        temp := pop();
        clear();
        RETURN temp;
    END;
        
    FUNCTION post_to_in (expr VARCHAR2)
        RETURN VARCHAR2 AS
        left_op  VARCHAR2(38);
        right_op VARCHAR2(38);
        temp     VARCHAR2(4000);
    BEGIN
        FOR i IN 1..REGEXP_COUNT(expr, '[^[:space:]]+') LOOP
            temp := REGEXP_SUBSTR(expr, '[^[:space:]]+', 1, i);
            IF REGEXP_LIKE(temp, '\d') THEN
                push(temp);
            ELSE
                right_op := pop();
                left_op  := pop();
                temp := '(' || left_op || ' ' || temp || ' ' || right_op || ')';
                push(temp);
            END IF;
        END LOOP;
        
        temp := pop();
        clear();
        RETURN temp;
    END;
        
    FUNCTION post_to_pre (expr VARCHAR2)
        RETURN VARCHAR2 AS
        right_most   VARCHAR2(4000);
        right_first  VARCHAR2(4000);
        temp         VARCHAR2(4000);
    BEGIN
        clear();
        
        FOR i IN 1..REGEXP_COUNT(expr, '[^[:space:]]+') LOOP
            temp := REGEXP_SUBSTR(expr, '[^[:space:]]+', 1, i);
            IF REGEXP_LIKE(temp, '\d') THEN
                push(temp);
            ELSE
                right_most  := pop();
                right_first := pop();
                temp := temp  || ' ' || right_first || ' ' || right_most;
                push(temp);
            END IF;
        END LOOP;
        temp := pop();
        clear();
        RETURN temp;
    END;
        
END pol_not;