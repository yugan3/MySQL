 MySQL学习34道作业题

该数据有三张表：
部门表dept（deptno部门编号、dname部门名称、loc位置）

员工表emp（empno工号、ename员工姓名、job职位、mgr直属领导工号、hiredate入职日期、sal月薪、comm补贴、deptno部门编号）

薪水等级表salgrade（grade等级、losal区间下限、hisal区间上限）

0 练习数据

drop table if exits dept
drop table if exits emp
drop table if exits salgrade

create table dept(
		deptno int(10) primary key,
		dname varchar(14),
		loc varcahr(13)
	);
create table emp(
		empno int(10) primary key,
		ename varchar(12),
		job varchar(12),
		mgr varchar(14),
		hiredate date,
		sal int(5),
		comm int(5),
		deptno int(10),
	);
create table salgrade(
		grade int(11);
		losal int(11),
		hisal int(11),
	)


1 取得每个部门最高薪水的人员名称

select deptno, max(sal) as maxsal from emp group by deptno;
select e.ename from emp e join (select deptno, max(sal) as maxsal from emp group by deptno) o on o.maxsal = e.sal;

2 哪些人的薪水在部门平均薪水之上

select avg(sal),deptno as avgsal from emp group by deptno;
select e.ename from emp e join (select avg(sal) as avgsal from emp group by deptno) o on o.deptno = e.deptno and o.sal(avg) < e.sal;

3 取得部门中所有人的平均的薪水等级

select e.empname, e.deptno, s.grade from emp e left join grade g on e.sal between s.losal and s.hisal;
select avg(grade) from (select e.empname,e.deptno, s.grade from emp e left join grade g on e.sal between s.losal and s.hisal) group by deptno;

4 不准使用组函数Max，给出最高薪水（给出两种解决方案）

(1)降序：select sal from emp order by sal desc limit 1;
(2)select a.sal from a.emp join b.emp on a.sal > b.sal;

5 取得平均薪水最高的部门和部门编号

select avg(sal) as avgsal from emp group by deptno order by avgsal desc limit 1;
select avg(sal) as avgsal, deptno from emp having avgsal = (select avg(sal) as avgsal from emp group by deptno order by avgsal desc limit 1);

6 取得平均薪水最高的部门名称

