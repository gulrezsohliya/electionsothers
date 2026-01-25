INSERT INTO MASTERS.DISTRICTS VALUES (13,'AMLAREM','AMLAREM','S', 17, 275,'AML','1 - Shillong (ST) Parliamentary Constituency');
INSERT INTO MASTERS.DISTRICTS VALUES (14,'PYNURSLA','PYNURSLA','S', 17, 275,'PYN','1 - Shillong (ST) Parliamentary Constituency');
INSERT INTO MASTERS.DISTRICTS VALUES (15,'SOHRA','SOHRA','S', 17, 275,'SOH','1 - Shillong (ST) Parliamentary Constituency');
INSERT INTO MASTERS.DISTRICTS VALUES (16,'CHOKPOT','CHOKPOT','S', 17, 275,'CKT','2 - Tura (ST) Parliamentary Constituency');
INSERT INTO MASTERS.DISTRICTS VALUES (17,'RAKSAMGRE','RAKSAMGRE','S', 17, 275,'RAK','2 - Tura (ST) Parliamentary Constituency');
INSERT INTO MASTERS.DISTRICTS VALUES (18,'DADENGGRE','DADENGGRE','S', 17, 275,'DAD','2 - Tura (ST) Parliamentary Constituency');
INSERT INTO MASTERS.DISTRICTS VALUES (19,'MAWSHYNRUT','MAWSHYNRUT','S', 17, 275,'MRT','2 - Tura (ST) Parliamentary Constituency');

ALTER TABLE MASTERS.DISTRICTS ADD COLUMN REFERENCEDISTRICTCODE SMALLINT DEFAULT 1;
ALTER TABLE MASTERS.DISTRICTS ADD COLUMN ECIDISTRICTCODE CHARACTER VARYING(5) NOT NULL DEFAULT 'A';

UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = DISTRICTCODE WHERE DISTRICTSDO = 'D';
UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = 1 WHERE DISTRICTCODE = 13;
UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = 3 WHERE DISTRICTCODE = 14;
UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = 3 WHERE DISTRICTCODE = 15;
UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = 7 WHERE DISTRICTCODE = 16;
UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = 6 WHERE DISTRICTCODE = 17;
UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = 6 WHERE DISTRICTCODE = 18;
UPDATE MASTERS.DISTRICTS SET REFERENCEDISTRICTCODE = 4 WHERE DISTRICTCODE = 19;


UPDATE MASTERS.DISTRICTS SET ECIDISTRICTCODE = 'S1501' WHERE DISTRICTCODE = 1;
UPDATE MASTERS.DISTRICTS SET ECIDISTRICTCODE = 'S1502' WHERE DISTRICTCODE = 2;
UPDATE MASTERS.DISTRICTS SET ECIDISTRICTCODE = 'S1503' WHERE DISTRICTCODE = 3;
UPDATE MASTERS.DISTRICTS SET ECIDISTRICTCODE = 'S1504' WHERE DISTRICTCODE = 4;
UPDATE MASTERS.DISTRICTS SET ECIDISTRICTCODE = 'S1508' WHERE DISTRICTCODE = 8;
UPDATE MASTERS.DISTRICTS SET ECIDISTRICTCODE = 'S1509' WHERE DISTRICTCODE = 9;
UPDATE MASTERS.DISTRICTS SET ECIDISTRICTCODE = 'S1512' WHERE DISTRICTCODE = 12;

--DROP TABLE masters.blocks;

