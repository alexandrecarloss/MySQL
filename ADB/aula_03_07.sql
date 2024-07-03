delimiter ##
create procedure sp_lista_cliente_sexo_bairro(psexo char(1), pbairro varchar(40))
begin
	select clicodigo Codigo, clinome Cliente, clisexo Sexo, clirendamensal Renda, estdescricao Estado_Civil, bainome Bairro
	from cliente
    inner join bairro on baicodigo = clibaicodigo
    inner join estadocivil on estcodigo = cliestcodigo
    where bainome = pbainome and clisexo = psexo
    order by clinome;
end##
delimiter ;
