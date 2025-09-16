
CREATE DATABASE db1609_empresa_muito_legal;
GO

USE db1609_empresa_muito_legal
GO

CREATE TABLE clientes (
cliente_id INT PRIMARY KEY,
nome_cliente VARCHAR(100),
email_cliente VARCHAR(100),
--- DATA E HORA DO INÍCIO DA VALIDADE DO REGISTRO
data_inicio DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
--- DATA E HORA DO FIM DA VALIDADE DO REGISTRO
data_fim DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
---- DEFINIR O PERÍODO DE TEMPO DURANTE O QUAL O REGISTRO É VÁLIDO
PERIOD FOR SYSTEM_TIME (data_inicio, data_fim)
)

---ATIVANDO O VERSIONAMENTO DO SISTEMA E CRIANDO UMA TABELA DE HISTÓRICO - DBO PRECISA COLOCAR
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.clientes_historico));

/*CRIA TABELA DE HISTÓRICO QUE ARMAZENARÁ AS VERSÕES ANTERIORES DOS DADOS
---POR PADRÃO, O SQL SERVER CRIA ESSA TABELA AUTOMATICAMENTE QUANDO O VERSIONAMENTO É HABILITADO
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

---INSERINDO DADOS EM UMA TABELA TEMPORÁRIA
---ESSAS TABELAS SÃO ÚTEIS PARA ARMAZENAR DADOS TEMPORÁRIOS QUE NÃO
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
