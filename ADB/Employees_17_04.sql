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

