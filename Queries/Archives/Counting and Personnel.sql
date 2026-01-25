DROP TABLE IF EXISTS masters.pollingallocation2backup;
DROP TABLE IF EXISTS masters.pollingstations2023;
DROP TABLE IF EXISTS masters.psparameters2023;
DROP TABLE IF EXISTS masters.psparametersekh;
DROP TABLE IF EXISTS masters.sectorsps162;
DROP TABLE IF EXISTS masters.materialmovement1;
DROP TABLE IF EXISTS  pollingallocation2_2024_04_01;
DROP TABLE IF EXISTS  pollingallocation2_2024_04_02;
DROP TABLE IF EXISTS  IDM;

 

UPDATE MASTERS.PAGES SET parent ='Randomization of Personel' where pageid in (20, 21);









INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(50, 'reports/counting/allocationandreservelist', 'Counting # Allocation and Reserve List', 'bi bi-box-arrow-in-right', 'Reports', 'bi bi-people-fill', 10, 6, 'Y', 'N');


INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(51, 'countingvenue', 'Venue', 'bi bi-building', 'Counting', 'bi bi-people-fill', 4, 5, 'Y', 'Y');


INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(52, 'countinghall', 'Hall', 'bi bi-grid', 'Counting', 'bi bi-people-fill', 4, 5, 'Y', 'Y');



/*

DROP TABLE if exists personnelexperience;

CREATE TABLE personneldesignations
(
  employeecode character varying(11) NOT NULL,
  personnelcategorycode smallint NOT NULL,
  entrydate timestamp with time zone NOT NULL DEFAULT now(),
  userid smallint NOT NULL,
  CONSTRAINT personneldesignationspkey PRIMARY KEY (employeecode, personnelcategorycode),

  CONSTRAINT personneldesignationsfk1 FOREIGN KEY (employeecode)
      REFERENCES personnel (employeecode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT personneldesignationsfk2 FOREIGN KEY (personnelcategorycode)
      REFERENCES masters.personnelcategories (personnelcategorycode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT personneldesignationsfk3 FOREIGN KEY (userid)
      REFERENCES users.useraccounts (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE personneldesignations
  OWNER TO elections;


INSERT INTO PERSONNELDESIGNATIONS SELECT EMPLOYEECODE ,PERSONNELCATEGORYCODE, ENTRYDATE , USERID FROM PERSONNEL ;
ALTER TABLE PERSONNEL RENAME COLUMN PERSONNELCATEGORYCODE TO PERSONNELCATEGORYCODEOLD;


/*
CREATE OR REPLACE VIEW vwpersonnel AS 
 SELECT eo.officecode AS electionofficecode,
    p.officecode,
    p.slno,
    p.employeecode,
    p.fullname,
    p.gender,
    p.dob,
    p.designation,
    p.basicpay,
    p.accountno,
    p.ifsccode,
    p.isgazettedofficer,
    p.epiccardno,
    p.acno,
    p.partno,
    p.mobileno,
    p.mobilenosm,
    p.isblo,
    p.ispwd,
    p.pwddetails,
    p.isexpectinglactating,
    p.isailing,
    p.personnelcategorycode,
    p.sensitivitycode,
    p.photograph,
    p.entrydate,
    p.userid
   FROM masters.offices eo
     JOIN masters.offices o ON eo.officecode::text = o.referenceofficecode::text
     JOIN personnel p ON o.officecode::text = p.officecode::text
      LEFT JOIN exemptedpersonnel vp ON p.employeecode::text = vp.employeecode::text
  WHERE vp.employeecode IS NULL;

ALTER TABLE vwpersonnel
  OWNER TO elections;
*/

