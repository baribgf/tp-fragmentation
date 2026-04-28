-- ============================================
-- Site 2: London -- Horizontal Fragment
-- Employees from Department 4
-- ============================================

CREATE TABLE emp_dept4 (
  ssn VARCHAR(11) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  bdate DATE,
  address VARCHAR(100),
  salary NUMERIC(10,2),
  dno INTEGER NOT NULL CHECK (dno = 4)
);

INSERT INTO emp_dept4 VALUES
('555-55-5555', 'Emma Taylor', '1991-05-20', '10 Baker St, London', 65000.00, 4),
('666-66-6666', 'Frank Wilson', '1987-09-14', '22 Oxford St, London', 71000.00, 4),
('777-77-7777', 'Grace Davis', '1993-12-03', '55 Regent St, London', 62000.00, 4);

-- Vertical fragment: personal
CREATE TABLE emp_personal_london (
  ssn VARCHAR(11) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  bdate DATE,
  address VARCHAR(100)
);

INSERT INTO emp_personal_london
SELECT ssn, name, bdate, address FROM emp_dept4;

-- Vertical fragment: work
CREATE TABLE emp_work_london (
  ssn VARCHAR(11) PRIMARY KEY,
  salary NUMERIC(10,2),
  dno INTEGER NOT NULL
);

INSERT INTO emp_work_london
SELECT ssn, salary, dno FROM emp_dept4;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO site2_user;
