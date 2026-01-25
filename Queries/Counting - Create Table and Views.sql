DROP TABLE IF EXISTS countingvenues;

CREATE TABLE countingvenues
(
  officecode character varying(6) NOT NULL,
  slno smallint NOT NULL,
  venuecode character varying(9) NOT NULL,
  venuedescription character varying(99) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT countingvenuespkey PRIMARY KEY (venuecode),
  CONSTRAINT countingvenuefkey2 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingvenuesfkey FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingvenuesukey1 UNIQUE (officecode, venuedescription),
  CONSTRAINT countingvenuesukey2 UNIQUE (officecode, slno)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE countingvenues
  OWNER TO elections;


DROP TABLE IF EXISTS countinghalls;

CREATE TABLE countinghalls
(
  venuecode character varying(9) NOT NULL,
  hallno smallint NOT NULL,
  hallcode character varying(11) NOT NULL,
  halldescription character varying(99) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT countinghallspkey PRIMARY KEY (hallcode),
  CONSTRAINT countinghallsfkey2 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countinghallsfkey FOREIGN KEY (venuecode)
      REFERENCES countingvenues (venuecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countinghallsukey1 UNIQUE (venuecode, hallno),
  CONSTRAINT countinghallsukey2 UNIQUE (venuecode, halldescription)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE countinghalls
  OWNER TO elections;



CREATE TABLE countinghallsacs
(
  hallcode character varying(11) NOT NULL,
  acno smallint NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT countinghallsacspkey PRIMARY KEY (hallcode, acno),

  CONSTRAINT countinghallsacsfkey1 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT countinghallsfkey2 FOREIGN KEY (hallcode)
      REFERENCES countinghalls (hallcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT, 
      
  CONSTRAINT countinghallsfkey3 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT


)
WITH (
  OIDS=FALSE
);
ALTER TABLE countinghallsacs
  OWNER TO elections;


CREATE TABLE countingtables
(
  hallcode character varying(11) NOT NULL,
  tableno smallint NOT NULL,
  tabledescription character varying(11) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT countingtablespkey PRIMARY KEY (hallcode, tableno),

  CONSTRAINT countingtablesfkey1 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT countingtablesfkey2 FOREIGN KEY (hallcode)
      REFERENCES countinghalls (hallcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT countingtablesukey UNIQUE  (hallcode, tabledescription)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE countingtables
  OWNER TO elections;



DROP TABLE IF EXISTS masters.rndcountingcategoriesmap;

CREATE TABLE masters.rndcountingcategoriesmap
(
  officecode character varying(6) NOT NULL,
  personnelcategorycode smallint NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT rcpmukey1 PRIMARY KEY (officecode, personnelcategorycode),
  CONSTRAINT rcpmfk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT rcpmfkey2 FOREIGN KEY (personnelcategorycode)
      REFERENCES masters.personnelcategories (personnelcategorycode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT rcpmfkey4 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE masters.rndcountingcategoriesmap
  OWNER TO elections;



DROP TABLE IF EXISTS countingallocation1;

CREATE TABLE countingallocation1
(
  officecode character varying(6) NOT NULL,
  employeecode character varying(11) NOT NULL,
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
  CONSTRAINT countingallocation1pk PRIMARY KEY (employeecode),
  CONSTRAINT countingallocation1fk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation1fk2 FOREIGN KEY (employeecode)
      REFERENCES personnel (employeecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation1fk3 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation1chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE countingallocation1
  OWNER TO elections;



-- Table: countingallocation2

DROP TABLE IF EXISTS countingallocation2;

CREATE TABLE countingallocation2
(
  officecode character varying(6) NOT NULL,
  hallcode character varying(11) NOT NULL,
  provisionaltableno smallint NOT NULL,
  personnelcategorycode smallint NOT NULL,
  employeecode character varying(11) NOT NULL,
  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  CONSTRAINT countingallocation2fk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation2fk2 FOREIGN KEY (hallcode)
      REFERENCES countinghalls (hallcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation2fk3 FOREIGN KEY (hallcode, provisionaltableno)
      REFERENCES countingtables (hallcode, tableno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation2fk4 FOREIGN KEY (employeecode)
      REFERENCES personnel (employeecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation2fk5 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation2pk UNIQUE (employeecode),
  CONSTRAINT countingallocation2uk2 UNIQUE (hallcode, provisionaltableno, personnelcategorycode),
  CONSTRAINT countingallocation2chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE countingallocation2
  OWNER TO elections;

-- Table: countingallocation3

DROP TABLE IF EXISTS countingallocation3;

CREATE TABLE countingallocation3
(
  officecode character varying(6) NOT NULL,
  hallcode character varying(11) NOT NULL,
  tableno smallint NOT NULL,
  personnelcategorycode smallint NOT NULL,
  employeecode character varying(11) NOT NULL,
  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
add swapped 
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  CONSTRAINT countingallocation3fk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation3fk2 FOREIGN KEY (hallcode)
      REFERENCES countinghalls (hallcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation3fk3 FOREIGN KEY (hallcode, tableno)
      REFERENCES countingtables (hallcode, tableno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation3fk4 FOREIGN KEY (employeecode)
      REFERENCES personnel (employeecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation3fk5 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingallocation3pk UNIQUE (employeecode),
  CONSTRAINT countingallocation3uk2 UNIQUE (hallcode, tableno, personnelcategorycode),
  CONSTRAINT countingallocation3chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE countingallocation3
  OWNER TO elections;


DROP VIEW  IF EXISTS VWCOUNTINGALLOCATION2 ;

CREATE OR REPLACE VIEW VWCOUNTINGALLOCATION2 AS 
SELECT EO.OFFICECODE AS ELECTIONOFFICECODE, EO.OFFICENAME AS ELECTIONOFFICENAME, CV.VENUECODE, CV.VENUEDESCRIPTION, CH.HALLCODE, CH.HALLNO , TABLENO, 
P.EMPLOYEECODE, P.FULLNAME, P.DESIGNATION, PC.PERSONNELCATEGORYCODE, PERSONNELCATEGORYDESCRIPTION, O.OFFICECODE, O.OFFICENAME, MOBILENO
FROM MASTERS.OFFICES EO INNER JOIN COUNTINGVENUES CV ON EO.OFFICECODE = CV.OFFICECODE 
INNER JOIN COUNTINGHALLS CH ON CV.VENUECODE = CH.VENUECODE
INNER JOIN COUNTINGTABLES CT ON CH.HALLCODE = CT.HALLCODE 
INNER JOIN COUNTINGALLOCATION2 ALLC ON (EO.OFFICECODE = ALLC.OFFICECODE AND CH.HALLCODE = ALLC.HALLCODE AND CT.TABLENO = ALLC.PROVISIONALTABLENO)
INNER JOIN VWPERSONNEL P ON (P.EMPLOYEECODE = ALLC.EMPLOYEECODE AND P.PERSONNELCATEGORYCODE = ALLC.PERSONNELCATEGORYCODE)
INNER JOIN MASTERS.OFFICES O ON (O.OFFICECODE = P.OFFICECODE AND O.REFERENCEOFFICECODE = EO.OFFICECODE)
INNER JOIN MASTERS.PERSONNELCATEGORIES PC ON PC.PERSONNELCATEGORYCODE = P.PERSONNELCATEGORYCODE
ORDER BY EO.OFFICECODE, CV.VENUECODE, CV.VENUEDESCRIPTION, HALLNO, TABLENO, 
CASE WHEN PC.PERSONNELCATEGORYCODE = 21 THEN 1 
WHEN PC.PERSONNELCATEGORYCODE = 22 THEN 2 
WHEN PC.PERSONNELCATEGORYCODE = 9 THEN 3 
END, PC.PERSONNELCATEGORYCODE ;



--DROP TABLE masters.countingmastertable;

CREATE TABLE masters.countingmastertable
(
  officecode character varying(6) NOT NULL,
  reportingvenue character varying(99),
  countingdate date NOT NULL,
  reportingdate date NOT NULL,
  reportingtime character varying(20) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT countingmasterspkey PRIMARY KEY (officecode),
  CONSTRAINT countingmastersfk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT countingmastersfkey2 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE masters.countingmastertable
  OWNER TO elections;


