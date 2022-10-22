CREATE VIEW vw_visitante_info AS
SELECT a.id_pessoa, b.cpf, a.nome, a.telefone, a.email FROM pessoa a	
	JOIN visitante b ON a.id_pessoa = b.id_pessoa;
    
CREATE VIEW vw_aluno_info AS
SELECT a.id_pessoa, b.ra, a.nome, c.descricao, b.semestre, a.telefone, a.email FROM pessoa a 
	JOIN aluno b ON a.id_pessoa = b.id_pessoa
    JOIN cursos c ON b.curso = c.id_curso;
    
CREATE VIEW vw_valida_estande AS
SELECT a.id_evento, a.descricao, c.id_pessoa, c.nome, c.email, b.validacao from evento a
	JOIN agenda b ON a.id_evento = b.id_evento
    JOIN pessoa c ON b.id_pessoa = c.id_pessoa;    
    
CREATE VIEW vw_exibe_eventos AS
	select id_evento, descricao, tipo, data_evento from evento WHERE data_evento > now() - interval 3 hour;
    

delimiter .
# PAV = Pessoa, Aluno, Visitante, Termo
create procedure insPAV(in nomePAV varchar(50),
                        in emailPAV varchar(70),
                        in telefonePAV varchar(15),
                        in raPAV int(11),
                        in cpfPAV char(11),
                        in cursoPAV int,
                        in periodoPAV int(11)
                        )
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


DELIMITER $
CREATE TRIGGER trg_login_estande 
	AFTER INSERT ON evento FOR EACH ROW
	BEGIN
		IF NEW.tipo = 'estande' THEN
			INSERT INTO login(usuario, senha, id_evento)
			VALUES(SUBSTRING(uuid(), 1, 8), REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(uuid(), 1, 10), "-", "@"), "0", "!"), "3", "#"), "b", "*"), "c", "#"), "k", "T"), "9", "S"), "f", "x"), "-", "@"), "0", "!"), "-", "@"), "3", "#"), NEW.id_evento);
		END IF;
	END $
DELIMITER ;

