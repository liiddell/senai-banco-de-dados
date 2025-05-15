create database almoxarifado;

use almoxarifado;

CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    tabela_afetada VARCHAR(100) NOT NULL,
    id_registro_afetado INT NOT NULL,
    tipo_operacao VARCHAR(50) NOT NULL CHECK (tipo_operacao IN ('INSERT', 'UPDATE', 'DELETE')),
    dados_anteriores JSON,
    dados_novos JSON,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario_responsavel bigint(20)unsigned REFERENCES usuario(id_usuario)
);

CREATE TABLE item (
    id_item SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    quantidade_estoque INT NOT NULL CHECK (quantidade_estoque >= 0),
    unidade_medida VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario_criacao bigint(20) unsigned REFERENCES usuario(id_usuario),
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario_atualizacao bigint(20) unsigned REFERENCES usuario(id_usuario)
);

CREATE TABLE movimentacao (
    id_movimentacao SERIAL PRIMARY KEY,
    id_item bigint(20) unsigned REFERENCES item(id_item),
    tipo_movimentacao VARCHAR(50) NOT NULL CHECK (tipo_movimentacao IN ('entrada', 'saida')),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario_responsavel bigint(20) unsigned REFERENCES usuario(id_usuario),
    observacao TEXT
);

## Inserir dados

INSERT INTO usuario (nome, email, senha_hash) 
VALUES ('Diogor', 'joao@email.com', md5('sadfasdfdsafsd')),
('Vitito', 'vitito@senau.com.br', md5('qweororewo')),
('Karrol', 'karrol@senau.com.br', md5('asdfasfdasdf')),
('Naara', 'naara@email.com', md5('samfhjfodo123'));

##Inserir intens

INSERT INTO item(nome, descricao, quantidade_estoque, unidade_medida, id_usuario_criacao)
VALUES('Notebook', 'Aspire 5', 5, '20x20', 1),
('Mouse', "Logi", 8, "10x5", 2),
("Monitor", "AOC", 8, "16x28",3),
("Memoria Ram", "Red Dragon 12gb RAM", 7, "8x2",4 );

## Movimentações

INSERT INTO movimentacao(id_item, tipo_movimentacao, quantidade, id_usuario_responsavel, observacao)
VALUES(1, "entrada", 8, 2, "Item edição limitada"),
(2, "entrada", 5, 1, "Compra"),
(2, "saida", 2, 3, "Venda"),
(1, "saida", 8, 4, "Venda");


## Visualização

SELECT mov.*, usu.nome, ite.nome as 'nome do item'
FROM movimentacao as mov
INNER JOIN usuario as usu ON usu.id_usuario = mov.id_usuario_responsavel
INNER JOIN item as ite on ite.id_item = mov.id_item;


#1. Como lidar todos os itens em ordem alfabética crescente

SELECT * FROM item ORDER BY nome ASC;

#2. Como saber a quantidade total de itens retirados(saida) por produto?

SELECT id_item, SUM(quantidade) as 'total_saida'
FROM movimentacao
WHERE tipo_movimentacao = 'saida'
GROUP BY id_item;

#3. Como calcular a média de quantidade nas entradas de estoque?

SELECT AVG(quantidade)
FROM movimentacao
WHERE tipo_movimentacao = 'entrada';

# 4. Quantos usuários ativos existem no sistema?

SELECT SUM(ativo) as 'usuarios_ativos'
FROM usuario
WHERE ativo = true;

# 5. Qual é o maior e o menor valor de estoque entre todos os itens
SELECT 
    MAX(quantidade_estoque) AS maior_estoque,
    MIN(quantidade_estoque) AS menor_estoque
FROM item;

# 6. Como listar todas as movimentações junto com o nome do item envolvido
SELECT m.*, i.nome AS nome_item
FROM movimentacao m
INNER JOIN item i ON m.id_item = i.id_item;

# 7. Como listar todos os itens, mesmo aqueles que nunca tiveram nenhuma movimentação
SELECT i.*, m.id_movimentacao, m.tipo_movimentacao
FROM item i
LEFT JOIN movimentacao m ON i.id_item = m.id_item;

# 8. Como encontrar usuários que nunca fizeram nenhuma movimentação de estoque
SELECT u.*
FROM usuario u
LEFT JOIN movimentacao m ON u.id_usuario = m.id_usuario_responsavel
WHERE m.id_movimentacao IS NULL;

# 9. É possível demonstrar quantas movimentações cada usuário realizou?

SELECT m.id_usuario_responsavel, u.id_usuario, COUNT(m.id_usuario_responsavel) as movimentacoes
FROM movimentacao m
INNER JOIN usuario as u ON id_usuario = id_usuario_responsavel
GROUP BY m.id_usuario_responsavel;

# 10. É possível somar a quantidade de saídas por item?

SELECT i.nome, i.id_item, sum(quantidade)
FROM movimentacao m
INNER JOIN item i ON i.id_item =  m.id_item
WHERE tipo_movimentacao = 'saida'
GROUP BY i.id_item;

# 11 É possível obter a média da quantidade de entrada por item?

SELECT i.nome, i.id_item, AVG(quantidade) as media
FROM movimentacao m
INNER JOIN item i ON i.id_item = m.id_item
WHERE tipo_movimentacao = 'entrada'
GROUP BY i.id_item;

#12 Liste os itens com seus respectivos usuários criadores. 

SELECT i.id_item, i.nome, u.nome as usuario
FROM item i
INNER JOIN usuario u ON u.id_usuario = i.id_usuario_criacao
GROUP BY i.id_item, usuario;

