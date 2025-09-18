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
(2, 'Cal�a', 50, 100.00),
(3, 'T�nis', 70, 150.00);

SELECT *FROM produtos


---Exemplo de controle de isolamento transacional.
---Para observar o comportamento vamos realizar algumas opera��es
---a)usar diferentes n�veis de isolamento
---b)simular transa��es recorrentes
---COME�ANDO COM UMA TRANSA��O COM N�VEL DE ISOLAMENTO "READ UNCOMMITTED"
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
	---vamos ler os dados da tabela produtos, permitindo dados n confirmados(dirty read)
	PRINT 'Transa��o 1 (READ UNCOMMITTED)';
	SELECT * FROM produtos;

	---alterando dados de quantidade sem confirmar a transa��o
	UPDATE produtos
	SET quantidade = quantidade -10
	WHERE produto_id = 1;

	---simulando algum processamento
	WAITFOR DELAY '00:00:10'; ---atraso de 10 segundos
COMMIT TRANSACTION;

---agora, come�amos com uma transa��o com o n�vel de isolamento "serializable"

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
---vamos tentar ler e bloquear a linha de produto_id 1
	PRINT 'Transa��o 2 (SERIALIZABLE)';
	SELECT * FROM produtos WHERE produto_id =1
	WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;

SELECT *FROM produtos;
