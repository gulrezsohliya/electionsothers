
CREATE TABLE ELECTIONS.electoralrolls
(
  acno smallint NOT NULL,
  partno smallint NOT NULL,
  slnoinpart smallint NOT NULL,
  sectionno smallint NOT NULL,
  epiccardno character varying(19),
  firstname character varying(99) NOT NULL,
  lastname character varying(99),
  age smallint NOT NULL,
  gender character varying(1) NOT NULL,
  dob date,
  relationtype character varying(10) NOT NULL,
  relationfirstname character varying(99) NOT NULL,
  relationlastname character varying(99),
  houseno character varying(99) NOT NULL,
  housenoold character varying(99),
  statustype character varying(1) NOT NULL,
  revisionno smallint NOT NULL,
  locked character varying(1) NOT NULL DEFAULT 'Y'::character varying,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT electoralrollspkey PRIMARY KEY (acno, partno, slnoinpart),
  CONSTRAINT electoralrollsfkac FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT electoralrollsfkpart FOREIGN KEY (acno, partno)
      REFERENCES masters.acparts (acno, partno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT electoralrollsfksections FOREIGN KEY (acno, partno, sectionno)
      REFERENCES masters.sections (acno, partno, sectionno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT electoralrollsfksrevisions FOREIGN KEY (revisionno)
      REFERENCES masters.electoralrollrevisions (revisionno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT electoralrollage CHECK (age >= 18 AND age <= 120),
  CONSTRAINT electoralrolllocked CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text])),
  CONSTRAINT electoralrollrelation CHECK (relationtype::text = ANY (ARRAY['F'::character varying::text, 'M'::character varying::text, 'H'::character varying::text, 'W'::character varying::text, 'O'::character varying::text])),
  CONSTRAINT electoralrollscheckgender CHECK (gender::text = ANY (ARRAY['M'::character varying::text, 'F'::character varying::text, 'T'::character varying::text])),
  CONSTRAINT electoralrollscheckstatus CHECK (statustype::text = ANY (ARRAY['X'::character varying::text,'M'::character varying::text, 'D'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ELECTIONS.electoralrolls   OWNER TO elections;



DROP TABLE IF EXISTS electoralrollstemp;

CREATE TABLE electoralrollstemp
(
	acno 		smallint NOT NULL, 
	partno 		smallint NOT NULL, 
	slnoinpart 	smallint NOT NULL, 
	sectionno 	smallint NOT NULL, 
	epiccardno	character varying(19) ,
	firstname	character varying(99) NOT NULL ,
	lastname	character varying(99)  ,
	age		smallint NOT NULL, 
	gender		character varying(1) NOT NULL ,
	dob		date ,
	relationtype	character varying(10) NOT NULL ,
	relationfirstname	character varying(99) NOT NULL ,
	relationlastname	character varying(99)  ,
	houseno		character varying(99) NOT NULL ,
	housenoold	character varying(99) ,
	statustype 	character varying(1) NOT NULL,
	revisionno	smallint NOT NULL, 
	sourceacno 		smallint NOT NULL, 
	sourcepartno 		smallint NOT NULL, 
	sourceslnoinpart 	smallint NOT NULL, 
	sourcesectionno 	smallint NOT NULL, 
	userid smallint NOT NULL,
	entrydate timestamp without time zone NOT NULL DEFAULT now(),
	CONSTRAINT electoralrollstemppkey PRIMARY KEY (sourceacno, sourcepartno, sourceslnoinpart),
	CONSTRAINT electoralrollstempfkac FOREIGN KEY (acno) REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE  ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT electoralrollstempfkpart FOREIGN KEY (acno, partno) REFERENCES masters.acparts(acno,partno) MATCH SIMPLE  ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT electoralrollstempfksections FOREIGN KEY (acno, partno, sectionno) REFERENCES masters.sections(acno,partno, sectionno) MATCH SIMPLE  ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT electoralrollstempfksrevisions FOREIGN KEY (revisionno) REFERENCES masters.electoralrollrevisions(revisionno) MATCH SIMPLE  ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT electoralrollstempcheckgender CHECK (gender::text = ANY (ARRAY['M'::character varying::text, 'F'::character varying::text,'T'::character varying::text])),
	CONSTRAINT electoralrollstempcheckstatus CHECK (statustype::text = ANY (ARRAY['X'::character varying::text, 'M'::character varying::text, 'D'::character varying::text,'N'::character varying::text])),
	CONSTRAINT electoralrollrelation CHECK (relationtype::text = ANY (ARRAY['F'::character varying::text, 'M'::character varying::text,'H'::character varying::text,'W'::character varying::text,'O'::character varying::text])),
	CONSTRAINT electoralrollage CHECK (AGE >=18 AND AGE <=120)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE electoralrollstemp   OWNER TO elections ;


DROP FUNCTION IF EXISTS GETVOTERSNAME(SMALLINT, SMALLINT, SMALLINT);
CREATE OR REPLACE FUNCTION GETVOTERSNAME(pacno SMALLINT, ppartno SMALLINT, pslnoinpart SMALLINT)
  RETURNS TEXT AS
$BODY$
	DECLARE
	VNAME CHARACTER VARYING;
	
        BEGIN
		VNAME = '';

			SELECT 
				INITCAP(TRIM(FIRSTNAME)) ||  CASE WHEN LASTNAME IS NULL THEN '' ELSE ' ' || INITCAP(TRIM(LASTNAME)) END 
				INTO VNAME
				FROM ELECTORALROLLS R
				WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
		
	RETURN VNAME;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;


ALTER FUNCTION GETVOTERSNAME(SMALLINT, SMALLINT, SMALLINT)  OWNER TO ELECTIONS;
SELECT ELECTIONS.GETVOTERSNAME(5::smallint,1::smallint, 2::smallint);

DROP FUNCTION IF EXISTS GETSECTIONSNONAME(SMALLINT, SMALLINT);
CREATE OR REPLACE FUNCTION GETSECTIONSNONAME(pacno SMALLINT, ppartno SMALLINT)
  RETURNS TEXT AS $BODY$
DECLARE
  SECTIONS TEXT := '';  -- Declare SECTIONS as TEXT
  SECTION_RECORD RECORD; -- Declare a record to hold each row from the query
BEGIN
  -- Loop over the results from the SELECT query
  FOR SECTION_RECORD IN
    SELECT SECTIONNO || ' - ' || SECTIONNAME AS SECTION_INFO
    FROM MASTERS.SECTIONS R
    WHERE ACNO = pacno AND PARTNO = ppartno
    ORDER BY SECTIONNO
  LOOP
    -- Append each result to SECTIONS, with a delimiter (e.g., ', ')
    SECTIONS := SECTIONS || SECTION_RECORD.SECTION_INFO || CHR(10);
  END LOOP;

  -- Remove the trailing comma and space if SECTIONS is not empty
  IF length(SECTIONS) > 0 THEN
    SECTIONS := left(SECTIONS, length(SECTIONS) - 2);
  END IF;

  -- Return the concatenated result
  RETURN SECTIONS;
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;

ALTER FUNCTION GETSECTIONSNONAME(SMALLINT, SMALLINT)  OWNER TO ELECTIONS;
SELECT ELECTIONS.GETSECTIONSNONAME(1::smallint,1::smallint);


DROP FUNCTION IF EXISTS GETRELATIONTYPE(SMALLINT, SMALLINT, SMALLINT);
CREATE OR REPLACE FUNCTION GETRELATIONTYPE(pacno SMALLINT, ppartno SMALLINT, pslnoinpart SMALLINT)
  RETURNS TEXT AS
$BODY$
	DECLARE
	RTYPE CHARACTER VARYING;
	
        BEGIN
		RTYPE = '';

			SELECT 
				CASE 
				WHEN RELATIONTYPE='F' THEN 'FATHER'
				WHEN RELATIONTYPE='M' THEN 'MOTHER'
				WHEN RELATIONTYPE='H' THEN 'HUSBAND'
				WHEN RELATIONTYPE='W' THEN 'WIFE'
				WHEN RELATIONTYPE='O' THEN 'RELATION'
				END 
				INTO RTYPE
				FROM ELECTORALROLLS R
				WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
		
	RETURN RTYPE;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;


ALTER FUNCTION GETRELATIONTYPE(SMALLINT, SMALLINT, SMALLINT)  OWNER TO ELECTIONS;
SELECT ELECTIONS.GETRELATIONTYPE(5::smallint,1::smallint, 2::smallint);


DROP FUNCTION IF EXISTS GETRELATIONNAME(SMALLINT, SMALLINT, SMALLINT);
CREATE OR REPLACE FUNCTION GETRELATIONNAME(pacno SMALLINT, ppartno SMALLINT, pslnoinpart SMALLINT)
  RETURNS TEXT AS
$BODY$
	DECLARE
	RELATIONNAME CHARACTER VARYING;
	
        BEGIN
		RELATIONNAME = '';

			SELECT 
				INITCAP(TRIM(RELATIONFIRSTNAME)) ||  CASE WHEN RELATIONLASTNAME IS NULL THEN '' ELSE ' ' || INITCAP(TRIM(RELATIONLASTNAME)) END 
				INTO RELATIONNAME
				FROM ELECTORALROLLS R
				WHERE ACNO = pacno  AND PARTNO = ppartno AND SLNOINPART = pslnoinpart;
		
	RETURN RELATIONNAME;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;


ALTER FUNCTION GETRELATIONNAME(SMALLINT, SMALLINT, SMALLINT)  OWNER TO ELECTIONS;
SELECT ELECTIONS.GETRELATIONNAME(5::smallint,1::smallint, 2::smallint);

