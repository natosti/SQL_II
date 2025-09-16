
CREATE DATABASE db1609_empresa_muito_legal;
GO

USE db1609_empresa_muito_legal
GO

CREATE TABLE clientes (
cliente_id INT PRIMARY KEY,
nome_cliente VARCHAR(100),
email_cliente VARCHAR(100),
--- DATA E HORA DO IN�CIO DA VALIDADE DO REGISTRO
data_inicio DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
--- DATA E HORA DO FIM DA VALIDADE DO REGISTRO
data_fim DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
---- DEFINIR O PER�ODO DE TEMPO DURANTE O QUAL O REGISTRO � V�LIDO
PERIOD FOR SYSTEM_TIME (data_inicio, data_fim)
)

---ATIVANDO O VERSIONAMENTO DO SISTEMA E CRIANDO UMA TABELA DE HIST�RICO - DBO PRECISA COLOCAR
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.clientes_historico));

/*CRIA TABELA DE HIST�RICO QUE ARMAZENAR� AS VERS�ES ANTERIORES DOS DADOS
---POR PADR�O, O SQL SERVER CRIA ESSA TABELA AUTOMATICAMENTE QUANDO O VERSIONAMENTO � HABILITADO
---MAS PODEMOS CRIAR EXPLICITAMENTE SE DESEJADO
*/

CREATE TABLE clientes_historico (
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR (100),
	email_cliente VARCHAR(100),
	data_inicio DATETIME2,
	data_fim DATETIME2
)

INSERT INTO clientes(cliente_id,nome_cliente,email_cliente)
VALUES 
(1,	'Caio Ross','kio199@gmail.com'),
(2, 'Gabriel Sousa','gabriel@gmail.com'),
(3, 'Jotael Genuino','jotael@gmail.com'),
(4, 'Natalia Sales','natalia@gmail.com')

---VERIFICA OS DADOS QUE ACABAMOS DE INSERIR
SELECT *FROM clientes;

UPDATE clientes
SET nome_cliente = 'Caio Rossi', email_cliente = 'sem.email@gmail.com'
WHERE cliente_id = 1;
SELECT *FROM clientes;

SELECT * FROM clientes_historico

---INSERINDO DADOS EM UMA TABELA TEMPOR�RIA
---ESSAS TABELAS S�O �TEIS PARA ARMAZENAR DADOS TEMPOR�RIOS QUE N�O
---PRECISAM PERSISTIR NO BANCO DE DADOS

CREATE TABLE #clientes_temporarios(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	email_cliente VARCHAR(100)
);

INSERT INTO #clientes_temporarios(cliente_id,nome_cliente,email_cliente)
VALUES
(5, 'Stephen Hawking','hipervoid@gmail.com'),
(6, 'Albert Einstein','linguinha@gmail.com')

SELECT *FROM #clientes_temporarios

DROP TABLE #clientes_temporarios
