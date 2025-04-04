use segundaforma;

CREATE TABLE servico (
	id INT PRIMARY KEY AUTO_INCREMENT,
    id_servico INT NOT NULL,
    nome_servico VARCHAR(100) NOT NULL,
    total_horas INT NOT NULL,
    valor_hora DECIMAL NOT NULL,
    subtotal DECIMAL NOT NULL
);

INSERT INTO servico (id, id_servico, nome_servico, total_horas, valor_hora, subtotal) 
VALUES (1, 0001, "Designer de Site", 12, 70.00, 840.00);

INSERT INTO servico (id, id_servico, nome_servico, total_horas, valor_hora, subtotal) 
VALUES (2, 0002, "Desenvolvedor de Software ", 50, 90, 4500.00);

INSERT INTO servico (id, id_servico, nome_servico, total_horas, valor_hora, subtotal)  
VALUES (3, 0001, "Consultoria", 5, 100, 500.00);

CREATE TABLE dados_servico (
	id_servico INT PRIMARY KEY,
    servico VARCHAR(100) NOT NULL,
    valor_hora DOUBLE NOT NULL
);

INSERT INTO dados_servico (id_servico, servico, valor_hora)  
VALUES (0001, "Designer de Site", 70);

INSERT INTO dados_servico (id_servico, servico, valor_hora)  
VALUES (0002, "Densenvolvimento de Software", 90);

INSERT INTO dados_servico (id_servico, servico, valor_hora)  
VALUES (0003, "Consultoria", 100);

ALTER TABLE servico
ADD FOREIGN KEY (id_servico) REFERENCES dados_servico(id_servico);

ALTER TABLE servico drop column nome_servico;
ALTER TABLE servico drop column valor_hora;

UPDATE servico
SET id_servico = 3, total_horas = 5, subtotal = 500
WHERE id = 1;

UPDATE servico
SET id_servico = 1, total_horas = 50, subtotal = 840
WHERE id = 2;

UPDATE servico
SET id_servico = 2, total_horas = 12, subtotal = 4500
WHERE id = 3;

ALTER TABLE servico
DROP COLUMN subtotal;

alter table servico
add column valor_hora DECIMAL(10,2);

UPDATE servico
SET valor_hora = 100.00
WHERE id = 1;

UPDATE servico
SET valor_hora = 70.00
WHERE id = 2;

UPDATE servico
SET valor_hora = 90.00
WHERE id = 3;




