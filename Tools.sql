CREATE VIEW vw_visitante_info AS
SELECT b.cpf, a.nome, a.telefone, a.email FROM pessoa a	
	JOIN visitante b ON a.id_pessoa = b.id_pessoa;
    
CREATE VIEW vw_aluno_info AS
SELECT b.ra, a.nome, c.descricao, b.semestre, a.telefone, a.email FROM pessoa a 
	JOIN aluno b ON a.id_pessoa = b.id_pessoa
    JOIN cursos c ON b.curso = c.id_curso;
    

delimiter .
# PAV = Pessoa, Aluno, Visitante, Termo
create procedure insPAV(in nomePAV varchar(50),
                        in emailPAV varchar(70),
                        in telefonePAV varchar(15),
                        in raPAV int(11),
                        in cpfPAV char(11),
                        in cursoPAV int,
                        in periodoPAV int(11),
                        in aceiteTermoPAV boolean)
begin
  declare idPAV int;
  insert into pessoa(nome, email, telefone)
    values (nomePAV, emailPAV, telefonePAV);
  if (raPAV = 0) then
    set idPAV = last_insert_id();
      insert into visitante(cpf, id_pessoa)
        values (cpfPAV, idPAV);
  else
    set idPAV = last_insert_id();
      insert into aluno(ra, id_pessoa, curso, semestre)
        values(raPAV, idPAV, cursoPAV, periodoPAV);
  end if;
  insert into termo(id_pessoa)
        values(idPAV);
end .

delimiter ;
