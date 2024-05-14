/* A) crie views para:
1) Mostrar o nome completo, salário, cargo e dapartamento atual de cada funcionário
B) Criar stored procedures para:
1 - Mostrar os funcionários de determinado sexo e determinado departamento
Parâmetros sexo e departamento
2 - Mostrar o total da folha de pagamento da empresa  (parâmetro 'todos')
2.1 - Mostrar o total da folha de pagamento de
	determinado departamento (parâmetro nome do departamento)
3 - Mostrar quantas vezes cada funcionário mudou de departamento (parâmetro 'todos') 
3.1 - Mostrar os nomes dos funcionários com o maior número de mudanças de um departamento).
*/

# alterar Edit>Preferences>Sql Execution desmarcar limit row
# alterar Edit>Preferences>Sql editor read timeout interval = 300 onde está 30
use empregados;

# Questão A1
create view vw_funcionario_dados
as
select concat(e.first_name, ' ', e.last_name) nome, s.salary, t.title, d.dept_name  from 
employees e 
inner join titles t on t.emp_no = e.emp_no
inner join salaries s on s.emp_no = e.emp_no
inner join dept_emp de on de.emp_no = e.emp_no
inner join departments d on d.dept_no = de.dept_no
where t.to_date = (select max(tin.to_date)
					from titles tin 
                    where tin.emp_no = t.emp_no)
and s.to_date = (select max(sin.to_date)
					from salaries sin 
                    where sin.emp_no = s.emp_no) 
and de.to_date = (select max(dein.to_date)
					from dept_emp dein
                    where dein.emp_no = de.emp_no) 
;

select * from vw_funcionario_dados;

select * from employees order by emp_no;

#Questão B1
delimiter ##
create procedure sp_funcionario_sexo_departamento(p_sexo char(1), p_departamento varchar(30))
begin 
	select first_name, dept_name, gender
	from employees e 
	inner join dept_emp de on e.emp_no = de.emp_no
	inner join departments d on d.dept_no = de.dept_no
	where de.to_date = (select max(dein.to_date)
						from dept_emp dein
						where dein.emp_no = de.emp_no)
	and d.dept_name = p_departamento
	and gender = p_sexo
;
end ##
delimiter ;

call sp_funcionario_sexo_departamento('f', 'Customer Service');

select first_name, gender from employees
where gender = 'F';

select first_name, dept_name, gender
from employees e 
inner join dept_emp de on e.emp_no = de.emp_no
inner join departments d on d.dept_no = de.dept_no
where de.to_date = (select max(dein.to_date)
					from dept_emp dein
                    where dein.emp_no = de.emp_no)
and d.dept_name = 'Customer Service'
and gender = 'F';


# Questão B2
#2 - Mostrar o total da folha de pagamento da empresa  (parâmetro 'todos')
#2.1 - Mostrar o total da folha de pagamento de
#	determinado departamento (parâmetro nome do departamento)

delimiter ##
create procedure sp_folha_pagamento(p_departamento varchar(30))
begin 
	if p_departamento = 'todos' then
		select sum(s.salary) from employees e
		inner join salaries s on s.emp_no = e.emp_no
		inner join dept_emp de on de.emp_no = e.emp_no
		inner join departments d on d.dept_no = de.dept_no
		where s.to_date = (select max(sin.to_date)
							from salaries sin 
							where sin.emp_no = s.emp_no) 
		and de.to_date = (select max(dein.to_date)
							from dept_emp dein
							where dein.emp_no = de.emp_no)
		;
	else 
		select sum(s.salary) total from employees e
		inner join salaries s on s.emp_no = e.emp_no
		inner join dept_emp de on de.emp_no = e.emp_no
		inner join departments d on d.dept_no = de.dept_no
		where s.to_date = (select max(sin.to_date)
							from salaries sin 
							where sin.emp_no = s.emp_no) 
		and de.to_date = (select max(dein.to_date)
							from dept_emp dein
							where dein.emp_no = de.emp_no)
		and d.dept_name = p_departamento
		;
        end if;
end ##
delimiter ;

call sp_folha_pagamento('Customer Service');
call sp_folha_pagamento('todos');


select sum(s.salary) from salaries s;

select sum(s.salary) from employees e
inner join salaries s on s.emp_no = e.emp_no
inner join dept_emp de on de.emp_no = e.emp_no
inner join departments d on d.dept_no = de.dept_no
where s.to_date = (select max(sin.to_date)
					from salaries sin 
                    where sin.emp_no = s.emp_no) 
and de.to_date = (select max(dein.to_date)
					from dept_emp dein
                    where dein.emp_no = de.emp_no)
