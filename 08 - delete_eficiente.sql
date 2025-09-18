
CREATE DATABASE db1609_eficiente02
GO

USE db1609_eficiente02
GO

CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME
);

CREATE TABLE pedidos(
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL(10,2),
);

INSERT INTO clientes (cliente_id,nome_cliente,data_cadastro)
SELECT TOP 1000000

---GERAR O VALOR SEQUENCIAL DE 1 A INFINITO POR CADA LINHA.
---O OVER EXIGE ORDENAR. ISSO � UM TRUQUE PARA DIZER QUE N�O QUERO EM ORDEM PR�-DEFINIDA

	ROW_NUMBER() OVER(ORDER BY(SELECT NULL)),
	'Cliente' + CAST(
	ROW_NUMBER() OVER(ORDER BY(SELECT NULL)) AS VARCHAR(10)),
	DATEADD(DAY,-(ROW_NUMBER() OVER(ORDER BY(SELECT NULL)) % 3650), GETDATE())
FROM master.dbo.spt_values a , master.dbo.spt_values b;
---DELETE FROM clientes


INSERT INTO pedidos(pedido_id,cliente_id,data_pedido,valor_total)
SELECT TOP 1000000
	ROW_NUMBER() OVER(ORDER BY(SELECT NULL)),
	(ABS(CHECKSUM(NEWID())) % 1000000) + 1,  ---ATRIBUIMOS UM CLIENTE ALEAT�RIO
	DATEADD(DAY,-(ROW_NUMBER() OVER(ORDER BY(SELECT NULL)) % 3650), GETDATE()),
	CAST(RAND() *1000 AS DECIMAL (10,2))
FROM master.dbo.spt_values a, master.dbo.spt_values b;

SELECT TOP 10 * FROM clientes;
SELECT TOP 10 * FROM pedidos;


BEGIN TRY
	BEGIN TRANSACTION;
	---declarando as vari�veis para o controle dos lotes
		DECLARE @batchsize INT = 1000;
		DECLARE @rowcount INT;
		--- inicializando a vari�vel de controle da  contagem de registros exclu�dos
		SET @rowcount = 1;

		--- LOOP para excluir os dados em lotes
		WHILE @rowcount >0
		BEGIN
		---Excluindo os dados em lotes de 1000
			DELETE TOP(@batchsize)
			FROM clientes 
			WHERE data_cadastro < DATEADD(YEAR, -5, GETDATE());

			---obtendo a contagem de registros na intera��o atual
			SET @rowcount = @@ROWCOUNT 
			---- exibindo o progresso
			PRINT ' Exclu�dos  ' + CAST(@rowcount AS VARCHAR) + '  registros de clientes.';

			WAITFOR DELAY '00:00:01'; ----LIMITADO A 24 HORAS - ESPERA DE 1SEGUNDO ENTRE LOTES
		END
			   
	COMMIT TRANSACTION;

END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
	PRINT 'Erro durante a exclus�o' + ERROR_MESSAGE();
END CATCH

SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM pedidos;