-- View: vwpersonnel

 DROP VIEW vwpersonnel;
CREATE OR REPLACE VIEW vwpersonnel AS 
 SELECT EO.OFFICECODE AS ELECTIONOFFICECODE, p.officecode,
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
    p.userid FROM 
    MASTERS.OFFICES EO INNER JOIN MASTERS.OFFICES O ON EO.OFFICECODE = O.REFERENCEOFFICECODE
   INNER JOIN personnel p ON O.OFFICECODE = P.OFFICECODE
     LEFT OUTER JOIN exemptedpersonnel vp ON p.employeecode::text = vp.employeecode::text
WHERE vp.employeecode IS NULL;


ALTER TABLE vwpersonnel
  OWNER TO rpa3;
