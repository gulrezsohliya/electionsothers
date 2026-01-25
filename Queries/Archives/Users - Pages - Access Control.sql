select * from MASTERS.OFFICES O INNER JOIN USERS.USEROFFICES UO 
ON O.OFFICECODE  = UO.OFFICECODE 
INNER JOIN USERS.USERACCOUNTS UA ON UA.USERID = UO.USERID
ORDER BY OFFICENAME

--creating users 
--INSERT INTO users.useraccounts (userid, fullname, email, userpassword, mobilenumber, enabled, userrole, entrydate) VALUES (1, 'admin', 'admin@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '1111111111', 'Y', 'admin', '2023-07-13 00:00:00+05:30');
-- creating pages



INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (
(select max(pageid) +1 from MASTERS.PAGES), 
'inittada', 'T.A./D.A. Rates', 'bi bi-grid', 'Masters', 'bi bi-database-fill-gear', 2, 1, 'Y', 'Y');




--access control


INSERT INTO USERS.USERPAGES
SELECT ROW_NUMBER() OVER() + (select max(userpageid) from USERS.USERPAGES), PAGEID, 
1/* USERID*/
FROM MASTERS.PAGES WHERE PAGEID NOT IN (SELECT PAGEID FROM USERS.USERPAGES)