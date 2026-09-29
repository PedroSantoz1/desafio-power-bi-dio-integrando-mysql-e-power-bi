USE company_constraints;

-- Funcionários com departamento e gerente
CREATE OR REPLACE VIEW vw_funcionarios AS
SELECT
    e.Ssn,
    CONCAT(e.Fname, ' ', e.Lname) AS Nome_Completo,
    e.Bdate,
    e.Address,
    e.Sex,
    CAST(e.Salary AS DECIMAL(10,2)) AS Salary,
    d.Dname AS Departamento,
    CONCAT(g.Fname, ' ', g.Lname) AS Nome_Gerente
FROM employee e
LEFT JOIN departament d ON e.Dno = d.Dnumber
LEFT JOIN employee g ON e.Super_ssn = g.Ssn;


-- Departamento e localização
CREATE OR REPLACE VIEW vw_departamento_local AS
SELECT
    d.Dnumber,
    d.Dname AS Departamento,
    dl.Dlocation AS Localizacao,
    CONCAT(d.Dname, ' - ', dl.Dlocation) AS Departamento_Local
FROM departament d
LEFT JOIN dept_locations dl ON d.Dnumber = dl.Dnumber;


-- Total de horas por projeto
CREATE OR REPLACE VIEW vw_horas_por_projeto AS
SELECT
    p.Pnumber,
    p.Pname AS Projeto,
    p.Plocation AS Localizacao,
    p.Dnum AS Numero_Departamento,
    CAST(SUM(w.Hours) AS DECIMAL(10,2)) AS Total_Horas
FROM project p
LEFT JOIN works_on w ON p.Pnumber = w.Pno
GROUP BY
    p.Pnumber,
    p.Pname,
    p.Plocation,
    p.Dnum;


-- Quantidade de colaboradores por gerente
CREATE OR REPLACE VIEW vw_colaboradores_por_gerente AS
SELECT
    g.Ssn AS Ssn_Gerente,
    CONCAT(g.Fname, ' ', g.Lname) AS Nome_Gerente,
    COUNT(e.Ssn) AS Qtd_Colaboradores
FROM employee g
INNER JOIN employee e ON e.Super_ssn = g.Ssn
GROUP BY
    g.Ssn,
    g.Fname,
    g.Lname;


-- Departamentos e seus gerentes
CREATE OR REPLACE VIEW vw_departamentos_gerentes AS
SELECT
    d.Dnumber,
    d.Dname AS Departamento,
    d.Mgr_ssn,
    CONCAT(e.Fname, ' ', e.Lname) AS Nome_Gerente,
    d.Mgr_start_date,
    d.Dept_create_date
FROM departament d
LEFT JOIN employee e ON d.Mgr_ssn = e.Ssn;


-- Funcionários, projetos e horas trabalhadas
CREATE OR REPLACE VIEW vw_funcionarios_projetos AS
SELECT
    e.Ssn,
    CONCAT(e.Fname, ' ', e.Lname) AS Nome_Completo,
    p.Pnumber,
    p.Pname AS Projeto,
    CAST(w.Hours AS DECIMAL(10,2)) AS Horas
FROM works_on w
INNER JOIN employee e ON w.Essn = e.Ssn
INNER JOIN project p ON w.Pno = p.Pnumber;


-- Funcionários sem supervisor
SELECT
    Ssn,
    CONCAT(Fname, ' ', Lname) AS Funcionario,
    Super_ssn
FROM employee
WHERE Super_ssn IS NULL;


-- Departamentos sem gerente
SELECT *
FROM departament
WHERE Mgr_ssn IS NULL;


-- Verificação de valores nulos
SELECT *
FROM employee
WHERE
    Fname IS NULL
    OR Lname IS NULL
    OR Ssn IS NULL
    OR Salary IS NULL
    OR Dno IS NULL;
