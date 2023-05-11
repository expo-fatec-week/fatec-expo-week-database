#Criação do banco de dados
create database etecdeem_fatecweek;

#Selecionando o banco de dados
use etecdeem_fatecweek;

#Criando a tabela de Pessoa
create table pessoa (
	id_pessoa int auto_increment primary key,
    nome varchar(130) default '',
    email varchar(70) default '',
    telefone varchar(15) default '',
    dtcria datetime default now()
);

#Criando a tabela de Cursos
create table cursos (
	id_curso int default 0 primary key,
    descricao varchar(40) default '',
    dtcria datetime default now()    
);

#Criando a tabela de Evento
create table evento (
	id_evento int auto_increment primary key,
    descricao varchar(150) default '',
    tipo enum('ESTANDE','PALESTRA') default 'ESTANDE',
    local varchar(30) default '',
    data_evento datetime,
    cod_verificacao varchar(10) default '',
    dt_verificacao datetime default now(),
    id_pessoa_verificacao int,
    dtcria datetime default now(),
    qtd_participantes int,
    FOREIGN KEY(id_pessoa_verificacao) REFERENCES pessoa (id_pessoa)
);

#Criando a tabela de Aluno
create table aluno (
	ra char(13) primary key,
    id_pessoa int default 0,
    curso int default 0,
    semestre int default 0,
    tipo enum('ORGANIZADOR', 'EXPOSITOR', 'VISITANTE') default 'VISITANTE',
    responsavel_evento int,
    dtcria datetime default now(),
    foreign key (id_pessoa) references pessoa(id_pessoa),
    foreign key(curso) references cursos(id_curso),
    foreign key(responsavel_evento) references evento(id_evento)
);

#Criando a tabela de Visitante
create table visitante (
	cpf char(11) primary key,
    id_pessoa int default 0,
    dtcria datetime default now(),
    foreign key (id_pessoa) references pessoa(id_pessoa)
);

#Criando a tabela de Agenda
create table participacoes (
	id_evento int,
    id_pessoa_participante int,
    id_pessoa_validacao int,
    data_validacao datetime default now(),
    foreign key(id_evento) references evento(id_evento),
    foreign key(id_pessoa_participante) references pessoa(id_pessoa),
    foreign key(id_pessoa_validacao) references pessoa(id_pessoa)
);

#Criando a tabela de Termo
create table termo (
    id_pessoa int default 0,
    dtcria datetime default now(),
    foreign key (id_pessoa) references pessoa(id_pessoa)
);

#Criando tabela de Administrador
create table administradores (
	id int auto_increment primary key,
    nome varchar(130) default '',
    email varchar(70) NOT NULL UNIQUE,
    senha varchar(255),
    dtcria datetime default now()
);