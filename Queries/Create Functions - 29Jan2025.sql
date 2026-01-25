-- Get Voter details by epic
CREATE OR REPLACE FUNCTION erolls.getvoterdetailsbyepic(pepiccardno character varying)
  RETURNS TABLE(acno smallint, partno smallint, sectionno smallint, slnoinpart smallint, firstname character varying, lastname character varying, epiccardno character varying, gender character varying, houseno character varying, relationtype character varying, dob date, age smallint, relationfirstname character varying, relationlastname character varying) AS
$BODY$
BEGIN
    -- Return the result set
    RETURN QUERY
        SELECT  CR.ACNO, CR.PARTNO, CR.SECTIONNO, CR.SLNOINPART, CR.FIRSTNAME, CR.LASTNAME, CR.EPICCARDNO, CR.GENDER, CR.HOUSENO, CR.RELATIONTYPE, CR.DOB, CR.AGE, CR.RELATIONFIRSTNAME, CR.RELATIONLASTNAME
        FROM    (       SELECT  S.ACNO, S.PARTNO, S.SECTIONNO, S.SLNOINPART, S.FIRSTNAME, S.LASTNAME, S.EPICCARDNO, S.GENDER, S.HOUSENO, S.RELATIONTYPE, S.DOB, S.AGE, S.RELATIONFIRSTNAME, S.RELATIONLASTNAME, S.REVISIONNO
                        FROM    EROLLS.ELECTORALROLLSSUP S
                        WHERE   S.EPICCARDNO = pepiccardno AND S.STATUSTYPE IN ('N', 'M')
                                AND S.EPICCARDNO NOT IN ( SELECT ES.EPICCARDNO FROM EROLLS.ELECTORALROLLSSUP ES WHERE ES.EPICCARDNO = pepiccardno AND ES.FORMTYPE = 'F7')
                        
                        UNION ALL

                        SELECT  ER.ACNO, ER.PARTNO, ER.SECTIONNO, ER.SLNOINPART, ER.FIRSTNAME, ER.LASTNAME, ER.EPICCARDNO, ER.GENDER, ER.HOUSENO, ER.RELATIONTYPE, ER.DOB, ER.AGE, ER.RELATIONFIRSTNAME, ER.RELATIONLASTNAME, ER.REVISIONNO
                        FROM    EROLLS.ELECTORALROLLS ER
                        WHERE   ER.EPICCARDNO = pepiccardno AND (ER.EPICCARDNO) NOT IN ( SELECT ES.EPICCARDNO FROM EROLLS.ELECTORALROLLSSUP ES WHERE ES.EPICCARDNO = pepiccardno AND ES.FORMTYPE = 'F7' AND ES.REASONS <> 'R' )
                ) CR
        ORDER BY CR.REVISIONNO DESC
        LIMIT 1;
END;
$BODY$ LANGUAGE plpgsql VOLATILE COST 100;
  
ALTER FUNCTION erolls.getvoterdetailsbyepic(character varying) OWNER TO elections;



SELECT erolls.getvoterdetailsbyepic('TVD0123166')