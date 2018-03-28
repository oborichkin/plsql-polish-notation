/*
    Package for convertion between notations:
        - infix
        - postfix
        - prefix
*/

CREATE OR REPLACE PACKAGE pol_not AS
    
    -- Convert infix notation to prefix
    FUNCTION in_to_pre (expr VARCHAR2)
        RETURN VARCHAR2;
    
    -- Convert infix notation to postfix
    FUNCTION in_to_post (expr VARCHAR2)
        RETURN VARCHAR2;
    
    -- Convert prefix notation to infix
    FUNCTION pre_to_in (expr VARCHAR2)
        RETURN VARCHAR2;
    
    -- Convert prefix notation to postfix
    FUNCTION pre_to_post (expr VARCHAR2)
        RETURN VARCHAR2;
    
    -- Convert postfix notation to infix
    FUNCTION post_to_in (expr VARCHAR2)
        RETURN VARCHAR2;
    
    -- Convert postfix notation to prefix
    FUNCTION post_to_pre (expr VARCHAR2)
        RETURN VARCHAR2;
        
END pol_not;