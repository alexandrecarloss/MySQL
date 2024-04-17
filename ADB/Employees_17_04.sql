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

use empregados;
# Questão 1
create view vw_funcionario_dados
as
select e.emp_no, s.salary, t.title, d.dept_name  from 
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

#Questão 2
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