;


# Questão B3
/*3 - Mostrar quantas vezes cada funcionário mudou de departamento (parâmetro 'todos') 
3.1 - Mostrar os nomes dos funcionários com o maior número de mudanças de um departamento).*/

select e.first_name from employees e
inner join dept_emp de on de.emp_no = e.emp_no
inner join departments d on d.dept_no = de.dept_no
where s.to_date = (select max(sin.to_date)
					from salaries sin 
                    where sin.emp_no = s.emp_no) 
and de.to_date = (select max(dein.to_date)
					from dept_emp dein
                    where dein.emp_no = de.emp_no);

select e.first_name, count(d.dept_name), d.dept_name departamentos from employees e 
inner join dept_emp de on de.emp_no = e.emp_no
inner join departments d on d.dept_no = de.dept_no
group by e.emp_no, d.dept_name;

select e.first_name, count(d.dept_name) departamentos from employees e 
inner join dept_emp de on de.emp_no = e.emp_no
inner join departments d on d.dept_no = de.dept_no
where count(d.dept_name) <= (
					select count(d.dept_name) departamentos from employees e 
					inner join dept_emp de on de.emp_no = e.emp_no
					inner join departments d on d.dept_no = de.dept_no
					group by e.emp_no
					order by departamentos desc limit 1)
group by e.emp_no
order by departamentos desc 
;

select count(de.emp_no) departamentos, de.emp_no from dept_emp de
group by de.emp_no;



explain analyze select concat(e.first_name, ' ', e.last_name) nome, s.salary, t.title, d.dept_name  from 
employees e 
inner join titles t on t.emp_no = e.emp_no
inner join salaries s on s.emp_no = e.emp_no
inner join dept_emp de on de.emp_no = e.emp_no
inner join departments d on d.dept_no = de.dept_no
where t.to_date = (select max(tin.to_date)
					from titles tin 
                    where tin.emp_no = t.emp_no)
and s.to_date = (select max(sin.to_date)
					from salaries sin 
                    where sin.emp_no = s.emp_no) 
and de.to_date = (select max(dein.to_date)
					from dept_emp dein
                    where dein.emp_no = de.emp_no) 
;


###################################### Lista de exercícios
###### Questão 2		

select concat(e.first_name, ' ', e.last_name) nome, d.dept_name, dm.from_date, s.salary, t.title from dept_manager dm
inner join employees e on e.emp_no = dm.emp_no
inner join departments d on d.dept_no = dm.dept_no
inner join salaries s on s.emp_no = e.emp_no
inner join titles t on t.emp_no = e.emp_no
where dm.from_date = (select min(dmin.from_date)
					from dept_emp dmin
                    where dmin.emp_no = dm.emp_no) 
and t.from_date = (select min(tin.from_date)
					from titles tin
                    where tin.emp_no = dm.emp_no) 
and s.from_date = (select min(sin.from_date)
					from salaries sin
                    where sin.emp_no = dm.emp_no)				
;	


## Testes
#CTE titles
with UltimoSalario as (
	select emp_no, max(to_date) as max_salario_data
	from salaries
	group by emp_no
),
UltimoDepto as (
	select emp_no, max(to_date) as max_dept_data
    from dept_emp
    group by emp_no
),
UltimoCargo as (
	select emp_no, max(to_date) as max_title_data
    from titles
    group by emp_no
)
select concat(e.first_name, ' ', e.last_name) Nome,
	s.salary as 'Ultimo Salário',
    d.dept_name as 'Ultimo Departamento',
    t.title as 'Ultimo Cargo'
from employees e
inner join UltimoSalario us on e.emp_no = us.emp_no
inner join salaries s on e.emp_no = s.emp_no and s.to_date = us.max_salario_data
inner join UltimoDepto ud on e.emp_no = ud.emp_no
inner join dept_emp de on e.emp_no = de.emp_no and de.to_date = ud.max_dept_data
inner join departments d on de.dept_no = d.dept_no
inner join UltimoCargo uc on e.emp_no = uc.emp_no
inner join titles t on e.emp_no = t.emp_no and t.to_date = uc.max_title_data;

with UltimoCargo as (
	select emp_no, max(to_date) as max_title_data
    from titles
    group by emp_no
)
select concat(e.first_name, ' ', e.last_name) Nome,
	t.title as 'Ultimo Cargo'
from employees e
inner join UltimoCargo uc on e.emp_no = uc.emp_no
inner join titles t on e.emp_no = t.emp_no and t.to_date = uc.max_title_data;


