
CREATE DATABASE db1609_AlterProducao;
GO

USE db1609_AlterProducao
GO


CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME,	
);

INSERT INTO clientes(cliente_id,nome_cliente, data_cadastro)
VALUES 
(1, 'Caio Ross','2025-01-01'),
(2, 'Gabriel Sousa','2025-01-01'),
(3, 'Jotael Genuino','2025-01-01'),
(4, 'Natalia Sales','2025-01-01');

---para efetuar uma alteração no banco de dados em produção, devemos criar uma nova
---tabela e migrar os dados para ela por segurança

---PASSO 1) primeiro criamos a tabela temporária
CREATE TABLE clientes_temp (
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME,	
	email_cliente VARCHAR(100)
);

---PASSO 2) vamos migrar a tabela original para a nova tabela temporária
INSERT INTO clientes_temp(cliente_id,nome_cliente,data_cadastro)
SELECT cliente_id, nome_cliente, data_cadastro
FROM clientes;

---você pode usar o bloqueio explicito de trnasação TRANSACTION,
BEGIN TRANSACTION;
---eliminar a tabela original
	DROP TABLE clientes;
---renomear a tabela temporária
	EXEC sp_rename 'clientes_temp', 'clientes';
COMMIT TRANSACTION;

SELECT * FROM clientes;