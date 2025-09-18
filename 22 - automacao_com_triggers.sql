---
---------------
--Cria��o de triggers avan�adas
--Objetivo: usar as triggers para automa��o de tarefas
--A trigger ser� configurada para realizar auditoria
--autom�tica ap�s as inser��es, atualiza��es e exclus�es
----------------

IF NOT EXISTS (SELECT 1 FROM sys.databases 
WHERE name = 'db1609_automacaoTriggers')
	CREATE DATABASE db1609_automacaoTriggers
GO

USE db1609_automacaoTriggers
GO

--Idempotencia, ou seja, rodar v�rias vezes sem quebrar
IF OBJECT_ID('trg_AuditoriaInsercao','TR')IS NOT NULL
	DROP TRIGGER trg_AuditoriaInsercao;
GO
IF OBJECT_ID('trg_AuditoriaExclusao','TR')IS NOT NULL
	DROP TRIGGER trg_AuditoriaExclusao;
GO
IF OBJECT_ID('trg_AuditoriaAtualizacao','TR')IS NOT NULL
	DROP TRIGGER trg_AuditoriaAtualizacao;
GO
IF OBJECT_ID('auditoria_vendas','U')IS NOT NULL
	DROP TABLE auditoria_vendas;
GO
IF OBJECT_ID('vendas','U')IS NOT NULL
	DROP TABLE vendas;
GO





-- 1. cria��o da tabela de auditoria para registrar altera��es nos dados
CREATE TABLE auditoria_vendas(
	id_auditoria INT IDENTITY (1,1) PRIMARY KEY,
	id_venda INT,
	valor_venda DECIMAL (10,2),
	data_venda DATE, --somente a data
	operacao NVARCHAR(50),  --VARCHAR COM NUMEROS, tipo insert, update...
	data_operacao DATETIME, --data e hora
	usuario NVARCHAR(50) -- usuario que efetuou a opera��o
);
-- 2. cria��o da tabela de vendas complementar ao exerc�cio
CREATE TABLE vendas (
	id_venda INT PRIMARY KEY,
	valor_venda DECIMAL(10,2),
	data_venda DATE
);
GO

--3.cria��o da trigger para a auditoria ap�s a inser��o da tabela vendas
CREATE TRIGGER trg_AuditoriaInsercao
	ON vendas
	AFTER INSERT
	AS
	BEGIN
		INSERT INTO auditoria_vendas
		(id_venda,valor_venda,data_venda,operacao,data_operacao,usuario)
		SELECT id_venda,valor_venda, data_venda, 'INSERT', GETDATE(), SYSTEM_USER  ---MOSTRA QUEM ESTAVA LOGADO
		FROM inserted; --cont�m os dados da linha inserida
		PRINT 'Dados inseridos na tabela de auditoria ap�s a inserir a venda na tabela de vendas';
	END;
	GO

--4.cria��o da trigger para a auditoria ap�s a exclus�o da tabela vendas
CREATE TRIGGER trg_AuditoriaExclusao
	ON vendas
	AFTER DELETE
	AS
	BEGIN
		INSERT INTO auditoria_vendas
		(id_venda,valor_venda,data_venda,operacao,data_operacao,usuario)
		SELECT id_venda,valor_venda, data_venda, 'DELETE', GETDATE(), SYSTEM_USER  
		FROM deleted; 
		PRINT 'Dados exclu�dos na tabela de auditoria ap�s a exclus�o a venda na tabela de vendas';
		
	END;
	GO

--5.cria��o da trigger para a auditoria ap�s a atualiza��o da tabela vendas
CREATE TRIGGER trg_AuditoriaAtualizacao
	ON vendas
	AFTER UPDATE
	AS
	BEGIN
		INSERT INTO auditoria_vendas
		(id_venda,valor_venda,data_venda,operacao,data_operacao,usuario)
		SELECT id_venda,valor_venda, data_venda, 'UPDATE', GETDATE(), SYSTEM_USER  
		FROM inserted; 
		PRINT 'Dados inseridos na tabela de auditoria ap�s a atualizar a venda na tabela de vendas';
	END;
	GO

--inserindo dados das vendas e acionando o gatilho correspondente
INSERT INTO vendas(id_venda,valor_venda,data_venda)
VALUES (1, 150.00, '2025-01-01');

--atualizando dados das vendas
UPDATE vendas SET valor_venda = 200.00 WHERE id_venda = 1;

--excluindo registro de vendas
DELETE FROM vendas WHERE id_venda = 1;

---verificando os dados da auditoria
SELECT *FROM auditoria_vendas

