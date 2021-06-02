select ename, job, deptno, hiredate
    from emp
    order  by hiredate;
    
select concat('Good', 'String') from dual;

select ename, hiredate
from emp
where hiredate = TO_DATE('1981/02/22', 'yyyy/mm/dd'); --��¥ ��ȯ �Լ� 

select ename, hiredate
from emp;

select ename, hiredate
from emp
where hiredate = '1981/02/22'; -- ���� 

select ename, TO_DATE(hiredate, 'YYYY"��" MM"��" DD"��"') HIREDATE
from emp;

select ename, NVL(TO_CHAR(mgr), 'No Manager')
from emp;

select ename, NVL(comm, 0) --null ���� 0���� ��ȯ 
from emp;

select ename,comm
from emp;

select ename, sal, comm, (sal*12)+nvl(comm,0)
from emp;
------------------------------------------------
--DECODE VS CASE
SELECT JOB, SAL, 
            DECODE( JOB, 'ANALYST', SAL*1.10,
                                'CLERK' , SAL*1.15,
                                'MANAGER', SAL*1.20, SAL)
                AS REVISED_SALARY
        FROM EMP;

SELECT JOB, SAL, 
            CASE WHEN  JOB =  'ANALYST'   THEN SAL*1.10 --DECODE ���� �� ��ٷο� �׷��� ������ ���� �� �ִ�. 
                    WHEN  JOB =  'CLERK'       THEN SAL*1.15
                    WHEN  JOB =  'MANAGER' THEN SAL*1.20
                    ELSE SAL
                END AS REVISED_SALARY 
        FROM EMP;

-===========================
--���߿����� GROUP BY ���
SELECT DEPTNO, JOB, SUM(SAL)
FROM  EMP
GROUP BY DEPTNO, JOB;

SELECT DEPTNO ROLLUP() OVER(PARTITION BY  SAL)
FROM EMP;

SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY JOB;

--����  FROM - WHERE - GROUP  - SELECT - 
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING AVG(SAL) > 2000
ORDER BY DEPTNO;

-SALES�� �����ϰ� �޿��� ���� ��ȸ

SELECT JOB, SUM(SAL) PAYROLL
FROM EMP
WHERE JOB NOT LIKE 'SALES%' 
GROUP BY JOB 
HAVING SUM(SAL) > 5000;\

===================================
--��������(emp ���̺��� 1981�⵵ �Ի��� ������� deptno, job �� �޿� �հ谡 5000 �̻��� deptno, job�� �޿� �հ谡 ���� ������ ����ϼ���)

SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
WHERE HIREDATE LIKE '81%'
GROUP BY DEPTNO, JOB
HAVING SUM(SAL)>= 5000
ORDER BY  SUM(SAL) DESC;

SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
WHERE TO_CHAR(HIREDATE, 'YYYY') = '1981' --'1981'�� 1981 ���� ���̰� ���� ���� �ִ�. �� �����ֱ� 
GROUP BY DEPTNO, JOB
HAVING SUM(SAL)>= 5000
ORDER BY  SUM(SAL) DESC;
--------------------------------------
--�ٹ����� ������ 4�� �̻��� �μ�
SELECT DEPTNO, COUNT(*)
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(*) >= 4;

===============================
--PIVOT 

SELECT E.EMPNO, E.ENAME, E.SAL, E.DNAME, E.LOC, E.DEPTNO
FROM EMP E , DEPT D
WHERE E.DEPTNO = D.DEPTNO;

-- ANSI SQL�� INNER JOIN 

SELECT E.EMPNO, E.ENAME, E.SAL, D.DNAME, D.LOC, E.DEPTNO
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

-- SCOTT�� �μ��� ��ȸ 
SELECT E.EMPNO, E.ENAME, E.SAL, D.DNAME, D.LOC, E.DEPTNO
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.ENAME ='SCOTT';
=================================
-- ���忡 �ٹ��ϴ� ����� �̸��� �޿� ��ȸ 
SELECT  E.ENAME, E.SAL, D.LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE D.LOC ='NEW YORK';

SELECT * FROM DEPT;
-- ACCOUNTING �μ� �Ҽ� ����� �̸��� �Ի��� 
SELECT  E.ENAME, HIREDATE , D.DNAME
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE D.DNAME ='ACCOUNTING';


SELECT 
EMPNO, ENAME, SUM(SAL)
FROM EMP
GROUP BY
            GROUPING SETS
            (
            (EMPNO, ENAME),
            (EMPNO), 
            (ENAME),
            ()
            );
 


SELECT 
        GROUPING(EMPNO) GROUPIN_EMPNO, -- ���Ǹ� 0. �ƴϸ� 1 
        GROUPING(ENAME) GROUPIN_ENAME,
        EMPNO, ENAME, SUM(SAL)
FROM EMP
GROUP BY
            GROUPING SETS
            (
            (EMPNO, ENAME),
            (EMPNO), 
            (ENAME),
            ()
            );

=========
--OVER() 
SELECT 
EMPNO, ENAME, SUM(SAL) OVER(PARTITION BY DEPTNO)
FROM EMP;

SELECT 
EMPNO, ENAME, JOB, ROW_NUMBER()  OVER(PARTITION BY JOB ORDER BY SAL)
FROM EMP;

/*1. �л� ���̺� (student) �� ���� ���̺� (professor) �� join �Ͽ� 
�л��� �̸��� ����������ȣ, �������� �̸��� ����ϼ���*/

select * from department;
select * from professor;
desc student;
desc professor;

select s.name, s.profno, p.name as proname
from student s 
join professor p
on s.profno = p.profno;

/*�л� ���̺�(student)�� �а� ���̺�(department) , ���� ���̺�(professor) �� Join�Ͽ�
�л��� �̸��� �а��̸�, �������� �̸��� ����ϼ���*/

select s.name, p.name as proname, d.dname
from student s 
join professor p
on s.profno = p.profno
join department d
on s.deptno1 = d.deptno;


/*customer ���̺�� gift ���̺��� Join�Ͽ� 
���� ���ϸ��� ����Ʈ���� ���� �� �ִ� ��ǰ�� ��ȸ�Ͽ� ���� �̸��� ��ǰ ���� ����ϼ���*/
select c.gname, c.point, g.gname as goods
from customer c
join gift g
on g.g_start < = c.point and g.g_end>= c.point;

---------------
select c.gname, c.point, g.gname as goods
from customer c
join gift g
on c.point between g.g_start and g.g_end;

select * from gift;
select * from customer;

/* �� �������� ��ȸ�� ��ǰ�� �̸��� �ʿ� ������ �� �� ���� ��ȸ�ϼ���*/

select g.gname as goods, count(*)
from customer c
join gift g
on g.g_start < = c.point and g.g_end>= c.point
group by g.gname ;


/*customer ���̺�� gift ���̺��� Join�Ͽ� 
���� �ڱ� ����Ʈ���� ���� ����Ʈ�� ��ǰ �� �Ѱ����� ������ �� �ִٰ� �� �� 
��ǿ� �����Ÿ� ������ �� �ִ� ����� ����Ʈ, ��ǰ���� ����ϼ���.*/

select c.gname, c.point, g.gname as goods
from customer c
join gift g
on  g.g_start < = c.point 
where g.gname = 'Mountain bike';

select * from gift;
;