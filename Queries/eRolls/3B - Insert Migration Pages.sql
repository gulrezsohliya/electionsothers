
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


-- ASSIGNING TO PAGES TO LAILA
	INSERT INTO USERS.USERPAGES
	SELECT ROW_NUMBER() OVER() + (select max(userpageid) from USERS.USERPAGES), PAGEID, 
	22/* USERID*/
	FROM MASTERS.PAGES WHERE PAGEID NOT IN (SELECT PAGEID FROM USERS.USERPAGES WHERE USERID = 22);

UPDATE MASTERS.PAGES SET SUBMENU ='E Rolls Utility Reports' where submenu  ='View Control Tables';
UPDATE MASTERS.PAGES SET url='reports/erollsutilities' where url  ='reports/controltables';
UPDATE masters.pages SET showinmenu='N' WHERE pageid=56;

--ASSIGN MIGRATION PAGES TO ELECTION USERS

INSERT INTO USERS.USERPAGES 
SELECT ROW_NUMBER() OVER() + (select max(userpageid) from USERS.USERPAGES), PAGEID, USERID
FROM USERS.USERACCOUNTS U , MASTERS.PAGES P
WHERE EMAIL IN (
'goldene.kharmalki@gmail.com','feliwarjri@yahoo.in1','asemkwt@gmail.com','georgie_wj@yahoo.com','feney.shabong@gmail.com','maycordelia@yahoo.com','ronal_kh@yahoo.com','manbhasynrem@gmail.com',
'swarup_banai@yahoo.co.in1','electiontura@gmail.com','sangma.tangman@outlook.com','elim.marak@gmail.com','mailcjosh@yahoo.com','ioh.diengdoh@gmail.com','chengit25@gmail.com',
'deramunmomin@gmail.com','susan1k@yahoo.com','dkharkyrshan22@gmail.com'
)
AND PAGEID NOT IN (3, 4,6)
AND PAGEID IN (55,56,57,58,29,59,60)
AND (USERID, PAGEID) NOT IN (SELECT USERID, PAGEID FROM USERS.USERPAGES);