select d.dname from dept d join (select avg(sal), deptno from emp having avgsal = (select avg(sal) as avgsal from emp group by deptno order by avgsal desc limit 1) m on d.deptno = m.deptno;

7 求平均薪水的等级最高的部门的部门名称

select avg(sal) as avgsal, deptno from emp group by deptno
select s.grade, t.avgsal, t.deptno from (select avg(sal) as avgsal, deptno from emp group by deptno) t join salgrade s on t.avgsal between s.losal and s.hisal order by t.avgsal desc limit 1
select d.dname from dept d join (select s.grade, t.avgsal, t.deptno from (select avg(sal) as avgsal, deptno from emp group by deptno) t join salgrade s on t.avgsal between s.losal and s.hisal order by t.avgsal desc limit 1
) a on a.deptno = d.deptno

8 取得比普通员工（员工代码没在mgr字段出现的）最高薪水更高的领导人姓名

select mgr from emp where mgr is not null;
select max(sal) from emp where ename not in (select mgr from emp where mgr is not null);
select mgr, sal from emp where mgr is not null;
select ename,sal from emp where sal>(select max(sal) from emp where ename not in (select mgr from emp where mgr is not null) and (select mgr from emp);

9 取得薪水最高的前五名员工

select ename from emp order by sal desc limit 5;

10 取得薪水最高的第六到第十名员工

select ename from emp order by sal desc limit 5,5

11 取得最后入职的5名员工

select ename from emp order by hiredate desc limit 5;

12 取得每个薪水等级有多少员工

select s.grade, e.ename, e.sal from salgrade s join emp e on e.sal between s.losal and s.hisal;
select count(empno) from (select s.grade, e.ename, e.sal from salgrade s join emp e on e.sal between s.losal and s.hisal) order by grade;

13 面试题

三张表：

学生表S：学号SNO，姓名SNAME
课程表C：课号CNO，课程名CNAME，课程老师CTEACHER
选课表SC：学号SNO，课号CNO，分数SCGRADE
(1)显示没选”黎明“老师课的学生
select cno from c where cteacher = "黎明";
select sno from sc where cno not in (select  cno from c where cteacher = "黎明");
select sname from s where sno in (select sno from sc where cno not in (select  cno from c where cteacher = "黎明"))；
(2)列出2门以上（含2门）不及格学生姓名及平均成绩
select s.sname, s.sno from s join sc where scgrade<60 group by s.sname having count(*)>=2;
select avg(scade) as number, sno from sc group by sno;
select t.number, m.sname from (select s.sname, s.sno from s join sc where scgrade<60 group by s.sname having count(*)>=2) m join (select avg(scade) as number, sno from sc group by sno) t on t.sno= m.sno;


(3)学过1号课程和2号课程的所有学生的姓名
select sno from sc where cno = 1;
select sno from sc where cno = 2;
select sname from s where sno in ((select sno from sc where cno = 1) and (select sno from sc where cno = 2));


14 列出所有员工及领导的姓名
select a.ename as empname , b.ename as leadername from emp a left join emp b where a.mgr = b.empno;

15 列出受雇日期早于其上级的所有员工的编号、姓名、部门名称

select a.ename, a.empno,a.deptno,a.hiredate,b.hiredate,b.empno from emp a left join emp b where a.mgr = b.empno and a.hiredate > b.hiredate;

16 列出部门名称和这些部门的员工信息，同时列出没有员工的部门

select e.*, d.dname from dept d left join emp e on e.deptno = d.deptno;

17 列出至少有5名员工的所有部门

select d.dname from dept d join emp e on d.deptno = e.deptno group by e.deptno having count(d.deptno)>=5;

18 列出薪水比simith多的所有员工信息

select sal from emp where ename = "smith";
select * from emp where sal>(select sal from emp where ename = "smith");

19 列出所有岗位为clerk的姓名及部门名称，部门人数

select ename, count(deptno) as number,deptno from emp group by deptno having job = 'clerk';
select d.dname, a.ename, a.number from dept d join (select ename, count(deptno) as number,deptno from emp group by deptno having job = 'clerk') a where a.deptno = d.deptno

20 列出最低薪水大于1500的各种工作及从事此工作的全部雇员人数

select min(sal), job, count(job) from emp group by job having min(sal)>1500;

21 列出在部门sales工作的员工的姓名，假定不知道销售部的部门编号

select deptno from dept where dname = 'sales';
select e.ename from emp e join (select deptno from dept where dname = 'sales') a on a.deptno = e.deptno;

22 列出薪水高于公司平均薪水的所有员工，所在部门，上级领导，薪水等级

select avg(sal) as number from emp 
select e.ename, e.deptno, e.mgr, s.grade from emp e join (select avg(sal) as number from emp) t on e.sal > t.number join salgrade s on e.sal between s.losal and s.hisal

23 列出与scott从事相同工作的所有员工及部门名称

select e.ename, d.dname from emp e join (select job from emp where ename = 'scott') t on t.job = e.job join dept d on d.deptno = e.deptno

24 列出薪水等于部门30中员工的薪水的其他员工的姓名和薪水

select distinct sal from emp where deptno = 30;
select ename, deptno, sal from emp where sal in (select distinct sal from emp where deptno = 30) and deptno != 30;

25 列出薪水高于部门30的全部员工的员工姓名，薪水，部门名称
select max(sal) from emp where deptno = 30;
select e.ename, e.sal, d.dname from emp e join dept d on d.deptno = e.deptno having e.sal > (select max(sal) from emp where deptno = 30);

26 列出在每个部门工作的员工数量，平均工资和平均服务期限

select count(e.deptno), avg(e.sal) from emp e right join dept d on e.deptno = d.deptno group by(d.deptno);

27 列出所有员工的姓名、部门名称、工资

 select e.ename, d.dname, e.sal from emp left join dept on e.deptno = d.deptno;

28 列出所有部门的详细信息和人数

select d.dname, d.deptno, d.loc, count(e.deptno) number from dept left join emp on e.deptno = d.deptno group by d.deptno;

29 列出各种工作的最低工资以及从事此工作的雇员姓名

select min(sal) minsal from emp group by job;
select e.job, e.ename, j.minsal from emp right join (select min(sal) minsal from emp group by job) j on j.minsal = e.sal;

30 列出各个部门的manager的最低薪水

select min(sal) minsal, ename, deptno from emp where job='manager' group by deptno;

31 列出员工的年工资，按年薪从低到高排序

select sal*12, ename from emp order by sal*12 asc;

32 求出员工领导的薪水超过3000的员工姓名和领导姓名

select enanme leadername,sal,empno leaderno from emp a join emp b on a.mgr = b.empno;
select e.ename, j.leadername from emp e join (select enanme leadername, empno leaderno from emp a join emp b on a.mgr = b.enanme) j on j.sal>3000;

33 求出部门名称中，带有‘s’字符的部门员工的工资合计，部门人数

select d.dame, count(e.empno), sum(e.sal) from dept d left join emp e on e.deptno = d.deptno group by e.deptno having d.dname like '%s%';

34 给任职时间超过30年的员工加薪10%
select * from emp where ((to_days(now()) - to_days(hiredate))/365) > 35;
update (select * from emp where ((to_days(now()) - to_days(hiredate))/365) > 35) set sal = sal*1.1;
