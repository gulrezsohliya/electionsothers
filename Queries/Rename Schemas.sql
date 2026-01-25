drop schema elections1 cascade;
drop schema imports1 cascade;
drop schema masters1 cascade;
drop schema users1 cascade;
--drop schema xelectionsform121 cascade;
drop schema logs1 cascade;


ALTER SCHEMA ELECTIONS RENAME TO ELECTIONS1;
ALTER SCHEMA IMPORTS RENAME TO IMPORTS1;
ALTER SCHEMA MASTERS RENAME TO MASTERS1;
ALTER SCHEMA USERS RENAME TO USERS1;
--ALTER SCHEMA xelectionsform12 RENAME TO xelectionsform121;
ALTER SCHEMA logs RENAME TO logs1;


