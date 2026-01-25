-- Function: elections.pollingpersonnel(character varying)

DROP FUNCTION elections.pollingpersonnel(character varying);

CREATE OR REPLACE FUNCTION elections.pollingpersonnel(
   pelectionofficecode character varying)
   
  RETURNS TABLE(
	electionofficecode character varying,
	officecode character varying,
	personnelcategorycode smallint,
	employeecode character varying,
	fullname character varying,
	gender character varying,
	dob date,
	acno smallint,
	partno smallint,
	ispwd character varying,
	sensitivitycode smallint
  ) AS
$BODY$
BEGIN
    -- Return the result set
    RETURN QUERY
    
	SELECT EO.OFFICECODE AS electionofficecode,O.officecode,P.personnelcategorycode,P.employeecode,P.fullname,P.gender,P.dob,P.acno,P.partno,P.ispwd,P.sensitivitycode
	FROM masters.offices eo JOIN masters.offices o ON eo.officecode::text = o.referenceofficecode::text JOIN personnel p ON o.officecode::text =  P.officecode::text
	LEFT JOIN exemptedpersonnel vp ON  p.employeecode::text = vp.employeecode::text
	WHERE vp.employeecode IS NULL AND EO.OFFICECODE = pelectionofficecode
	AND P.EMPLOYEECODE NOT IN (SELECT PA2.EMPLOYEECODE FROM POLLINGALLOCATION2 PA2 WHERE PA2.OFFICECODE = pelectionofficecode);
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION elections.pollingpersonnel(character varying)
  OWNER TO elections;


SELECT elections.pollingpersonnel('080001');