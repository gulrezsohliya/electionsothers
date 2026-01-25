SELECT * FROM MASTERS.PAGES ORDER BY PAGEID

-- RESET PASSWORD 
/*
UPDATE USERS.USERACCOUNTS SET USERPASSWORD = 'RESETTED' WHERE USERID IN (
SELECT U.USERID FROM USERS.USERACCOUNTS U INNER JOIN USERS.USEROFFICES UO ON U.USERID =UO.USERID
WHERE EMAIL NOT IN 
(
'gulrez.sohliya@nic.in','lailarisa.singh@nic.in','pynbianglut.hadem@nic.in','ida.rymbai@nic.in','elekson.kurbah@nic.in','sengre.sangma@nic.in','shanborlang.warjri@nic.in',
'aldrin.synrem@nic.in','cliffland.k@nic.in','vineetkr.meena@nic.in','nongpoh@nic.in', 'rida.k@nic.in','pynbeit.passah@nic.in',
'goldene.kharmalki@gmail.com','feliwarjri@yahoo.in','asemkwt@gmail.com','georgie_wj@yahoo.com','feney.shabong@gmail.com','maycordelia@yahoo.com','ronal_kh@yahoo.com','manbhasynrem@gmail.com',
'swarup_banai@yahoo.co.in1','electiontura@gmail.com','sangma.tangman@outlook.com','elim.marak@gmail.com','mailcjosh@yahoo.com','ioh.diengdoh@gmail.com','chengit25@gmail.com',
'deramunmomin@gmail.com','susan1k@yahoo.com','dkharkyrshan22@gmail.com','lash07@gmail.com','maycordelia.election@gmail.com','dkharpuri@yahoo.com','parry_lyngdoh@yahoo.com')
);

DELETE FROM USERS.USERPAGES ;

DELETE FROM USERS.USERPAGES WHERE USERID IN (
SELECT U.USERID FROM USERS.USERACCOUNTS U INNER JOIN USERS.USEROFFICES UO ON U.USERID =UO.USERID
WHERE EMAIL IN 
(
'gulrez.sohliya@nic.in','lailarisa.singh@nic.in','pynbianglut.hadem@nic.in','ida.rymbai@nic.in','elekson.kurbah@nic.in','sengre.sangma@nic.in','shanborlang.warjri@nic.in',
'aldrin.synrem@nic.in','cliffland.k@nic.in','vineetkr.meena@nic.in','nongpoh@nic.in', 'rida.k@nic.in','pynbeit.passah@nic.in',
'goldene.kharmalki@gmail.com','feliwarjri@yahoo.in','asemkwt@gmail.com','georgie_wj@yahoo.com','feney.shabong@gmail.com','maycordelia@yahoo.com','ronal_kh@yahoo.com','manbhasynrem@gmail.com',
'swarup_banai@yahoo.co.in1','electiontura@gmail.com','sangma.tangman@outlook.com','elim.marak@gmail.com','mailcjosh@yahoo.com','ioh.diengdoh@gmail.com','chengit25@gmail.com',
'deramunmomin@gmail.com','susan1k@yahoo.com','dkharkyrshan22@gmail.com','lash07@gmail.com','maycordelia.election@gmail.com','dkharpuri@yahoo.com','parry_lyngdoh@yahoo.com')
);


*/


-- ASSIGNING ALL PAGES TO LAILA
	INSERT INTO USERS.USERPAGES
	SELECT ROW_NUMBER() OVER() + CASE WHEN (select max(userpageid) from USERS.USERPAGES) IS NULL THEN 1 ELSE (select max(userpageid) from USERS.USERPAGES) END , PAGEID, 
	22/* USERID*/
	FROM MASTERS.PAGES WHERE PAGEID NOT IN (SELECT PAGEID FROM USERS.USERPAGES WHERE USERID = 22);


--ASSIGN ROLL RELATED PAGES ELECTION USERS
INSERT INTO USERS.USERPAGES 
SELECT ROW_NUMBER() OVER() + (select max(userpageid) from USERS.USERPAGES), PAGEID, USERID
FROM USERS.USERACCOUNTS U , MASTERS.PAGES P
WHERE EMAIL IN (
'goldene.kharmalki@gmail.com','feliwarjri@yahoo.in','asemkwt@gmail.com','georgie_wj@yahoo.com','feney.shabong@gmail.com','maycordelia@yahoo.com','ronal_kh@yahoo.com','manbhasynrem@gmail.com',
'swarup_banai@yahoo.co.in1','electiontura@gmail.com','sangma.tangman@outlook.com','elim.marak@gmail.com','mailcjosh@yahoo.com','ioh.diengdoh@gmail.com','chengit25@gmail.com',
'deramunmomin@gmail.com','susan1k@yahoo.com','dkharkyrshan22@gmail.com','lash07@gmail.com','maycordelia.election@gmail.com','dkharpuri@yahoo.com','parry_lyngdoh@yahoo.com'
)
AND PAGEID NOT IN (3, 4,6)
AND PAGEID IN (55,56,57,58,29,59,60,61,62,63, 64,65,66,67)
AND (USERID, PAGEID) NOT IN (SELECT USERID, PAGEID FROM USERS.USERPAGES);



