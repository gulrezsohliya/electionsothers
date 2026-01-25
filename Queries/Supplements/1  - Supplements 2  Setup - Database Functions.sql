CREATE OR REPLACE FUNCTION erolls.getmaxserialno(pacno smallint, ppartno smallint)
 RETURNS smallint
 LANGUAGE plpgsql
AS $function$
    DECLARE
    slnoinpartnew smallint;
    
        BEGIN
        slnoinpartnew = -1;
        select coalesce( max(slnoinpart), (select coalesce(max(slnoinpart),0) from erolls.electoralrolls er where er.acno = pacno and er.partno = ppartno) 
        ) into slnoinpartnew from erolls.electoralrollssup s where s.acno = pacno and s.partno = ppartno and (statustype = 'N');
    RETURN slnoinpartnew;
        END;
$function$ ;



--DROP FUNCTION IF EXISTS erolls.getvoterscount(smallint,  smallint,character varying, character varying);

-- Function: erolls.getvoterscount(smallint, smallint, character varying, character varying)

-- DROP FUNCTION erolls.getvoterscount(smallint, smallint, character varying, character varying);

CREATE OR REPLACE FUNCTION erolls.getvoterscount(
    pacno smallint,
    ppartno smallint,
    previsionno smallint,
    pgender character varying)
  RETURNS smallint AS
$BODY$
	DECLARE
	vcountmr smallint;
	vcountsup smallint;
	vcount smallint;
	vcountdel smallint;
	vmodified smallint;
	
        BEGIN
		vcountmr = 0;
		vcountsup = 0;
		vcount = 0;

			IF pgender = 'X' THEN 
				SELECT COALESCE((SELECT COUNT(*) INTO vcountmr FROM EROLLS.ELECTORALROLLS WHERE ACNO = pacno AND PARTNO = ppartno),0) ;
				SELECT COALESCE((SELECT COUNT(*) INTO vcountsup FROM EROLLS.ELECTORALROLLSSUP WHERE ACNO = pacno AND PARTNO = ppartno AND STATUSTYPE='N' AND DISPOSED='Y' AND (CASE WHEN previsionno = 99 THEN 1 = 1 ELSE REVISIONNO = previsionno END) ),0) 					;
				SELECT COALESCE((SELECT COUNT(*) INTO vcountdel FROM EROLLS.ELECTORALROLLSSUP WHERE ACNO = pacno AND PARTNO = ppartno AND STATUSTYPE='D' AND DISPOSED='Y'  AND (CASE WHEN previsionno = 99 THEN 1 = 1 ELSE REVISIONNO = previsionno END)),0) ;
				
			ELSE 
				SELECT COALESCE((SELECT COUNT(*) INTO vcountmr FROM EROLLS.ELECTORALROLLS WHERE ACNO = pacno AND PARTNO = ppartno AND GENDER = pgender),0) ;
				SELECT COALESCE((SELECT COUNT(*) INTO vcountsup FROM EROLLS.ELECTORALROLLSSUP WHERE ACNO = pacno AND PARTNO = ppartno AND STATUSTYPE='N' AND DISPOSED='Y' AND GENDER = pgender  AND (CASE WHEN previsionno = 99 THEN 1 = 1 ELSE REVISIONNO = previsionno END)),0) ;
				SELECT COALESCE((SELECT COUNT(*) INTO vcountdel FROM EROLLS.ELECTORALROLLSSUP WHERE ACNO = pacno AND PARTNO = ppartno AND STATUSTYPE='D' AND DISPOSED='Y' AND GENDER = pgender  AND (CASE WHEN previsionno = 99 THEN 1 = 1 ELSE REVISIONNO = previsionno END)),0) ;
			
			END IF ;

			
		IF previsionno = 0  THEN -- MOTHER ROLL 
			vcount = vcountmr;
		ELSEIF previsionno >= 1 and previsionno <=5  THEN -- SUPPLEMENT; ASSUMING MAX SUPPLEMENTNO = 5 
			vcount = vcountsup - vcountdel;
		ELSEIF previsionno = 99  THEN -- MOTHER ROLL + SUPPLEMENT
			vcount = vcountmr + (vcountsup - vcountdel);
		ELSE 
			vcount = 0;
		END IF;

		if pgender <> 'X' AND previsionno > 0 THEN
			vmodified = EROLLS.getmodifiedgenders(1::smallint, pacno,ppartno, pgender);	

			if vmodified is not null THEN
				vcount = vcount  + EROLLS.getmodifiedgenders(1::smallint, pacno,ppartno, pgender) ;
			END IF;
			
		END IF;	
	RETURN vcount;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION erolls.getvoterscount(smallint, smallint, smallint, character varying)
  OWNER TO elections;



