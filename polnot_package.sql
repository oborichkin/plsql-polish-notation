/*
*/

CREATE OR REPLACE PACKAGE pol_not AS

    FUNCTION in_to_pre (expr VARCHAR2)
        RETURN VARCHAR2;
    
    FUNCTION in_to_post (expr VARCHAR2)
        RETURN VARCHAR2;
        
    FUNCTION pre_to_in (expr VARCHAR2)
        RETURN VARCHAR2;
        
    FUNCTION pre_to_post (expr VARCHAR2)
        RETURN VARCHAR2;
        
    FUNCTION post_to_in (expr VARCHAR2)
        RETURN VARCHAR2;
        
    FUNCTION post_to_pre (expr VARCHAR2)
        RETURN VARCHAR2;
        
END pol_not;