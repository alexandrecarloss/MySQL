use empregados;

#Questão 1
select d.dept_name 'Departamento', count(*) 'Quantidade'
from dept_emp d_ext
inner join departments d on d.dept_no = d_ext.dept_no
where d_ext.to_date = (select max(d_int.to_date)
						from dept_emp d_int
                        where d_int.emp_no = d_ext.emp_no)
group by d.dept_name;

select first_name, dept_name, salary from 
employees e 
inner join dept_emp de on e.emp_no = de.dept_no
inner join departments d on d.dept_no = de.dept_no
inner join salaries s on e.emp_no = s.emp_no
where first_name like 'a%' or first_name like 'm%'
or first_name like 's%';

create index idx_empregado_first_name on employees(first_name(1));
#Questão 2
select first_name from employees
where emp_no in(
select emp_no from salaries 
where salary in(
select max(salary)from salaries));

#Questão 3
select * from
dept_emp inner join employees
on dept_emp.emp_no = employees.emp_no

select salary from salaries order by salary desc;
