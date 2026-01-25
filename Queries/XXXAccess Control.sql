--UPDATE MASTERS.PAGES SET SHOWINDASHBOARD = 'N';

-- ASSIGNING TO PAGES TO KIKI
. 
-- ASSIGNING TO PAGES TO LAILA
	INSERT INTO USERS.USERPAGES
	SELECT ROW_NUMBER() OVER() + (select max(userpageid) from USERS.USERPAGES), PAGEID, 
	22/* USERID*/
	FROM MASTERS.PAGES WHERE PAGEID NOT IN (SELECT PAGEID FROM USERS.USERPAGES WHERE USERID = 22);


--ASSIGN PAGES TO NIC & ELECTION USERS
INSERT INTO USERS.USERPAGES 
SELECT ROW_NUMBER() OVER() + (select max(userpageid) from USERS.USERPAGES), PAGEID, USERID
FROM USERS.USERACCOUNTS U , MASTERS.PAGES P
WHERE EMAIL IN (
'elliber.marak@nic.in','rajat.gupta16@nic.in','shiv.kumar92@nic.in','osterwell.swer@nic.in','pynbianglut.hadem@nic.in','ida.rymbai@nic.in','elekson.kurbah@nic.in','sengre.sangma@nic.in','shanborlang.warjri@nic.in',
'aldrin.synrem@nic.in','cliffland.k@nic.in','wanraplin.rynjah@nic.in','rajhans.gondane@nic.in','pyndaplang.nongpiur@nic.in','pynbeit.passah@nic.in', 'elliber.marak@nic.in' 

'goldene.kharmalki@gmail.com1','feliwarjri@yahoo.in1','asemkwt@gmail.com1','georgie_wj@yahoo.com1','feney.shabong@gmail.com1','maycordelia@yahoo.com1','ronal_kh@yahoo.com1','manbhasynrem@gmail.com1',
'jr_marak@yahoo.co.in1','swarup_banai@yahoo.co.in1','electiontura@gmail.com1','sangma.tangman@outlook.com1','elim.marak@gmail.com1','mailcjosh@yahoo.com1','ioh.diengdoh@gmail.com1','chengit25@gmail.com1',
'deramunmomin@gmail.com1','susan1k@yahoo.com','dkharkyrshan22@gmail.com1'
)
AND PAGEID NOT IN (3, 4,6)
AND (USERID, PAGEID) NOT IN (SELECT USERID, PAGEID FROM USERS.USERPAGES);

-- SOME PAGES ARE INTENDED ONLY FOR SUPER USER
DELETE FROM USERS.USERPAGES WHERE USERID NOT IN (1, 22) AND PAGEID IN (3, 4,6);


/*
DELETE FROM USERS.USERPAGES WHERE PAGEID IN (
SELECT P.PAGEID
FROM MASTERS.PAGES P INNER JOIN USERS.USERPAGES UPA ON P.PAGEID = UPA.PAGEID
INNER JOIN USERS.USERACCOUNTS UA ON UA.USERID = UPA.USERID
AND UPA.PAGEID IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,14, 16,20, 21,26, 40, 44,45,46, 47)
)
*/