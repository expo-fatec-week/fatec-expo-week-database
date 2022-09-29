delimiter .
# PAV = Pessoa, Aluno, Visitante
create procedure insPAV(in nomePAV varchar(50),
                        in emailPAV varchar(70),
                        in telefonePAV varchar(14),
                        in raPAV int(11),
                        in cpfPAV char(11),
                        in cursoPAV varchar(50),
                        in periodoPAV int(11))
begin
  insert into pessoa(nome, email, telefone)
    values (nomePAV, emailPAV, telefonePAV);
  if (raPAV = null) then
    insert into visitante(cpf)
      values (cpfPAV);
  else
    insert into aluno(ra, curso, semestre)
      values(raPAV, cursoPAV, periodoPAV);
  end if;
end .

delimiter ;