-- Function: erolls.getage(smallint, smallint, smallint)

-- DROP FUNCTION erolls.getage(smallint, smallint, smallint);

CREATE OR REPLACE FUNCTION erolls.getage(
    pacno smallint,
    ppartno smallint,
    pslnoinpart smallint)
  RETURNS smallint AS
$BODY$
	DECLARE
	VAGE smallint;
        BEGIN
		VAGE= 0 ;
			SELECT AGE INTO VAGE FROM EROLLS.ELECTORALROLLSSUP R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart ORDER BY REVISIONNO DESC LIMIT 1;
			IF VAGE IS NULL THEN 
			SELECT AGE INTO VAGE FROM EROLLS.ELECTORALROLLS R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
			END IF;
	RETURN VAGE;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION erolls.getage(smallint, smallint, smallint)
  OWNER TO elections;




-- Function: erolls.getgender(smallint, smallint, smallint)

-- DROP FUNCTION erolls.getgender(smallint, smallint, smallint);

CREATE OR REPLACE FUNCTION erolls.getgender(
    pacno smallint,
    ppartno smallint,
    pslnoinpart smallint)
  RETURNS text AS
$BODY$
	DECLARE
	VGENDER CHARACTER VARYING;
        BEGIN
		VGENDER= '' ;
			SELECT GENDER INTO VGENDER FROM EROLLS.ELECTORALROLLSSUP R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart  ORDER BY REVISIONNO DESC LIMIT 1;
			IF VGENDER IS NULL THEN 
			SELECT GENDER INTO VGENDER FROM EROLLS.ELECTORALROLLS R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
			END IF;
			
	RETURN VGENDER;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION erolls.getgender(smallint, smallint, smallint)
  OWNER TO elections;


  -- Function: erolls.getrelationname(smallint, smallint, smallint)

-- DROP FUNCTION erolls.getrelationname(smallint, smallint, smallint);

CREATE OR REPLACE FUNCTION erolls.getrelationname(
    pacno smallint,
    ppartno smallint,
    pslnoinpart smallint)
  RETURNS text AS
$BODY$
	DECLARE
	RELATIONNAME CHARACTER VARYING;
	
          BEGIN
		RELATIONNAME = '';

		SELECT INITCAP(TRIM(RELATIONFIRSTNAME)) ||  CASE WHEN RELATIONLASTNAME IS NULL THEN '' ELSE ' ' || INITCAP(TRIM(RELATIONLASTNAME)) END 
		INTO RELATIONNAME FROM EROLLS.ELECTORALROLLSSUP R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart  AND DISPOSED='Y'   ORDER BY REVISIONNO DESC LIMIT 1;
		
		IF RELATIONNAME IS NULL THEN 
		
		SELECT INITCAP(TRIM(RELATIONFIRSTNAME)) ||  CASE WHEN RELATIONLASTNAME IS NULL THEN '' ELSE ' ' || INITCAP(TRIM(RELATIONLASTNAME)) END 
		INTO RELATIONNAME FROM EROLLS.ELECTORALROLLS R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
		END IF;
	RETURN RELATIONNAME;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION erolls.getrelationname(smallint, smallint, smallint)
  OWNER TO elections;



-- Function: erolls.getrelationtype(smallint, smallint, smallint)

-- DROP FUNCTION erolls.getrelationtype(smallint, smallint, smallint);

CREATE OR REPLACE FUNCTION erolls.getrelationtype(
    pacno smallint,
    ppartno smallint,
    pslnoinpart smallint)
  RETURNS text AS
$BODY$
	DECLARE
	RTYPE CHARACTER VARYING;
	
        BEGIN
		RTYPE = '';


			SELECT RELATIONTYPE INTO RTYPE FROM EROLLS.ELECTORALROLLSSUP R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart  ORDER BY REVISIONNO DESC LIMIT 1;

			IF RTYPE IS NULL THEN 
			SELECT RELATIONTYPE INTO RTYPE FROM EROLLS.ELECTORALROLLS R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
			END IF;
	
	RETURN RTYPE;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION erolls.getrelationtype(smallint, smallint, smallint)
  OWNER TO elections;




 
 -- Function: erolls.getvotersname(smallint, smallint, smallint)

