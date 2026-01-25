CREATE TABLE sources.assemblyconstituencies
(
  statecode character varying(3),
  districtcode smallint NOT NULL,
  acno smallint NOT NULL,
  acname character varying(50) NOT NULL,
  acnamev character varying(50) NOT NULL,
  actype character varying(50) NOT NULL,
  pcno smallint NOT NULL,
  servicevoterpartno smallint,
  CONSTRAINT acspkey PRIMARY KEY (acno),
  CONSTRAINT acsfk1 FOREIGN KEY (districtcode)
      REFERENCES masters.districts (districtcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT acsfk2 FOREIGN KEY (pcno)
      REFERENCES masters.parliamentaryconstituencies (pcno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT acsukey1 UNIQUE (acname)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sources.assemblyconstituencies
  OWNER TO elections;


CREATE TABLE sources.acparts
(
  acno smallint NOT NULL,
  partno smallint NOT NULL,
  partname character varying(255) NOT NULL,
  fvttype character varying(1),
  psbuildingsid integer NOT NULL,
  partvotercapacity integer NOT NULL,
  villagesinpart character varying(255),
  mainvillage character varying(255) NOT NULL,
  patwarino character varying(255),
  tahsilno character varying(255),
  rino character varying(255),
  CONSTRAINT acpartspkey PRIMARY KEY (acno, partno),
  CONSTRAINT acpartsfk1 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT acpartsfk2 FOREIGN KEY (sensitivitycode)
      REFERENCES masters.sensitivities (sensitivitycode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT personnelfkacparts FOREIGN KEY (acno, partno)
      REFERENCES masters.acparts (acno, partno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT acpartscheck2 CHECK (fvttype::text = ANY (ARRAY['V'::character varying::text, 'T'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sources.acparts
  OWNER TO elections;


DROP TABLE sources.pollingstations;


CREATE TABLE sources.pollingstations
(
  acno smallint NOT NULL,
  partno smallint NOT NULL,
  psno smallint NOT NULL,
  auxypscount smallint NOT NULL DEFAULT 0,
  isauxyps character varying(1) NOT NULL,
  psgendertype character varying(1) NOT NULL,
  pslocationtype character varying(1) NOT NULL,
  pslocationno integer NOT NULL,
  pslocationid integer NOT NULL,
  pslocationcategory character varying(1) NOT NULL,
  psname character varying(255) NOT NULL,
  psbuildingname character varying(255) NOT NULL,
  psaddress character varying(255) NOT NULL,
  pslatlong character varying(255) NOT NULL,
  CONSTRAINT psdetailspkey PRIMARY KEY (acno, partno),
  CONSTRAINT psdetailsukey UNIQUE (acno, partno, psno),
  CONSTRAINT personnelfkpsdetails FOREIGN KEY (acno, partno)
      REFERENCES masters.acparts (acno, partno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT psdetailsfk1 FOREIGN KEY (acno)
      REFERENCES masters.assemblyconstituencies (acno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT psdetailscheck1 CHECK (isauxyps::text = ANY (ARRAY['M'::character varying::text, 'F'::character varying::text, 'O'::character varying::text])),
  CONSTRAINT psdetailscheck2 CHECK (psgendertype::text = ANY (ARRAY['M'::character varying::text, 'F'::character varying::text, 'O'::character varying::text])),
  CONSTRAINT psdetailscheck3 CHECK (pslocationtype::text = ANY (ARRAY['R'::character varying::text, 'U'::character varying::text])),
  CONSTRAINT psdetailscheck4 CHECK (pslocationcategory::text = ANY (ARRAY['R'::character varying::text, 'U'::character varying::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sources.pollingstations OWNER TO elections;


DROP TABLE MASTERS.BLOCKS;

CREATE TABLE masters.blocks
(
  districtcode smallint NOT NULL,
  sdocode smallint ,
  blockcode smallint NOT NULL,
  blockname character varying(255) NOT NULL,
  userid smallint NOT NULL,
  entrydate timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT blockspkey PRIMARY KEY (districtcode, blockcode),
  --CONSTRAINT blocksukey UNIQUE (blockname),  
  CONSTRAINT blocksfk1 FOREIGN KEY (districtcode)
        REFERENCES masters.districts (districtcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT blocksfk2 FOREIGN KEY (sdocode)
      REFERENCES masters.districts (districtcode) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE masters.blocks   OWNER TO elections;