CREATE TABLE masters.blocks
(
  districtcode smallint NOT NULL,
  blockcode smallint NOT NULL,
  blockslno smallint ,
  blockname character varying(255) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT blockspkey PRIMARY KEY (districtcode, blockcode),
  --CONSTRAINT blocksukey UNIQUE (blockname),  
  CONSTRAINT blocksfk1 FOREIGN KEY (districtcode)
        REFERENCES masters.districts (districtcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE masters.blocks   OWNER TO elections;


SELECT * FROM SOURCES.BLOCKS;
SELECT * FROM MASTERS.BLOCKS;
SELECT * FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.BLOCKS B ON D.DISTRICT_CD = B.DISTRICT_CD;

INSERT INTO MASTERS.BLOCKS 
SELECT DISTINCT D.SLNO, B.SLNO, BLOCK_MUNICIPAL_NO, BLOCK_MUNICIPAL_NAME, 1, CURRENT_DATE 
FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.BLOCKS B  ON D.DISTRICT_CD = B.DISTRICT_CD;


INSERT INTO MASTERS.ASSEMBLYCONSTITUENCIES SELECT D.SLNO, ASMBLY_NO, ASMBLY_NAME, CATEGORY, 1 FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.AC_LIST AC ON D.DISTRICT_CD = AC.DISTRICT_CD


CREATE TABLE SOURCES.officesacs
(
  officecode character varying(6) NOT NULL,
  acno smallint NOT NULL,
  CONSTRAINT officesacspkey PRIMARY KEY (officecode, acno),
  CONSTRAINT officesacsfkey1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT officesacsfkey2 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE SOURCES.officesacs
  OWNER TO elections;

INSERT INTO SOURCES.OFFICESACS SELECT * FROM MASTERS.OFFICESACS;

CREATE TABLE masters.policestations
(
  districtcode smallint NOT NULL,
  policestationno smallint NOT NULL,
  policestationcode character varying(5) NOT NULL,
  policestationname character varying(255) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),

  CONSTRAINT policestationspkey PRIMARY KEY (policestationcode),
  CONSTRAINT policestationupkey UNIQUE (districtcode, policestationno),
  CONSTRAINT policestationsfk1 FOREIGN KEY (districtcode)
      REFERENCES masters.districts (districtcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT

)
WITH (
  OIDS=FALSE
);
ALTER TABLE MASTERS.policestations   OWNER TO elections;

INSERT INTO MASTERS.POLICESTATIONS 
SELECT D.SLNO, POLICEST_NO, LPAD(PS_ID::TEXT,5,'0'), PSTATION_NAME, 1, CURRENT_TIMESTAMP  FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.POLICE_STATIONS PS ON D.DISTRICT_CD = PS.DISTRICT_CD;

--SELECT * FROM SOURCES.POST_OFFICES;
--DROP TABLE masters.postoffices;
DELETE FROM masters.postoffices;

CREATE TABLE masters.postoffices
(
  districtcode smallint NOT NULL,
  postofficeno smallint NOT NULL,
  postofficecode character varying(5) NOT NULL,
  postofficename character varying(255) NOT NULL,
  pincode integer NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),

  CONSTRAINT postofficepkey PRIMARY KEY (postofficecode),
  CONSTRAINT postofficeupkey UNIQUE (districtcode, postofficeno),
  CONSTRAINT postofficefk1 FOREIGN KEY (districtcode)
      REFERENCES masters.districts (districtcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (  OIDS=FALSE
);


ALTER TABLE MASTERS.postoffices OWNER TO elections;
INSERT INTO MASTERS.POSTOFFICES SELECT D.SLNO, POSTOFF_NO, LEFT(POST_OFFICE_ID,5), POST_OFFICE_NAME, PO_PIN, 1, CURRENT_TIMESTAMP FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.POST_OFFICES PO ON D.DISTRICT_CD = PO.DISTRICT_CD;


SELECT * FROM SOURCES.VILLAGES LIMIT 5 ;


DROP TABLE masters.villages;

CREATE TABLE masters.villages(
  vlocationcode character varying(255) NOT NULL,
  districtcode smallint NOT NULL,
  panchayatid character varying(255) ,
  villagename character varying(255) NOT NULL,
  urbanrural character varying(1) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT villagespkey PRIMARY KEY (vlocationcode),
  CONSTRAINT villagesfk1 FOREIGN KEY (districtcode)
      REFERENCES masters.districts (districtcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
     
)
WITH (
  OIDS=FALSE
);
ALTER TABLE villages   OWNER TO elections;

--INSERT INTO MASTERS.VILLAGES SELECT LEFT(VLOCATION, 17), D.SLNO, PANCHAYAT_ID, VILLAGE_NAME, VILLAGE_TYPE, 1, CURRENT_TIMESTAMP FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.VILLAGES V ON D.DISTRICT_CD = V.DISTRICT_CD;
INSERT INTO MASTERS.VILLAGES SELECT regexp_replace(VLOCATION, '\W', '', 'g'), D.SLNO, PANCHAYAT_ID, VILLAGE_NAME, VILLAGE_TYPE, 1, CURRENT_TIMESTAMP FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.VILLAGES V ON D.DISTRICT_CD = V.DISTRICT_CD;

INSERT INTO MASTERS.VILLAGES VALUES ('X',12,'X','NOT AVAILABLE','R',1,CURRENT_TIMESTAMP);
INSERT INTO MASTERS.VILLAGES VALUES ('801890193',12,'X','NOT AVAILABLE','R',1,CURRENT_TIMESTAMP);


SELECT * FROM SOURCES.PART_LIST LIMIT 10;

ALTER TABLE MASTERS.ACPARTS DROP COLUMN fvttype ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN psbuildingsid ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN partvotercapacity ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN villagesinpart ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN mainvillage ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN sensitivitycode ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN motorabledistance ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN nonmotorabledistance ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN patwarino ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN tahsilno ;
ALTER TABLE MASTERS.ACPARTS DROP COLUMN rino ;
ALTER TABLE MASTERS.ACPARTS DROP CONSTRAINT personnelfkacparts ;

ALTER TABLE MASTERS.ACPARTS  ADD COLUMN partlocationcategory character varying(1) NOT NULL DEFAULT 'R';
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN latitude double precision ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN longitude double precision ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN districtcode smallint NOT NULL ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN blockcode smallint NOT NULL ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN block_municipal_no character varying(255) ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN revenuecirclecode character varying(255) ; 
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN pincodex integer NOT NULL ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN postofficecode character varying(255) NOT NULL ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN policestationcode character varying(255) NOT NULL ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN psbuildingid CHARACTER VARYING(255) NOT NULL;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN mainvillagecode CHARACTER VARYING(255)   ;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN fvttype CHARACTER VARYING(1)   NOT NULL;
ALTER TABLE MASTERS.ACPARTS  ADD COLUMN partgendertype CHARACTER VARYING(7)   NOT NULL;
ALTER TABLE MASTERS.ACPARTS ADD COLUMN  userid smallint NOT NULL;
ALTER TABLE MASTERS.ACPARTS ADD COLUMN  entrydate timestamp without time zone NOT NULL DEFAULT now();


ALTER TABLE MASTERS.ACPARTS ADD CONSTRAINT acpartscheckfvt CHECK (fvttype::text = ANY (ARRAY['V'::character varying::text, 'T'::character varying::text]));
ALTER TABLE MASTERS.ACPARTS ADD CONSTRAINT acpartscheckpartgender CHECK (partgendertype::text = ANY (ARRAY['MALE'::character varying::text, 'FEMALE'::character varying::text,'GENERAL'::character varying::text]));

ALTER TABLE MASTERS.ACPARTS ADD CONSTRAINT acpartsfk3 FOREIGN KEY (districtcode) REFERENCES masters.districts (districtcode) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE MASTERS.ACPARTS ADD CONSTRAINT acpartsfk4 FOREIGN KEY (postofficecode) REFERENCES masters.postoffices (postofficecode) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE MASTERS.ACPARTS ADD CONSTRAINT acpartsfk5 FOREIGN KEY (policestationcode) REFERENCES masters.policestations (policestationcode) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE MASTERS.ACPARTS DROP CONSTRAINT acpartsfk6 ;
--ALTER TABLE MASTERS.ACPARTS ADD CONSTRAINT acpartsfk6 FOREIGN KEY (mainvillagecode) REFERENCES masters.villages (vlocationcode) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
 
SELECT * FROM MASTERS.ACPARTS ;
SELECT * FROM SOURCES.PART_LIST ;

INSERT INTO MASTERS.ACPARTS
SELECT REGEXP_REPLACE(	ASMBLY_NO, '\D', '', 'g')::SMALLINT AS ASMBLY_NO, PART_NUMBER, PART_NAME, PART_CATEGORY, PART_LAT, PART_LONG, D.SLNO, 1 AS BLOCKCODE, BLOCK_MUNICIPAL_NO, 
REV_CIRCLE_NO, 
PINCODE, 
LEFT(REGEXP_REPLACE(	POST_OFFICE_ID, '\D', '', 'g'),5), 
REGEXP_REPLACE(	POLICE_ST_ID, '\D', '', 'g'), 
PSBUILDING_ID, CASE WHEN MAIN_VILLAGE IS NULL THEN 'X' ELSE MAIN_VILLAGE END , CASE WHEN FVT_TYPE IS NOT NULL THEN FVT_TYPE ELSE 'V' END, CASE WHEN PS_TYPE IS NULL THEN 'GENERAL' ELSE PS_TYPE END, 1, CURRENT_TIMESTAMP 
FROM SOURCES.DIST_LIST D INNER JOIN SOURCES.PART_LIST P ON D.DISTRICT_CD = LEFT(P.DISTRICT_CD, 5)
;



ALTER TABLE MASTERS.POLLINGSTATIONS DROP COLUMN psslno;
ALTER TABLE MASTERS.POLLINGSTATIONS DROP COLUMN psloctype;
--ALTER TABLE MASTERS.POLLINGSTATIONS DROP COLUMN sensitivitycode ;
ALTER TABLE MASTERS.POLLINGSTATIONS DROP COLUMN PSGENDERTYPE ;
ALTER TABLE MASTERS.POLLINGSTATIONS DROP COLUMN pslocationsectionid ;
ALTER TABLE MASTERS.POLLINGSTATIONS ADD COLUMN  userid smallint NOT NULL;
ALTER TABLE MASTERS.POLLINGSTATIONS ADD COLUMN  entrydate timestamp without time zone NOT NULL DEFAULT now();
ALTER TABLE MASTERS.POLLINGSTATIONS ALTER COLUMN psbuildingid TYPE CHARACTER VARYING(255) ;

SELECT * FROM SOURCES.PS_BUILDINGS;

SELECT * FROM MASTERS.POLLINGSTATIONS


--INSERT INTO MASTERS.POLLINGSTATIONS SELECT 
--AC.ASMBLY_NO, AP.PART_NUMBER,PSBUILDING_NO,  PSB.PSBUILDING_NAME, BUILDING_ADDRESS, PSB.PSBUILDING_ID, PSB.PSBUILDING_NAME, 1,  1, CURRENT_TIMESTAMP
--FROM SOURCES.AC_LIST  AC INNER JOIN SOURCES.PART_LIST AP ON AC.ASMBLY_NO = LEFT(AP.ASMBLY_NO, 2)::SMALLINT
--INNER JOIN SOURCES.PS_BUILDINGS PSB ON (LEFT(AP.ASMBLY_NO, 2)::SMALLINT = LEFT(AP.ASMBLY_NO, 2)::SMALLINT AND AP.psbuilding_id = PSB.PSBUILDING_ID);


INSERT INTO MASTERS.POLLINGSTATIONS 
SELECT AC.ASMBLY_NO, AP.PART_NUMBER,PSBUILDING_NO,  PSB.PSBUILDING_NAME, BUILDING_ADDRESS, regexp_replace(PSB.PSBUILDING_ID, '\W', '', 'g'), PSB.PSBUILDING_NAME, 1,  1, CURRENT_TIMESTAMP
FROM SOURCES.AC_LIST  AC INNER JOIN SOURCES.PART_LIST AP ON AC.ASMBLY_NO = LEFT(AP.ASMBLY_NO, 2)::SMALLINT
INNER JOIN SOURCES.PS_BUILDINGS PSB ON (LEFT(AP.ASMBLY_NO, 2)::SMALLINT = LEFT(AP.ASMBLY_NO, 2)::SMALLINT AND AP.psbuilding_id = PSB.PSBUILDING_ID);



SELECT * FROM SOURCES.SECTION_LIST;

DROP TABLE masters.sections;

CREATE TABLE masters.sections
(
  acno smallint NOT NULL,
  partno smallint NOT NULL,
  sectionno smallint NOT NULL,
  sectionname character varying(255) NOT NULL,
  vlocationcode character varying(255) ,
  pincodex integer NOT NULL ,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT sectionspkey PRIMARY KEY (acno, partno, sectionno),
  CONSTRAINT sectionsfk1 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT sectionsfk2 FOREIGN KEY (acno, partno)
      REFERENCES masters.acparts (acno, partno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE masters.sections
  OWNER TO elections;


--INSERT INTO MASTERS.SECTIONS SELECT ASMBLY_NO, PART_NO, SECTION_NO, SECTION_NAME, LEFT(VLOCATION,17), PIN_CODE, 1, CURRENT_TIMESTAMP FROM SOURCES.SECTION_LIST


INSERT INTO MASTERS.SECTIONS SELECT ASMBLY_NO, PART_NO, SECTION_NO, SECTION_NAME, regexp_replace(VLOCATION, '\W', '', 'g'), PIN_CODE, 1, CURRENT_TIMESTAMP FROM SOURCES.SECTION_LIST



DROP TABLE masters.electoralrollrevisions;
CREATE TABLE masters.electoralrollrevisions
(
  revisionno smallint NOT NULL,
  revisiondescription character varying(255) NOT NULL,
  revisionyear smallint NOT NULL,
  qualifyingdate date NOT NULL,
  revisiontype character varying(50) NOT NULL,
  publicationdate date NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT electoralrollrevisionspkey PRIMARY KEY (revisionno),
  CONSTRAINT electoralrollrevisionsukey1 UNIQUE (revisiondescription),  
  CONSTRAINT electoralrollrevisionsukey2 UNIQUE (qualifyingdate)  

)
WITH (
  OIDS=FALSE
);
ALTER TABLE masters.electoralrollrevisions   OWNER TO elections;


INSERT INTO masters.electoralrollrevisions VALUES (1, 'Basic Roll of Summary Revision', 2025, '2025-01-01', 'Summary Revision', '2025-01-13',1, CURRENT_TIMESTAMP);

DROP TABLE electoralrolls;

CREATE TABLE electoralrolls
(
  acno smallint NOT NULL,
  partno smallint NOT NULL,
  slnoinpart smallint NOT NULL,
  sectionno smallint NOT NULL,
  epiccardno character varying(19),
  firstname character varying(99) NOT NULL,
  lastname character varying(99),
  age smallint NOT NULL,
  gender character varying(6) NOT NULL,
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
  CONSTRAINT electoralrollscheckstatus CHECK (statustype::text = ANY (ARRAY['M'::character varying::text, 'D'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE electoralrolls
  OWNER TO elections;



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
	gender		character varying(6) NOT NULL ,
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
	CONSTRAINT electoralrollstempcheckstatus CHECK (statustype::text = ANY (ARRAY['M'::character varying::text, 'D'::character varying::text,'N'::character varying::text])),
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




SELECT ELECTIONS.GETVOTERSNAME(1::smallint,1::smallint, 1::smallint);