select ename, job, deptno, hiredate
    from emp
    order  by hiredate;
    
select concat('Good', 'String') from dual;

select ename, hiredate
from emp
where hiredate = TO_DATE('1981/02/22', 'yyyy/mm/dd'); --날짜 변환 함수 

select ename, hiredate
from emp;

select ename, hiredate
from emp
where hiredate = '1981/02/22'; -- 가능 

select ename, TO_DATE(hiredate, 'YYYY"년" MM"월" DD"일"') HIREDATE
from emp;

select ename, NVL(TO_CHAR(mgr), 'No Manager')
from emp;

select ename, NVL(comm, 0) --null 값을 0으로 변환 
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
            CASE WHEN  JOB =  'ANALYST'   THEN SAL*1.10 --DECODE 보다 더 까다로움 그러나 성능을 높일 수 있다. 
                    WHEN  JOB =  'CLERK'       THEN SAL*1.15
                    WHEN  JOB =  'MANAGER' THEN SAL*1.20
                    ELSE SAL
                END AS REVISED_SALARY 
        FROM EMP;

-===========================
--다중열에서 GROUP BY 사용
SELECT DEPTNO, JOB, SUM(SAL)
FROM  EMP
GROUP BY DEPTNO, JOB;

SELECT DEPTNO ROLLUP() OVER(PARTITION BY  SAL)
FROM EMP;

SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY JOB;

--순서  FROM - WHERE - GROUP  - SELECT - 
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING AVG(SAL) > 2000
ORDER BY DEPTNO;

-SALES를 제외하고 급여의 합을 조회

SELECT JOB, SUM(SAL) PAYROLL
FROM EMP
WHERE JOB NOT LIKE 'SALES%' 
GROUP BY JOB 
HAVING SUM(SAL) > 5000;\

===================================
--연습문제(emp 테이블에서 1981년도 입사한 사원들의 deptno, job 별 급여 합계가 5000 이상인 deptno, job을 급여 합계가 많은 순으로 출력하세요)

SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
WHERE HIREDATE LIKE '81%'
GROUP BY DEPTNO, JOB
HAVING SUM(SAL)>= 5000
ORDER BY  SUM(SAL) DESC;

SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
WHERE TO_CHAR(HIREDATE, 'YYYY') = '1981' --'1981'과 1981 부하 차이가 많이 날수 있다. 꼭 맞춰주기 
GROUP BY DEPTNO, JOB
HAVING SUM(SAL)>= 5000
ORDER BY  SUM(SAL) DESC;
--------------------------------------
--근무중인 직원이 4명 이상인 부서
SELECT DEPTNO, COUNT(*)
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(*) >= 4;

===============================
--PIVOT 

SELECT E.EMPNO, E.ENAME, E.SAL, E.DNAME, E.LOC, E.DEPTNO
FROM EMP E , DEPT D
WHERE E.DEPTNO = D.DEPTNO;

-- ANSI SQL의 INNER JOIN 

SELECT E.EMPNO, E.ENAME, E.SAL, D.DNAME, D.LOC, E.DEPTNO
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

-- SCOTT의 부서명 조회 
SELECT E.EMPNO, E.ENAME, E.SAL, D.DNAME, D.LOC, E.DEPTNO
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.ENAME ='SCOTT';
=================================
-- 뉴욕에 근무하는 사원의 이름과 급여 조회 
SELECT  E.ENAME, E.SAL, D.LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE D.LOC ='NEW YORK';

SELECT * FROM DEPT;
-- ACCOUNTING 부서 소속 사원의 이름과 입사일 
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
        GROUPING(EMPNO) GROUPIN_EMPNO, -- 사용되면 0. 아니면 1 
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

/*1. 학생 테이블 (student) 과 교수 테이블 (professor) 을 join 하여 
학생의 이름과 지도교수번호, 지도교수 이름을 출력하세요*/

select * from department;
select * from professor;
desc student;
desc professor;

select s.name, s.profno, p.name as proname
from student s 
join professor p
on s.profno = p.profno;

/*학생 테이블(student)과 학과 테이블(department) , 교수 테이블(professor) 을 Join하여
학생의 이름과 학과이름, 지도교수 이름을 출력하세요*/

select s.name, p.name as proname, d.dname
from student s 
join professor p
on s.profno = p.profno
join department d
on s.deptno1 = d.deptno;


/*customer 테이블과 gift 테이블을 Join하여 
고객의 마일리지 포인트별로 받을 수 있는 상품을 조회하여 고객의 이름과 상품 명을 출력하세요*/
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

/* 위 예제에서 조회한 상품의 이름과 필요 수량이 몇 개 인지 조회하세요*/

select g.gname as goods, count(*)
from customer c
join gift g
on g.g_start < = c.point and g.g_end>= c.point
group by g.gname ;


/*customer 테이블과 gift 테이블을 Join하여 
고객이 자기 포인트보다 낮은 포인트의 상품 중 한가지를 선택할 수 있다고 할 때 
산악용 자전거를 선택할 수 있는 고객명과 포인트, 상품명을 출력하세요.*/

select c.gname, c.point, g.gname as goods
from customer c
join gift g
on  g.g_start < = c.point 
where g.gname = 'Mountain bike';

select * from gift;
;