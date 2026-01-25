select AC.ACNO, ACNAME, AP.PARTNO, PARTNAME, ER.SLNOINPART, CHOUSENO, FIRSTNAME, SURNAME, RELATIONFIRSTNAME, RELATIONSURNAME, DOB
from masters.assemblyconstituencies ac, masters.acparts ap, imports.electoralrolls er
WHERE ac.acno = ap.acno 
and ap.acno = er.acno and ap.partno = er.psno and 
TRIM(UPPER(FIRSTNAME)) LIKE '%REEN%'
AND TRIM(UPPER(SURNAME)) LIKE '%NONGRUM%'
ORDER BY AC.ACNO, AP.PARTNO, DOB
limit 10 