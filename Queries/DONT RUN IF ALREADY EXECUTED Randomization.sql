	/*
 	-- DO NOT ADD, IF ALREADY EXISTS
	INSERT INTO masters.pages(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES ((SELECT MAX(pageid) FROM masters.pages) + 1, 'randomization', 'Randomization', 'bi bi-box-arrow-in-right', 'Administration', 'bi bi-people-fill', 8, 4, 'Y', 'N');
	INSERT INTO users.userpages(userpageid, pageid, userid)	VALUES ((SELECT MAX(userpageid) FROM users.userpages) + 1, (SELECT MAX(pageid) FROM masters.pages), 1);


	UPDATE MASTERS.PAGES SET URL = 'randomization' WHERE PAGEID = 21;
	INSERT INTO users.userpages(userpageid, pageid, userid)	VALUES ((SELECT MAX(userpageid) FROM users.userpages) + 1, 21, 1);

	DELETE FROM USERS.USERPAGES WHERE PAGEID = 44;
	DELETE FROM MASTERS.PAGES WHERE PAGEID = 44;
	*/	
	DROP TABLE IF EXISTS masters.randomizationtypes;

	CREATE TABLE masters.randomizationtypes
	(
	  randomizationtypecode smallint NOT NULL,
	  randomizationtypedescription character varying(99) NOT NULL,
	  CONSTRAINT rtypepkey PRIMARY KEY (randomizationtypecode),
	  CONSTRAINT rtypecukey UNIQUE (randomizationtypedescription)
	)
	WITH ( OIDS=FALSE);
	ALTER TABLE masters.randomizationtypes OWNER TO elections;
	INSERT INTO MASTERS.RANDOMIZATIONTYPES VALUES (1, 'Randomization of Polling Personnel');
	INSERT INTO MASTERS.RANDOMIZATIONTYPES VALUES (2, 'Randomization of Counting Personnel');

	DROP TABLE IF EXISTS MASTERS.rndpspersonnelcategoriesmap;

	CREATE TABLE MASTERS.rndpspersonnelcategoriesmap
	(
	  officecode character varying(6) NOT NULL,
	  acno smallint NOT NULL,
	  partno smallint NOT NULL,
	  psno smallint NOT NULL,
	  personnelcategorycode smallint NOT NULL,
	  noofpersonnel smallint NOT NULL,
	  userid smallint NOT NULL,
	  entrydate timestamp without time zone NOT NULL DEFAULT now(),
	  CONSTRAINT rcmukey1 PRIMARY KEY (acno, partno, psno, personnelcategorycode),
	  CONSTRAINT rcmfk1 FOREIGN KEY (officecode)
	      REFERENCES masters.offices (officecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT rcmfkey2 FOREIGN KEY (acno, partno, psno)
	      REFERENCES masters.pollingstations (acno, partno, psno) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT rcmfkey3 FOREIGN KEY (personnelcategorycode)
	      REFERENCES masters.personnelcategories (personnelcategorycode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT rcmfkey4 FOREIGN KEY (userid)
	      REFERENCES users.useraccounts (userid) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT
	)
	WITH ( OIDS=FALSE );
	ALTER TABLE MASTERS.rndpspersonnelcategoriesmap OWNER TO elections;

	INSERT INTO MASTERS.rndpspersonnelcategoriesmap SELECT  O.OFFICECODE, AC.ACNO , AP.PARTNO, PSNO,
	1, /*PERSONNELCATEGORYCODE*/ 1, /*NO OF PERSONNEL*/
	1, CURRENT_TIMESTAMP FROM MASTERS.DISTRICTS D INNER JOIN MASTERS.ASSEMBLYCONSTITUENCIES AC ON D.DISTRICTCODE = AC.DISTRICTCODE INNER JOIN MASTERS.OFFICES O ON  D.DISTRICTCODE = O.DISTRICTCODE 
	INNER JOIN  MASTERS.OFFICESACS OA ON (O.OFFICECODE = OA.OFFICECODE AND AC.ACNO = OA.ACNO) INNER JOIN MASTERS.ACPARTS AP ON (AC.ACNO = AP.ACNO) INNER JOIN MASTERS.POLLINGSTATIONS PS ON (AP.ACNO = PS.ACNO AND AP.PARTNO = PS.PARTNO);

	INSERT INTO MASTERS.rndpspersonnelcategoriesmap SELECT  O.OFFICECODE, AC.ACNO , AP.PARTNO, PSNO,
	2, /*PERSONNELCATEGORYCODE*/ 1, /*NO OF PERSONNEL*/
	1, CURRENT_TIMESTAMP FROM MASTERS.DISTRICTS D INNER JOIN MASTERS.ASSEMBLYCONSTITUENCIES AC ON D.DISTRICTCODE = AC.DISTRICTCODE INNER JOIN MASTERS.OFFICES O ON  D.DISTRICTCODE = O.DISTRICTCODE 
	INNER JOIN  MASTERS.OFFICESACS OA ON (O.OFFICECODE = OA.OFFICECODE AND AC.ACNO = OA.ACNO) INNER JOIN MASTERS.ACPARTS AP ON (AC.ACNO = AP.ACNO) INNER JOIN MASTERS.POLLINGSTATIONS PS ON (AP.ACNO = PS.ACNO AND AP.PARTNO = PS.PARTNO);

	INSERT INTO MASTERS.rndpspersonnelcategoriesmap SELECT  O.OFFICECODE, AC.ACNO , AP.PARTNO, PSNO,
	3, /*PERSONNELCATEGORYCODE*/ 1, /*NO OF PERSONNEL*/
	1, CURRENT_TIMESTAMP FROM MASTERS.DISTRICTS D INNER JOIN MASTERS.ASSEMBLYCONSTITUENCIES AC ON D.DISTRICTCODE = AC.DISTRICTCODE INNER JOIN MASTERS.OFFICES O ON  D.DISTRICTCODE = O.DISTRICTCODE 
	INNER JOIN  MASTERS.OFFICESACS OA ON (O.OFFICECODE = OA.OFFICECODE AND AC.ACNO = OA.ACNO) INNER JOIN MASTERS.ACPARTS AP ON (AC.ACNO = AP.ACNO) INNER JOIN MASTERS.POLLINGSTATIONS PS ON (AP.ACNO = PS.ACNO AND AP.PARTNO = PS.PARTNO);

	INSERT INTO MASTERS.rndpspersonnelcategoriesmap SELECT  O.OFFICECODE, AC.ACNO , AP.PARTNO, PSNO,
	4, /*PERSONNELCATEGORYCODE*/ 1, /*NO OF PERSONNEL*/
	1, CURRENT_TIMESTAMP FROM MASTERS.DISTRICTS D INNER JOIN MASTERS.ASSEMBLYCONSTITUENCIES AC ON D.DISTRICTCODE = AC.DISTRICTCODE INNER JOIN MASTERS.OFFICES O ON  D.DISTRICTCODE = O.DISTRICTCODE 
	INNER JOIN  MASTERS.OFFICESACS OA ON (O.OFFICECODE = OA.OFFICECODE AND AC.ACNO = OA.ACNO) INNER JOIN MASTERS.ACPARTS AP ON (AC.ACNO = AP.ACNO) INNER JOIN MASTERS.POLLINGSTATIONS PS ON (AP.ACNO = PS.ACNO AND AP.PARTNO = PS.PARTNO);

	DROP TABLE IF EXISTS pollingallocation1;

	CREATE TABLE pollingallocation1
	(
	  officecode character varying(6) NOT NULL,
	  employeecode character varying(11) NOT NULL,
	  entrydate timestamp with time zone NOT NULL DEFAULT now(),
	  userid smallint NOT NULL,
	  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
	  CONSTRAINT pollingallocation1pk PRIMARY KEY (employeecode),
	  CONSTRAINT pollingallocation1fk1 FOREIGN KEY (officecode)
	      REFERENCES masters.offices (officecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingallocation1fk2 FOREIGN KEY (employeecode)
	      REFERENCES personnel (employeecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingallocation1fk3 FOREIGN KEY (userid)
	      REFERENCES users.useraccounts (userid) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingallocation1chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE pollingallocation1
	  OWNER TO elections;



	--DROP TABLE IF EXISTS pollingallocation2;

	CREATE TABLE pollingallocation2
	(
	  officecode character varying(6) NOT NULL,
	  acno smallint NOT NULL,
	  provisionalpartno smallint NOT NULL,
	  provisionalpsno smallint NOT NULL,
	  personnelcategorycode smallint NOT NULL,
	  employeecode character varying(11) NOT NULL,
	  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
	  entrydate timestamp with time zone NOT NULL DEFAULT now(),
	  userid smallint NOT NULL,
	  
	  CONSTRAINT pollingallocation2fk1 FOREIGN KEY (officecode)
	      REFERENCES masters.offices (officecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,

	  CONSTRAINT pollingallocation2fk2 FOREIGN KEY (acno)
	      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,

	 CONSTRAINT pollingallocation2fk3 FOREIGN KEY (officecode, acno)
	      REFERENCES masters.officesacs (officecode, acno) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,

	  CONSTRAINT pollingallocation2fk4 FOREIGN KEY (employeecode)
	      REFERENCES personnel (employeecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,

	  CONSTRAINT pollingallocation2fk5 FOREIGN KEY (userid)
	      REFERENCES users.useraccounts (userid) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,

	  CONSTRAINT pollingallocation2fk6 FOREIGN KEY (acno, provisionalpartno, provisionalpsno)
	      REFERENCES masters.pollingstations (acno, partno, psno) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,

	  CONSTRAINT pollingallocation2pk UNIQUE (employeecode),
	  CONSTRAINT pollingallocation2uk1 UNIQUE (employeecode, acno),
	  CONSTRAINT pollingallocation2uk2 UNIQUE (acno, provisionalpartno, provisionalpsno, personnelcategorycode),
	  CONSTRAINT pollingallocation2chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE pollingallocation2
	  OWNER TO elections;



	--DROP TABLE IF EXISTS pollingallocation3;

	CREATE TABLE pollingallocation3
	(
	  officecode character varying(6) NOT NULL,
	  acno smallint NOT NULL,
	  partno smallint NOT NULL,
	  psno smallint NOT NULL,
	  personnelcategorycode smallint NOT NULL,
	  employeecode character varying(11) NOT NULL,
	  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
	  entrydate timestamp with time zone NOT NULL DEFAULT now(),
	  userid smallint NOT NULL,
	  CONSTRAINT pollingallocation3fk2 FOREIGN KEY (personnelcategorycode)
	      REFERENCES masters.personnelcategories (personnelcategorycode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingallocation3fk5 FOREIGN KEY (userid)
	      REFERENCES users.useraccounts (userid) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,

	  CONSTRAINT pollingallocation3fk6 FOREIGN KEY (officecode)
	      REFERENCES masters.offices (officecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,


	  CONSTRAINT pollingallocation3fk7 FOREIGN KEY (officecode, acno)
	      REFERENCES masters.officesacs (officecode,acno) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,


	  CONSTRAINT pollingallocation3fkey1 FOREIGN KEY (acno, partno, psno)
	      REFERENCES masters.pollingstations (acno, partno, psno) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,




	  CONSTRAINT pollingallocation3fkey4 FOREIGN KEY (acno, employeecode)
	      REFERENCES pollingallocation2 (acno, employeecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingallocation3k3 FOREIGN KEY (employeecode)
	      REFERENCES pollingallocation2 (employeecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingallocation3uk1 UNIQUE (employeecode),
	  CONSTRAINT pollingallocation3uk2 UNIQUE (acno, partno, psno, personnelcategorycode),
	  CONSTRAINT pollingallocation3chk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE pollingallocation3
	  OWNER TO elections;

	

	--DROP TABLE IF EXISTS pollingreserves;

	CREATE TABLE pollingreserves
	(
	  officecode character varying(6) NOT NULL,
	  employeecode character varying(11) NOT NULL,
	  entrydate timestamp with time zone NOT NULL DEFAULT now(),
	  userid smallint NOT NULL,
	  locked character varying(1) NOT NULL DEFAULT 'N'::character varying,
	  CONSTRAINT pollingreservespk PRIMARY KEY (employeecode),
	  CONSTRAINT pollingreservesfk1 FOREIGN KEY (officecode)
	      REFERENCES masters.offices (officecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingreservesfk2 FOREIGN KEY (employeecode)
	      REFERENCES personnel (employeecode) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingreservesfk3 FOREIGN KEY (userid)
	      REFERENCES users.useraccounts (userid) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE RESTRICT,
	  CONSTRAINT pollingreserveschk1 CHECK (locked::text = ANY (ARRAY['Y'::character varying::text, 'N'::character varying::text]))
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE pollingreserves
	  OWNER TO elections;




	 
