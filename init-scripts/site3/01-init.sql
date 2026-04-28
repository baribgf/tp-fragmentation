-- ============================================
-- Site 3: Tokyo -- Horizontal Fragment
-- Employees from Department 1
-- ============================================

CREATE TABLE emp_dept1 (
  ssn VARCHAR(11) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  bdate DATE,
  address VARCHAR(100),
  salary NUMERIC(10,2),
  dno INTEGER NOT NULL CHECK (dno = 1)
);

INSERT INTO emp_dept1 VALUES
('888-88-8888', 'Hiro Tanaka', '1990-08-11', '1-1 Shibuya, Tokyo', 78000.00, 1),
('999-99-9999', 'Yuki Sato', '1994-02-28', '3-5 Shinjuku, Tokyo', 59000.00, 1),
('101-01-0101', 'Ken Nakamura', '1986-06-17', '7-2 Ginza, Tokyo', 85000.00, 1);

-- Vertical fragment: personal
CREATE TABLE emp_personal_tokyo (
  ssn VARCHAR(11) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  bdate DATE,
  address VARCHAR(100)
);

INSERT INTO emp_personal_tokyo
SELECT ssn, name, bdate, address FROM emp_dept1;

-- Vertical fragment: work
CREATE TABLE emp_work_tokyo (
  ssn VARCHAR(11) PRIMARY KEY,
  salary NUMERIC(10,2),
  dno INTEGER NOT NULL
);

INSERT INTO emp_work_tokyo
SELECT ssn, salary, dno FROM emp_dept1;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO site3_user;
