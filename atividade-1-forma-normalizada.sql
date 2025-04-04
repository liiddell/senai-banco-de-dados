use testedb;

create table if not exists cliente(
	codigo_cliente int PRIMARY KEY auto_increment,
    nome VARCHAR(50) NOT NULL,
    telefone VARCHAR (50) NOT NULL,
    endereco VARCHAR (100) NOT NULL
    );

INSERT INTO cliente (nome, telefone, endereco)
VALUES ('José', '9563-6352 9847-2501', 'Rua Seis, 85 Morumbi 12536-965');

INSERT INTO cliente (nome, telefone, endereco)
VALUES ('Maria', '3265-8596', 'Rua Onze, 64 Moema 65985-963');

INSERT INTO cliente (nome, telefone, endereco)
VALUES ('Janio','8545-8956 9598-6301', 'Praça Ramos Liberdade 68858-633');


UPDATE cliente
SET rua = 'Praça Ramos'
WHERE (codigo_cliente = 3);

UPDATE cliente
SET bairro = 'Liberdade'
WHERE (codigo_cliente = 3);

UPDATE cliente
SET cep = '68858-633'
WHERE (codigo_cliente = 3);


create table telefone(
	codigo_cliente INT REFERENCES cliente(codigo_cliente),
	telefone_primario VARCHAR(20) NOT NULL,
    telefone_secundario VARCHAR(20)
);

INSERT INTO telefone(codigo_cliente, telefone_primario, telefone_secundario)
VALUES(3, '8545-8956','9598-6301');


ALTER TABLE cliente
DROP COLUMN telefone