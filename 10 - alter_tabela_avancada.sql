
CREATE DATABASE db1609_AlterAvancada02;
GO

USE db1609_AlterAvancada02
GO

CREATE TABLE clientes(
	cliente_id INT,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME,
	CONSTRAINT PK_clientes_cliente_id PRIMARY KEY (cliente_id)
);

INSERT INTO clientes(cliente_id,nome_cliente, data_cadastro)
VALUES 
(1, 'Caio Ross','2025-01-01'),
(2, 'Gabriel Sousa','2025-01-01'),
(3, 'Jotael Genuino','2025-01-01'),
(4, 'Natalia Sales','2025-01-01');


---Passo 1) remover a chave prim�ria existente
ALTER TABLE clientes
DROP CONSTRAINT PK__clientes__cliente_id

---Passo 2) adicionar uma nova chave prim�ria a uma coluna existente
ALTER TABLE clientes
ADD CONSTRAINT PK__clientes__nome_cliente PRIMARY KEY (nome_cliente); ---sim, tem que repetir a info


---adicionanado um �ndice para otimizar a consulta por data nesse exemplo
---criando uma tabela nao clusterizada com indice
---VAI ENCONTRAR MAIS R�PIDO, tipo sum�rio de um livro

CREATE NONCLUSTERED INDEX IX_clientes_data_cadastro
ON clientes (data_cadastro);

---alterar um tipo...coisa simples hehehe
ALTER TABLE clientes
ALTER COLUMN nome_cliente TEXT;

---adicionando uma nova coluna
ALTER TABLE clientes
ADD email_cliente VARCHAR(150);

ALTER TABLE clientes
DROP COLUMN email_cliente;

---verificar se o �ndice existe na tabela
SELECT * FROM sys.indexes WHERE name = 'IX_clientes_data_cadastro';

---provando que agora funciona =)
ALTER TABLE clientes 
DROP CONSTRAINT PK_clientes_cliente_id