#Criação do banco de dados
create database fatecweek;

#Selecionando o banco de dados
use fatecweek;

#Criando a tabela de Evento
create table evento (
	id_evento int auto_increment primary key,
    descricao varchar(100) default '',
    tipo enum('estande','palestra') default 'estande',
    estatus char(01) default '',
    dtcria datetime default now()
);

#Criando a tabela de Pessoa
create table pessoa (
	id_pessoa int auto_increment primary key,
    nome varchar(50) default '',
    email varchar(70) default '',
    telefone varchar(14) default '',
    estatus char(01) default '',
    dtcria datetime default now()
);

#Criando a tabela de Aluno
create table aluno (
	ra int primary key,
    id_pessoa int default 0,
    curso varchar(50) default '',
    semestre int default 0,
    estatus char(01) default '',
    dtcria datetime default now(),
    foreign key (id_pessoa) references pessoa(id_pessoa)
);

#Criando a tabela de Visitante
create table visitante (
	cpf char(11) primary key,
    id_pessoa int default 0,
    estatus char(01) default '',
    dtcria datetime default now(),
    foreign key (id_pessoa) references pessoa(id_pessoa)
);

#Criando a tabela de Agenda
create table agenda (
	id_evento int,
    id_pessoa int,
    validacao int default 0,
    data_hora datetime,
    quem_validou varchar(50) default '',
    estatus char(01) default '',
    dtcria datetime default now(),
    foreign key(id_evento) references evento(id_evento),
    foreign key(id_pessoa) references pessoa(id_pessoa)
)