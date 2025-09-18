CREATE DATABASE db1609_isolamento_transacional
GO

USE db1609_isolamento_transacional
GO

CREATE TABLE produtos(
	produto_id INT PRIMARY KEY,
	nome_produto VARCHAR(100),
	quantidade INT,
	preco DECIMAL(10,2)
);

INSERT INTO produtos (produto_id,nome_produto,quantidade,preco)
VALUES 
(1, 'Camiseta', 100, 50.00),
(2, 'Calça', 50, 100.00),
(3, 'Tênis', 70, 150.00);

SELECT *FROM produtos


---Exemplo de controle de isolamento transacional.
---Para observar o comportamento vamos realizar algumas operações
---a)usar diferentes níveis de isolamento
---b)simular transações recorrentes
---COMEÇANDO COM UMA TRANSAÇÃO COM NÍVEL DE ISOLAMENTO "READ UNCOMMITTED"
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
	---vamos ler os dados da tabela produtos, permitindo dados n confirmados(dirty read)
	PRINT 'Transação 1 (READ UNCOMMITTED)';
	SELECT * FROM produtos;

	---alterando dados de quantidade sem confirmar a transação
	UPDATE produtos
	SET quantidade = quantidade -10
	WHERE produto_id = 1;

	---simulando algum processamento
	WAITFOR DELAY '00:00:10'; ---atraso de 10 segundos
COMMIT TRANSACTION;

---agora, começamos com uma transação com o nível de isolamento "serializable"

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
---vamos tentar ler e bloquear a linha de produto_id 1
	PRINT 'Transação 2 (SERIALIZABLE)';
	SELECT * FROM produtos WHERE produto_id =1
	WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;

SELECT *FROM produtos;