select concat(e.first_name, ' ', e.last_name) Nome,
	t.title as 'Ultimo Cargo'
    from employees e
    inner join titles t on t.emp_no = e.emp_no
where t.from_date = (select min(tin.from_date)
					from titles tin
                    where tin.emp_no = t.emp_no);
                    
                    
                    
with UltimoSalario as (
	select emp_no, max(to_date) as max_salario_data
	from salaries
	group by emp_no
)
select concat(e.first_name, ' ', e.last_name) Nome,
	s.salary as 'Ultimo Salário'
from employees e
inner join UltimoSalario us on e.emp_no = us.emp_no
inner join salaries s on e.emp_no = s.emp_no and s.to_date = us.max_salario_data;






with UltimoSalario as (
	select emp_no, max(to_date) as max_salario_data
	from salaries
	group by emp_no
),
UltimoCargo as (
	select emp_no, max(to_date) as max_title_data
    from titles
    group by emp_no
),
PrimeiroGerente as (
	select emp_no, min(from_date) as min_manager_data
    from dept_manager
    group by emp_no
)
select concat(e.first_name, ' ', e.last_name) Nome,
	s.salary as 'Ultimo Salário',
    t.title as 'Ultimo Cargo',
    d.dept_name as 'Departamento',
    dm.from_date as 'Inicio'
    
from dept_manager dm
inner join PrimeiroGerente pg on dm.emp_no = pg.emp_no
inner join employees e on e.emp_no = dm.emp_no and  dm.from_date = pg.min_manager_data
inner join UltimoSalario us on e.emp_no = us.emp_no
inner join salaries s on e.emp_no = s.emp_no and s.to_date = us.max_salario_data
inner join departments d on dm.dept_no = d.dept_no
inner join UltimoCargo uc on e.emp_no = uc.emp_no
inner join titles t on e.emp_no = t.emp_no and t.to_date = uc.max_title_data;



#Funciona
with PrimeiroGerente as (
	select dept_no, min(from_date) as min_manager_data
    from dept_manager
    group by dept_no
),
UltimoSalario as (
	select emp_no, max(to_date) as max_salario_data
	from salaries
	group by emp_no
),
UltimoCargo as (
	select emp_no, max(to_date) as max_title_data
    from titles
    group by emp_no
)
select concat(e.first_name, ' ', e.last_name) Nome,
	d.dept_name as 'Departamento', 
    dm.from_date as 'Início',
    s.salary as 'Salário',
    t.title as 'Cargo'
from PrimeiroGerente pg
inner join dept_manager dm on dm.dept_no = pg.dept_no and dm.from_date = pg.min_manager_data
inner join employees e  on e.emp_no = dm.emp_no
inner join departments d on dm.dept_no = d.dept_no
inner join UltimoSalario us on e.emp_no = us.emp_no
inner join salaries s on s.emp_no = e.emp_no and s.to_date = us.max_salario_data 
inner join UltimoCargo uc on e.emp_no = uc.emp_no
inner join titles t on e.emp_no = t.emp_no and t.to_date = uc.max_title_data;





#Qestão 3
with PrimeiroGerente as (
	select dept_no, min(from_date) as min_manager_data
    from dept_manager
    group by dept_no
),
UltimoSalario as (
	select emp_no, min(from_date) as min_salario_data
	from salaries
	group by emp_no
),
UltimoCargo as (
	select emp_no, min(from_date) as min_title_data
    from titles
    group by emp_no
)
select concat(e.first_name, ' ', e.last_name) Nome,
	d.dept_name as 'Departamento', 
    s.salary as 'Salário',
    t.title as 'Cargo'
from PrimeiroGerente pg
inner join dept_manager dm on dm.dept_no = pg.dept_no and dm.from_date = pg.min_manager_data
inner join employees e  on e.emp_no = dm.emp_no
inner join departments d on dm.dept_no = d.dept_no
inner join UltimoSalario us on e.emp_no = us.emp_no
inner join salaries s on s.emp_no = e.emp_no and s.from_date = us.min_salario_data 
inner join UltimoCargo uc on e.emp_no = uc.emp_no
inner join titles t on e.emp_no = t.emp_no and t.from_date = uc.min_title_data;

create index idx_title_emp on titles(emp_no, title);

alter table titles drop index idx_title_emp;

use bd2020;

create table departamento (
	depnum int primary key,
	depnome varchar(100)
);

alter table funcionario add column fundepnum int;
ALTER TABLE funcionario ADD CONSTRAINT fk_departamento FOREIGN KEY(fundepnum) REFERENCES departamento (depnum);

select * from empregados.departments;

select * from funcionario;
