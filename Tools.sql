CREATE VIEW vw_visitante_info AS
SELECT a.id_pessoa, b.cpf, a.nome, a.telefone, a.email
FROM pessoa a	
JOIN visitante b ON a.id_pessoa = b.id_pessoa;
    
CREATE VIEW vw_aluno_info AS
SELECT a.id_pessoa, b.ra, a.nome, c.descricao, b.semestre, a.telefone, a.email, b.tipo, b.responsavel_evento
FROM pessoa a 
JOIN aluno b ON a.id_pessoa = b.id_pessoa
JOIN cursos c ON b.curso = c.id_curso;   
    
CREATE VIEW vw_exibe_eventos AS
SELECT id_evento, descricao, local, tipo, data_evento 
FROM evento 
WHERE data_evento > now();
	
CREATE VIEW vw_meus_eventos AS
SELECT a.id_evento, a.descricao, a.tipo, a.data_evento, c.id_pessoa, b.data_validacao 
FROM evento a
JOIN participacoes b ON a.id_evento = b.id_evento
JOIN pessoa c ON b.id_pessoa_participante = c.id_pessoa 
WHERE b.data_validacao IS NOT NULL;

CREATE VIEW vw_aluno_eventos_por_curso AS
SELECT DISTINCT a.ra, a.id_pessoa, p.nome, a.curso, p.qtd_eventos_participados FROM aluno a
JOIN pessoa p ON a.id_pessoa = p.id_pessoa
JOIN participacoes pa ON a.id_pessoa = pa.id_pessoa_participante
JOIN evento e ON pa.id_evento = e.id_evento;

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

#PROCEDURE VERIFICAR TIMER ENTRE EVENTO E DATA HORA ATUAL
delimiter $$
create procedure verifica_tempo (in id_evento_consulta int)
	begin
        -- definição de variáveis utilizadas na procedure		
        declare p_flag      int default 0;
        declare p_minutos   int default 0;
                
		-- selecionar a data/hora da tabela
        select round(time_to_sec(timediff(now(), dt_verificacao)) / 60, 0) into p_minutos
		from evento
		where id_evento = id_evento_consulta;                    
		       
		-- validacao do tempo
		if p_minutos > 10 then
			set p_flag = 0;
		else
			set p_flag = 1;
        end if;
        
        set @flag = p_flag;
        
        select @flag;
        
	end $$
delimiter ;

-- Adiciona o aluno na tabela de participacoes e incrementa a quantidade de eventos participados.
-- Para executar: CALL p_add_presenca_aluno("id_evento", "id_pessoa_participante", "id_pessoa_validacao");
DELIMITER $$
CREATE PROCEDURE p_add_presenca_aluno 
(id_evento INT, id_pessoa_participante INT, id_pessoa_validacao INT)
BEGIN

	INSERT INTO participacoes (id_evento, id_pessoa_participante, id_pessoa_validacao, data_validacao) 
	VALUES (
    id_evento, 
    id_pessoa_participante, 
    id_pessoa_validacao, 
    now()
  );
    
	UPDATE pessoa SET 
  qtd_eventos_participados = qtd_eventos_participados + 1 
  WHERE id_pessoa = id_pessoa_participante;

END $$
DELIMITER ;
