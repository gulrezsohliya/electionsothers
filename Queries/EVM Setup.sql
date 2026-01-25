/*
INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(64, 'evm/initialization/percentage', 'Percentage of Reserve EVMs', 'bi bi-calculator', 'EVM Management', 'bi bi-receipt-cutoff', 1, 1, 'Y', 'N');

INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(65, 'evm/randomization', 'Randomization of EVMs', 'bi bi-grid-1x2', 'EVM Management', 'bi bi-receipt-cutoff', 1, 1, 'Y', 'N');

INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(66, 'reports/evmallocation', 'EVM Allocation Report', 'bi bi-list', 'Reports', 'bi bi-people-fill', 10, 9, 'Y', 'N');

INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(67, 'reports/evmutilities', 'Utility Reports # EVM Utility Reports', 'bi bi-list', 'Reports', 'bi bi-people-fill', 10, 9, 'Y', 'N');


*/

DROP TABLE evms.evmallocation2;
DROP TABLE evms.evmallocation1;
DROP TABLE evms.evmreservepercentages;
DROP TABLE evms.votingunits;
DROP TABLE masters.votingunittypes;



CREATE TABLE masters.votingunittypes
(
  vunittypecode character varying(1) NOT NULL,
  vunittypedescription character varying(50) NOT NULL,
  CONSTRAINT votingunitspkey PRIMARY KEY (vunittypecode),
  CONSTRAINT votingunitsukey UNIQUE (vunittypedescription)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE masters.votingunittypes
  OWNER TO elections;

INSERT INTO masters.votingunittypes VALUES ('B', 'Ballot Unit');
INSERT INTO masters.votingunittypes VALUES ('C', 'Control Unit');
-- Table: evms.votingunits

-- Table: evms.votingunits

--DROP TABLE evms.votingunits;

CREATE TABLE evms.votingunits
(
  officecode character varying(6) NOT NULL,
  boxno character varying(99) NOT NULL,
  vunittypecode character varying(1) NOT NULL,
  votingunitslno character varying(99) NOT NULL,
  manufacturer character varying(99),
  trainingpolling character varying(1) NOT NULL DEFAULT 'P'::character varying,
  fitforpolling character varying(1) NOT NULL DEFAULT 'P'::character varying,
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  CONSTRAINT votingunitspk PRIMARY KEY (vunittypecode, votingunitslno),
  CONSTRAINT votingunitsfk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT votingunitsfk2 FOREIGN KEY (vunittypecode)
      REFERENCES masters.votingunittypes (vunittypecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT votingunitsfk3 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT votingunitschk1 CHECK (trainingpolling::text = ANY (ARRAY['P'::character varying::text, 'T'::character varying::text])),
  CONSTRAINT votingunitschk2 CHECK (fitforpolling::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE evms.votingunits
  OWNER TO elections;













CREATE TABLE evms.evmallocation1
(
  officecode character varying(6) NOT NULL,
  acno smallint NOT NULL,
  vunittypecode character varying(1) NOT NULL,
  votingunitslno character varying(10) NOT NULL,
  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  CONSTRAINT evmallocation1fk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation1fk2 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation1fk3 FOREIGN KEY (officecode, acno)
      REFERENCES masters.officesacs (officecode, acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation1fk4 FOREIGN KEY (vunittypecode)
      REFERENCES masters.votingunittypes (vunittypecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation1fk5 FOREIGN KEY (vunittypecode, votingunitslno)
      REFERENCES evms.votingunits (vunittypecode, votingunitslno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation1fk6 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation1pk UNIQUE (vunittypecode, votingunitslno),
  
  CONSTRAINT evmallocation1chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE evms.evmallocation1
  OWNER TO elections;




-- Table: evms.evmallocation2

-- DROP TABLE evms.evmallocation2;

CREATE TABLE evms.evmallocation2
(
  officecode character varying(6) NOT NULL,
  acno smallint NOT NULL,
  partno smallint NOT NULL,
  psno smallint NOT NULL,
  vunittypecode character varying(1) NOT NULL,
  votingunitslno character varying(10) NOT NULL,
  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  CONSTRAINT evmallocation2fk1 FOREIGN KEY (officecode)
      REFERENCES masters.offices (officecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation2fk2 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation2fk3 FOREIGN KEY (officecode, acno)
      REFERENCES masters.officesacs (officecode, acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation2fk4 FOREIGN KEY (vunittypecode)
      REFERENCES masters.votingunittypes (vunittypecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation2fk5 FOREIGN KEY (vunittypecode, votingunitslno)
      REFERENCES evms.votingunits (vunittypecode, votingunitslno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation2fk6 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation2fk7 FOREIGN KEY (acno, partno, psno)
      REFERENCES masters.pollingstations (acno, partno, psno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmallocation2pk UNIQUE (vunittypecode, votingunitslno),
  CONSTRAINT evmallocation2uk2 UNIQUE (acno, partno, psno, vunittypecode),
  CONSTRAINT evmallocation2chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE evms.evmallocation2
  OWNER TO elections;



-- Table: evms.evmreservepercentages


CREATE TABLE evms.evmreservepercentages
(
  acno smallint NOT NULL,
  percentage smallint NOT NULL,
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  CONSTRAINT evmreservepercentagespk PRIMARY KEY (acno),
  CONSTRAINT evmreservepercentagesfk2 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT evmreservepercentageschk1 CHECK (percentage >= 10 AND percentage <= 75)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE evms.evmreservepercentages
  OWNER TO elections;

 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (1,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (2,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (3,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (4,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (5,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (6,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (7,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (8,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (9,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (10,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (11,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (12,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (13,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (14,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (15,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (16,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (17,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (18,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (19,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (20,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (21,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (22,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (23,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (24,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (25,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (26,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (27,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (28,40, CURRENT_TIMESTAMP, 1);
 INSERT INTO EVMS.EVMRESERVEPERCENTAGES VALUES (29,40, CURRENT_TIMESTAMP, 1);
