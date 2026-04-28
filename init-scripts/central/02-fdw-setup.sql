-- ============================================
-- Central Coordinator: FDW Configuration
-- ============================================

-- 1. FOREIGN SERVERS
CREATE SERVER site1_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'site1', port '5432', dbname 'company_ny');

CREATE SERVER site2_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'site2', port '5432', dbname 'company_london');

CREATE SERVER site3_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'site3', port '5432', dbname 'company_tokyo');

-- 2. USER MAPPINGS
CREATE USER MAPPING FOR central_user
SERVER site1_server
OPTIONS (user 'site1_user', password 'site1pass');

CREATE USER MAPPING FOR central_user
SERVER site2_server
OPTIONS (user 'site2_user', password 'site2pass');

CREATE USER MAPPING FOR central_user
SERVER site3_server
OPTIONS (user 'site3_user', password 'site3pass');

-- 3. FOREIGN TABLES (Horizontal)
CREATE FOREIGN TABLE emp_dept5 (
  ssn VARCHAR(11),
  name VARCHAR(50),
  bdate DATE,
  address VARCHAR(100),
  salary NUMERIC(10,2),
  dno INTEGER
) SERVER site1_server
OPTIONS (schema_name 'public', table_name 'emp_dept5');

CREATE FOREIGN TABLE emp_dept4 (
  ssn VARCHAR(11),
  name VARCHAR(50),
  bdate DATE,
  address VARCHAR(100),
  salary NUMERIC(10,2),
  dno INTEGER
) SERVER site2_server
OPTIONS (schema_name 'public', table_name 'emp_dept4');

CREATE FOREIGN TABLE emp_dept1 (
  ssn VARCHAR(11),
  name VARCHAR(50),
  bdate DATE,
  address VARCHAR(100),
  salary NUMERIC(10,2),
  dno INTEGER
) SERVER site3_server
OPTIONS (schema_name 'public', table_name 'emp_dept1');

-- 4. FOREIGN TABLES (Vertical)
CREATE FOREIGN TABLE emp_personal_ny (
  ssn VARCHAR(11),
  name VARCHAR(50),
  bdate DATE,
  address VARCHAR(100)
) SERVER site1_server
OPTIONS (schema_name 'public', table_name 'emp_personal_ny');

CREATE FOREIGN TABLE emp_personal_london (
  ssn VARCHAR(11),
  name VARCHAR(50),
  bdate DATE,
  address VARCHAR(100)
) SERVER site2_server
OPTIONS (schema_name 'public', table_name 'emp_personal_london');

CREATE FOREIGN TABLE emp_personal_tokyo (
  ssn VARCHAR(11),
  name VARCHAR(50),
  bdate DATE,
  address VARCHAR(100)
) SERVER site3_server
OPTIONS (schema_name 'public', table_name 'emp_personal_tokyo');

CREATE FOREIGN TABLE emp_work_ny (
  ssn VARCHAR(11),
  salary NUMERIC(10,2),
  dno INTEGER
) SERVER site1_server
OPTIONS (schema_name 'public', table_name 'emp_work_ny');

CREATE FOREIGN TABLE emp_work_london (
  ssn VARCHAR(11),
  salary NUMERIC(10,2),
  dno INTEGER
) SERVER site2_server
OPTIONS (schema_name 'public', table_name 'emp_work_london');

CREATE FOREIGN TABLE emp_work_tokyo (
  ssn VARCHAR(11),
  salary NUMERIC(10,2),
  dno INTEGER
) SERVER site3_server
OPTIONS (schema_name 'public', table_name 'emp_work_tokyo');

-- 5. RECONSTRUCTION VIEWS
CREATE VIEW employee_full AS
SELECT * FROM emp_dept5
UNION ALL
SELECT * FROM emp_dept4
UNION ALL
SELECT * FROM emp_dept1;

CREATE VIEW employee_from_vertical AS
SELECT p.ssn, p.name, p.bdate, p.address, w.salary, w.dno
FROM (
  SELECT * FROM emp_personal_ny
  UNION ALL
  SELECT * FROM emp_personal_london
  UNION ALL
  SELECT * FROM emp_personal_tokyo
) p
JOIN (
  SELECT * FROM emp_work_ny
  UNION ALL
  SELECT * FROM emp_work_london
  UNION ALL
  SELECT * FROM emp_work_tokyo
) w ON p.ssn = w.ssn;