-- DROP FUNCTION erolls.getvotersname(smallint, smallint, smallint);

CREATE OR REPLACE FUNCTION erolls.getvotersname(
    pacno smallint,
    ppartno smallint,
    pslnoinpart smallint)
  RETURNS text AS
$BODY$
	DECLARE
	VNAME CHARACTER VARYING;
	
        BEGIN
		VNAME = '';
		SELECT INITCAP(TRIM(FIRSTNAME)) ||  CASE WHEN LASTNAME IS NULL THEN '' ELSE ' ' || INITCAP(TRIM(LASTNAME)) END 
		INTO VNAME FROM EROLLS.ELECTORALROLLSSUP R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart AND DISPOSED='Y' ORDER BY REVISIONNO DESC LIMIT 1;
		
		IF VNAME IS NULL THEN 
		
		SELECT INITCAP(TRIM(FIRSTNAME)) ||  CASE WHEN LASTNAME IS NULL THEN '' ELSE ' ' || INITCAP(TRIM(LASTNAME)) END 
		INTO VNAME FROM EROLLS.ELECTORALROLLS R WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
		END IF;
	RETURN VNAME;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION erolls.getvotersname(smallint, smallint, smallint)
  OWNER TO elections;



  --------------

-- Function: erolls.getvoterslist(integer, integer, integer)

-- DROP FUNCTION erolls.getvoterslist(integer, integer, integer);

CREATE OR REPLACE FUNCTION erolls.getvoterslist(
    IN pacno integer,
    IN ppartno integer,
    IN previsionno integer)
  RETURNS TABLE(acno smallint, partno smallint, sectionno smallint, slnoinpart smallint, firstname character varying, lastname character varying, epiccardno character varying, gender character varying, houseno character varying, relationtype character varying, dob date, age smallint, relationfirstname character varying, relationlastname character varying) AS
$BODY$
BEGIN
    -- Return the result set
    RETURN QUERY
    


SELECT ER.ACNO, ER.PARTNO, ER.SECTIONNO, ER.SLNOINPART,  ER.FIRSTNAME, ER.LASTNAME, ER.EPICCARDNO, ER.GENDER, ER.HOUSENO, ER.RELATIONTYPE, ER.DOB, ER.AGE, ER.RELATIONFIRSTNAME, ER.RELATIONLASTNAME FROM EROLLS.ELECTORALROLLS ER WHERE ER.ACNO = pacno AND ER.PARTNO = ppartno 
AND (ER.ACNO, ER.PARTNO, ER.SLNOINPART) NOT IN (SELECT S.ACNO, S.PARTNO, S.SLNOINPART FROM EROLLS.ELECTORALROLLSSUP S WHERE REVISIONNO = previsionno AND S.ACNO = pacno AND S.PARTNO = ppartno AND S.STATUSTYPE IN ('D','M'))
UNION ALL 
SELECT S.ACNO, S.PARTNO, S.SECTIONNO, S.SLNOINPART,  S.FIRSTNAME, S.LASTNAME, S.EPICCARDNO, S.GENDER, S.HOUSENO, S.RELATIONTYPE, S.DOB, S.AGE, S.RELATIONFIRSTNAME, S.RELATIONLASTNAME FROM EROLLS.ELECTORALROLLSSUP S WHERE REVISIONNO = previsionno AND S.ACNO = pacno AND S.PARTNO = ppartno AND STATUSTYPE='N'
UNION ALL 
SELECT S.ACNO, S.PARTNO, S.SECTIONNO, S.SLNOINPART,  S.FIRSTNAME, S.LASTNAME, S.EPICCARDNO, S.GENDER, S.HOUSENO, S.RELATIONTYPE, S.DOB, S.AGE, S.RELATIONFIRSTNAME, S.RELATIONLASTNAME FROM EROLLS.ELECTORALROLLSSUP S WHERE REVISIONNO = previsionno AND S.ACNO = pacno AND S.PARTNO = ppartno AND STATUSTYPE='M';


	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ;
ALTER FUNCTION erolls.getvoterslist(integer, integer, integer)
  OWNER TO elections;


