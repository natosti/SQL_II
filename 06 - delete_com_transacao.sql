----06 - delete_com_transacao.sql

USE db1609_empresa_muito_legal
GO

CREATE TABLE pedidos(
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL (10,2),
	FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

INSERT INTO clientes(cliente_id,nome_cliente,email_cliente)
VALUES 
(10, 'Caio Ross','kio199@gmail.com'),
(20, 'Gabriel Sousa','gabriel@gmail.com'),
(30, 'Jotael Genuino','jotael@gmail.com'),
(40, 'Natalia Sales','natalia@gmail.com')

INSERT INTO pedidos(pedido_id,cliente_id,data_pedido,valor_total)
VALUES
(1,1,'2025-01-01',150.00),
(2,1,'2025-01-01',200.00),
(3,2,'2025-01-01',300.00),
(4,3,'2025-02-05',450.00);

---VISUALIZA��O DOS DADOS ANTES DA EXCLUS�O
SELECT *FROM clientes;
SELECT *FROM pedidos;

BEGIN TRY
---iniciando a transa��o para garantir as exclus�es - 1 o pedido e depois o cliente
	BEGIN TRANSACTION;
		DELETE FROM pedidos WHERE cliente_id = 1;
		DELETE FROM clientes WHERE cliente_id = 10;
	COMMIT TRANSACTION;
	PRINT 'Exclus�es realizadas com sucesso!';
END TRY
BEGIN CATCH
---caso ocorra algum erro, bora fazer um rollback e garantir que nada quebre
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
	PRINT 'Erro durante a exclus�o:  ' + ERROR_MESSAGE()	
END CATCH

---VISUALIZAR OS DADOS AP�S A EXCLUS�O
SELECT *FROM clientes;
SELECT *FROM pedidos;