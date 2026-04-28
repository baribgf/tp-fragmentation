-- ============================================
-- Site 1: New York -- Horizontal Fragment
-- Employees from Department 5
-- ============================================

CREATE TABLE emp_dept5 (
  ssn VARCHAR(11) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  bdate DATE,
  address VARCHAR(100),
  salary NUMERIC(10,2),
  dno INTEGER NOT NULL CHECK (dno = 5)
);

INSERT INTO emp_dept5 VALUES
('111-11-1111', 'Alice Johnson', '1990-03-15', '123 Broadway, New York', 75000.00, 5),
('222-22-2222', 'Bob Smith', '1988-07-22', '456 Park Ave, New York', 68000.00, 5),
('333-33-3333', 'Carol Williams', '1992-11-08', '789 5th Ave, New York', 72000.00, 5),
('444-44-4444', 'David Brown', '1985-01-30', '321 Wall St, New York', 80000.00, 5);

-- Vertical fragment: personal
CREATE TABLE emp_personal_ny (
  ssn VARCHAR(11) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  bdate DATE,
  address VARCHAR(100)
);

INSERT INTO emp_personal_ny
SELECT ssn, name, bdate, address FROM emp_dept5;

-- Vertical fragment: work
CREATE TABLE emp_work_ny (
  ssn VARCHAR(11) PRIMARY KEY,
  salary NUMERIC(10,2),
  dno INTEGER NOT NULL
);

INSERT INTO emp_work_ny
SELECT ssn, salary, dno FROM emp_dept5;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO site1_user;