--DROP FUNCTION EROLLS.getvoterdetails(integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION erolls.getvoterdetails(
    IN pacno integer,
    IN ppartno integer,
    IN pslnoinpart integer,
    IN previsionno integer)
  RETURNS TABLE(acno smallint, partno smallint, sectionno smallint, slnoinpart smallint, firstname character varying, lastname character varying, epiccardno character varying, gender character varying, houseno character varying, relationtype character varying, dob date, age smallint, relationfirstname character varying, relationlastname character varying) AS
$BODY$
BEGIN
    -- Return the result set
    RETURN QUERY

SELECT ER.ACNO, ER.PARTNO, ER.SECTIONNO, ER.SLNOINPART,  ER.FIRSTNAME, ER.LASTNAME, ER.EPICCARDNO, ER.GENDER, ER.HOUSENO, ER.RELATIONTYPE, ER.DOB, ER.AGE, ER.RELATIONFIRSTNAME, ER.RELATIONLASTNAME 
FROM EROLLS.ELECTORALROLLS ER WHERE ER.ACNO = pacno AND ER.PARTNO = ppartno AND ER.SLNOINPART = pslnoinpart
AND (ER.ACNO, ER.PARTNO, ER.SLNOINPART) NOT IN (SELECT S.ACNO, S.PARTNO, S.SLNOINPART 
FROM EROLLS.ELECTORALROLLSSUP S WHERE REVISIONNO = previsionno AND S.ACNO = pacno AND S.PARTNO = ppartno AND S.STATUSTYPE IN ('D','M'))
UNION ALL 
SELECT S.ACNO, S.PARTNO, S.SECTIONNO, S.SLNOINPART,  S.FIRSTNAME, S.LASTNAME, S.EPICCARDNO, S.GENDER, S.HOUSENO, S.RELATIONTYPE, S.DOB, S.AGE, S.RELATIONFIRSTNAME, S.RELATIONLASTNAME 
FROM EROLLS.ELECTORALROLLSSUP S WHERE REVISIONNO = previsionno AND S.ACNO = pacno AND S.PARTNO = ppartno AND STATUSTYPE='N' AND S.SLNOINPART = pslnoinpart
UNION ALL 
SELECT S.ACNO, S.PARTNO, S.SECTIONNO, S.SLNOINPART,  S.FIRSTNAME, S.LASTNAME, S.EPICCARDNO, S.GENDER, S.HOUSENO, S.RELATIONTYPE, S.DOB, S.AGE, S.RELATIONFIRSTNAME, S.RELATIONLASTNAME 
FROM EROLLS.ELECTORALROLLSSUP S WHERE REVISIONNO = previsionno AND S.ACNO = pacno AND S.PARTNO = ppartno AND STATUSTYPE='M' AND S.SLNOINPART = pslnoinpart;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ;
ALTER FUNCTION erolls.getvoterdetails(integer, integer, integer, integer)
  OWNER TO elections;




-- Function: erolls.getnoofmodifications(smallint, smallint, smallint)

-- DROP FUNCTION erolls.getnoofmodifications(smallint, smallint, smallint);

CREATE OR REPLACE FUNCTION erolls.getnoofmodifications(
    pacno smallint,
    ppartno smallint,
    previsionno smallint)
  RETURNS smallint AS
$BODY$
	DECLARE
	vcount smallint;
	
        BEGIN
		vcount = 0;

		SELECT COUNT(*) INTO vcount FROM EROLLS.ELECTORALROLLSSUP WHERE ACNO = pacno AND PARTNO = ppartno AND STATUSTYPE='M' AND REVISIONNO = previsionno;
			
	
		if vcount = NULL then
			vcount = 0;
		END IF;	
	RETURN vcount;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION erolls.getnoofmodifications(smallint, smallint, smallint)
  OWNER TO elections;

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




CREATE OR REPLACE FUNCTION erolls.getmaxserialno(pacno smallint, ppartno smallint)
 RETURNS smallint
 LANGUAGE plpgsql
AS $function$
    DECLARE
    slnoinpartnew smallint;
    
        BEGIN
        slnoinpartnew = -1;
        select coalesce( max(slnoinpart), (select coalesce(max(slnoinpart),0) from erolls.electoralrolls er where er.acno = pacno and er.partno = ppartno) 
        ) into slnoinpartnew from erolls.electoralrollssup s where s.acno = pacno and s.partno = ppartno and (statustype = 'N');
    RETURN slnoinpartnew;
        END;
$function$
;



CREATE OR REPLACE FUNCTION erolls.getvoterphoto(
        pacno int,
        ppartno int,
        pslnoinpart int
) RETURNS bytea AS $BODY$ DECLARE vphoto bytea;

BEGIN
        -- FROM MOTHER ROLL
        SELECT  se.photo into vphoto
        FROM    erolls.electoralrolls e
                INNER JOIN sources.sourceelectoralrolls se ON se.assembly_constituency_number = e.sourceacno
                AND se.part_number = e.sourcepartno AND se.part_serial_number = e.sourceslnoinpart
        WHERE   e.acno = pacno AND e.partno = ppartno AND e.slnoinpart = pslnoinpart;
        -- FROM SUPP1 FORM 6
        IF vphoto is null THEN
                SELECT  s1.photo into vphoto
                FROM    erolls.electoralrollssup s1
                WHERE   s1.acno = pacno AND s1.partno = ppartno AND s1.slnoinpart = pslnoinpart AND s1.revisionno = 1 AND s1.formtype = 'F6';
        END IF;
        -- FROM SUPP2 FORM 6
        IF vphoto is null THEN
                SELECT  s2.photo into vphoto
                FROM    erolls.electoralrollssup s2
                WHERE   s2.acno = pacno AND s2.partno = ppartno AND s2.slnoinpart = pslnoinpart AND s2.revisionno = 2 AND s2.formtype = 'F6';
        END IF;
        -- FROM SUPP1 -> SHIFTED FROM MOTHER ROLL
        IF vphoto is null THEN
                SELECT  se.photo into vphoto
                FROM    erolls.electoralrollssup s1
                        INNER JOIN erolls.electoralrolls e ON e.acno = s1.sourceacno
                        AND e.partno = s1.sourcepartno AND e.slnoinpart = s1.sourceslnoinpart
                        INNER JOIN sources.sourceelectoralrolls se ON se.assembly_constituency_number = e.sourceacno
                        AND se.part_number = e.sourcepartno AND se.part_serial_number = e.sourceslnoinpart
                WHERE   s1.acno = pacno AND s1.partno = ppartno AND s1.slnoinpart = pslnoinpart AND s1.revisionno = 1 AND s1.statustype = 'N';
        END IF;
        -- FROM SUPP2 -> SHIFTED FROM MOTHER ROLL
        IF vphoto is null THEN
                SELECT  se.photo into vphoto
                FROM    erolls.electoralrollssup s2
                        INNER JOIN erolls.electoralrolls e ON e.acno = s2.sourceacno
                        AND e.partno = s2.sourcepartno AND e.slnoinpart = s2.sourceslnoinpart
                        INNER JOIN sources.sourceelectoralrolls se ON se.assembly_constituency_number = e.sourceacno
                        AND se.part_number = e.sourcepartno AND se.part_serial_number = e.sourceslnoinpart
                WHERE   s2.acno = pacno AND s2.partno = ppartno AND s2.slnoinpart = pslnoinpart AND s2.revisionno = 2 AND s2.statustype = 'N';
        END IF;
        -- FROM SUPP2 -> SHIFTED FROM SUPP1 
        IF vphoto is null THEN
                SELECT  se.photo into vphoto
                FROM    erolls.electoralrollssup s2
                        INNER JOIN erolls.electoralrollssup s1 ON s1.acno = s2.sourceacno
                        AND s1.partno = s2.sourcepartno AND s1.slnoinpart = s2.sourceslnoinpart
                        INNER JOIN erolls.electoralrolls e ON e.acno = s1.sourceacno
                        AND e.partno = s1.sourcepartno AND e.slnoinpart = s1.sourceslnoinpart
                        INNER JOIN sources.sourceelectoralrolls se ON se.assembly_constituency_number = e.sourceacno
                        AND se.part_number = e.sourcepartno AND se.part_serial_number = e.sourceslnoinpart
                WHERE   s2.acno = pacno AND s2.partno = ppartno AND s2.slnoinpart = pslnoinpart AND s1.revisionno = 1 AND s2.revisionno = 2 AND s2.statustype = 'N';
        END IF;
        
        RETURN vphoto;

END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION erolls.getvoterphoto(int, int, int) OWNER TO elections;


SELECT  erolls.getvoterphoto(18, 23, 687);