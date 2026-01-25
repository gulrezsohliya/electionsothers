-- Function: erolls.getvoterslist(integer, integer, integer)

-- DROP FUNCTION erolls.getvoterslist(integer, integer, integer);


ALTER TABLE EROLLS.SUPPLEMENTS DROP CONSTRAINT supplementsuq1 ;
ALTER TABLE EROLLS.SUPPLEMENTS DROP CONSTRAINT supplementsuq2 ;
ALTER TABLE EROLLS.SUPPLEMENTS ADD CONSTRAINT supplementsuq1 UNIQUE (acno, partno, firstname, lastname, age, statustype, revisionno);
ALTER TABLE EROLLS.SUPPLEMENTS ADD CONSTRAINT supplementsuq2 UNIQUE (acno, partno, firstname, lastname, age, formtype, revisionno);
ALTER TABLE EROLLS.SUPPLEMENTS DROP CONSTRAINT supplementsfkacpartslno  ;   


ALTER TABLE EROLLS.ELECTORALROLLSSUP DROP CONSTRAINT electoralrollssupuq1 ;
ALTER TABLE EROLLS.ELECTORALROLLSSUP DROP CONSTRAINT electoralrollssupuq2 ;
ALTER TABLE EROLLS.ELECTORALROLLSSUP ADD CONSTRAINT electoralrollssupuq1 UNIQUE (acno, partno, firstname, lastname, age, statustype, revisionno);
ALTER TABLE EROLLS.ELECTORALROLLSSUP ADD CONSTRAINT electoralrollssupuq2 UNIQUE (acno, partno, firstname, lastname, age, formtype, revisionno);
ALTER TABLE EROLLS.ELECTORALROLLSSUP DROP CONSTRAINT electoralrollssupfkacpartslno  ;   

CREATE TABLE erolls.acpartslock
(
  acno smallint NOT NULL,
  partno smallint NOT NULL,
  revisionno smallint NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT acpartslockpkey PRIMARY KEY (acno, partno, revisionno),
  CONSTRAINT acpartslockfk1 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT

)
WITH (
  OIDS=FALSE
);
ALTER TABLE erolls.acpartslock   OWNER TO elections;