-- ASSIGN RANDOMIZATION PAGES 
INSERT INTO USERS.USERPAGES SELECT ROW_NUMBER() OVER() + (select max(userpageid) from USERS.USERPAGES), PAGEID, USERID
FROM USERS.USERACCOUNTS U , MASTERS.PAGES P WHERE EMAIL IN (
'pynbianglut.hadem@nic.in','ida.rymbai@nic.in','elekson.kurbah@nic.in','sengre.sangma@nic.in','shanborlang.warjri@nic.in',
'aldrin.synrem@nic.in','cliffland.k@nic.in','vineetkr.meena@nic.in','nongpoh@nic.in', 'rida.k@nic.in','pynbeit.passah@nic.in',
'goldene.kharmalki@gmail.com','feliwarjri@yahoo.in','asemkwt@gmail.com','georgie_wj@yahoo.com','feney.shabong@gmail.com','maycordelia@yahoo.com','ronal_kh@yahoo.com','manbhasynrem@gmail.com',
'swarup_banai@yahoo.co.in1','electiontura@gmail.com','sangma.tangman@outlook.com','elim.marak@gmail.com','mailcjosh@yahoo.com','ioh.diengdoh@gmail.com','chengit25@gmail.com',
'deramunmomin@gmail.com','susan1k@yahoo.com','dkharkyrshan22@gmail.com','lash07@gmail.com','maycordelia.election@gmail.com','dkharpuri@yahoo.com','parry_lyngdoh@yahoo.com'
)
AND PAGEID IN (1,2,5,7,8,9,10,11,12,13,14,15,16,17,21,24,26,28,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53)
AND PAGEID NOT IN (3, 4,6)
AND (USERID, PAGEID) NOT IN (SELECT USERID, PAGEID FROM USERS.USERPAGES);


-- SOME PAGES ARE INTENDED ONLY FOR SUPER USER
DELETE FROM USERS.USERPAGES WHERE USERID NOT IN (1, 22) AND PAGEID IN (3, 4,6);


--SHOW ACCESS
SELECT DISTINCT EMAIL,
OFFICENAME, EMAIL, FULLNAME, DESIGNATION, PARENT || ' - ' || SUBMENU, U.USERID 
FROM USERS.USERACCOUNTS U INNER JOIN USERS.USEROFFICES UO ON U.USERID = UO.USERID
INNER JOIN MASTERS.OFFICES O ON O.OFFICECODE = UO.OFFICECODE
INNER JOIN USERS.USERPAGES UPS ON U.USERID = UPS.USERID
INNER JOIN MASTERS.PAGES P ON P.PAGEID = UPS.PAGEID
WHERE EMAIL IN ('lailarisa.singh@nic.in')
--WHERE EMAIL NOT IN ('gulrez.sohliya@nic.in', 'lailarisa.singh@nic.in', 'dkharpuri@yahoo.com')
ORDER BY OFFICENAME, FULLNAME






/*
INSERT INTO MASTERS.PAGES VALUES (55,'migration/electoralroll','Electoral Roll Migration','bi bi-box-arrow-in-right','Migration','bi bi-archive-fill',1,1,'Y','N');
INSERT INTO MASTERS.PAGES VALUES (56,'migration/masterdata/parts','Masters # Parts Mapping','bi bi-box-arrow-in-right','Migration','bi bi-archive-fill',1,1,'Y','N');
INSERT INTO MASTERS.PAGES VALUES (57,'migration/electoralroll/actions','Electoral Roll Actions','bi bi-box-arrow-in-right','Migration','bi bi-archive-fill',1,1,'Y','N');
INSERT INTO MASTERS.PAGES VALUES (58,'migration/electoralroll/movementinfo','Electoral Roll Movement Information','bi bi-box-arrow-in-right','Migration','bi bi-archive-fill',1,1,'Y','N');
INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(29, 'reports/electoralroll', 'Electoral Roll Report', 'bi bi-list', 'Reports', 'bi bi-people-fill', 10, 9, 'Y', 'N');
INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(59, 'migration/electoralroll/actions/unlock', 'Unlock Electoral Roll Migration', 'bi bi-box-arrow-in-right', 'Migration', 'bi bi-archive-fill', 1, 1, 'Y', 'N');
INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(60, 'reports/controltable', 'View Control Tables', 'bi bi-list', 'Reports', 'bi bi-people-fill', 10, 9, 'Y', 'N');

INSERT INTO masters.pages
(pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard)
VALUES(61, 'migration/electoralroll/votermanagement', 'Voter List Management', 'bi bi-box-arrow-in-right', 'Migration', 'bi bi-archive-fill', 1, 1, 'Y', 'N');

UPDATE MASTERS.PAGES SET SUBMENU ='E Rolls Utility Reports' where submenu  ='View Control Tables';
UPDATE MASTERS.PAGES SET url='reports/erollsutilities' where url  ='reports/controltables';
UPDATE masters.pages SET showinmenu='N' WHERE pageid=56;


-- disable roll printing
--DELETE FROM USERS.USERPAGES WHERE PAGEID = 29 AND USERID <> 2;
*/
