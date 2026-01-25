INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (5, 'district', 'Districts', 'bi bi-geo-fill', 'Masters', 'bi bi-database-fill-gear', 2, 3, 'Y', 'Y');
INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (4, 'state', 'States', 'bi bi-geo-alt', 'Masters', 'bi bi-database-fill-gear', 2, 2, 'Y', 'Y');
INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (3, 'page', 'Pages', 'bi bi-grid', 'Masters', 'bi bi-database-fill-gear', 2, 1, 'Y', 'Y');
INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (1, 'user', 'User Accounts', 'bi bi-person-fill', 'User Management', 'bi bi-people-fill', 2, 1, 'Y', 'Y');
INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (6, 'office', 'Offices', 'bi bi-building', 'Masters', 'bi bi-database-fill-gear', 2, 6, 'Y', 'Y');
INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (7, 'userOffice', 'User Offices', 'bi bi-building', 'User Management', 'bi bi-people-fill', 2, 4, 'Y', 'Y');
INSERT INTO masters.pages (pageid, url, submenu, submenuicon, parent, parenticon, parentorder, submenuorder, showinmenu, showindashboard) VALUES (2, 'userPage', 'User Pages', 'bi bi-box-arrow-in-right', 'User Management', 'bi bi-people-fill', 2, 2, 'Y', 'Y');


INSERT INTO users.useraccounts (userid, fullname, email, userpassword, mobilenumber, enabled, userrole, entrydate) VALUES (1, 'admin', 'admin@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '1111111111', 'Y', 'admin', '2023-07-13 00:00:00+05:30');


INSERT INTO users.userpages (userpageid, pageid, userid) VALUES (1, 1, 1);
INSERT INTO users.userpages (userpageid, pageid, userid) VALUES (2, 2, 1);
INSERT INTO users.userpages (userpageid, pageid, userid) VALUES (3, 3, 1);
INSERT INTO users.userpages (userpageid, pageid, userid) VALUES (4, 4, 1);
INSERT INTO users.userpages (userpageid, pageid, userid) VALUES (5, 5, 1);
INSERT INTO users.userpages (userpageid, pageid, userid) VALUES (6, 6, 1);
INSERT INTO users.userpages (userpageid, pageid, userid) VALUES (7, 7, 1);