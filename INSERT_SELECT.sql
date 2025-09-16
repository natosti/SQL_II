-- insert_select_complexo.sql

----CRIANDO TABELA
CREATE DATABASE DB1609DB_VENDAS;
GO

USE DB1609DB_VENDAS
GO

---CRIAR AS 3 TABELAS PRINCIPAIS PARA SIMULAR A INSERÇÃO COMPLEXA

CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY IDENTITY(1,1), ---INTEIRO E CHAVE PRIMÁRIA
	nome_cliente VARCHAR(100),
	email_cliente VARCHAR(100)
);

CREATE TABLE produtos(
	produto_id INT PRIMARY KEY IDENTITY(1,1),
	nome_produto VARCHAR(100),
	preco DECIMAL(10, 2)
);

CREATE TABLE vendas(
	venda_id INT PRIMARY KEY IDENTITY(1,1),
	cliente_id INT,
	produto_id INT,
	quantidade INT,
	data_venda DATE,

	FOREIGN KEY(cliente_id) REFERENCES clientes(cliente_id),
	FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);

-----INSERIR DADOS DE EXEMPLOS NAS TABELAS
INSERT INTO clientes (nome_cliente, email_cliente) VALUES
('Jotal Genuino','jota@gmail.com'),
('Gabriel Souza','gabriel@hotmail.com'),
('Natalia Sales','nath@outlook.com')

INSERT INTO produtos (nome_produto, preco) VALUES
('Laptop', 3600.00),
('Smartphone',800.00),
('Cadeira Gamer',1800.00)

INSERT INTO vendas (cliente_id,produto_id,quantidade,data_venda) VALUES
(1,1,2,'2025-03-01'), ---CLIENTE 1 COMPROU PRODUTO 1 EM 1 UNIDADE
(2,2,1,'2025-03-01'),
(1,3,1,'2025-03-02'),
(2,1,1,'2025-03-02'),
(3,3,3,'2025-03-03');

---REALIZANDO A INSERÇÃO AVANÇADA COM INSERT...SELECT
---AGORA VAMOS REALIZAR UM INSER AVANÇADO, ONDE IREMOS CALCULAR O TOTAL DE VENDAS PARA CADA CLIENTE,
---AGRUPANDO RESULTADOS E INSERINDO EM UMA NOVA TABELA.

CREATE TABLE relatorio_vendas_clientes(
	cliente_id INT, ---AQUI NAO USOU PRIMARY KEY POIS NAO TEM ID, NAO TEM INDEXADOR, POIS N USARÁ PRA OUTRAS COISAS
	nome_cliente VARCHAR(100),
	produto_id INT,
	nome_produto VARCHAR(100),
	total_gasto DECIMAL (10,2)
);

INSERT INTO relatorio_vendas_clientes(cliente_id,nome_cliente,produto_id,nome_produto,total_gasto)
SELECT c.cliente_id, 
	   c.nome_cliente,
	   p.produto_id,
	   p.nome_produto,
	   SUM (v.quantidade * p.preco) AS total_gasto
FROM vendas v

JOIN clientes c ON v.cliente_id = c.cliente_id
JOIN produtos p ON v.produto_id = p.produto_id

GROUP BY c.cliente_id, c.nome_cliente, p.produto_id, p.nome_produto

---EXIBIR O RESUTLTADO DO INSERT COMPLEXO
SELECT * FROM relatorio_vendas_clientes

---INSERINDO APENAS OS CLIENTES QUE GASTARAM MAIS DE 3000 NO TOTAL COM FILTRO ADICIONAL NA 
---HORA DE AGREGAR

INSERT INTO relatorio_vendas_clientes 
(cliente_id,nome_cliente,produto_id,nome_produto,total_gasto)
SELECT c.cliente_id,
	   c.nome_cliente,
	   p.produto_id,
	   p.nome_produto,
	   SUM(v.quantidade * p.preco) AS total_gasto

FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id
JOIN produtos p ON v.produto_id = p.produto_id
GROUP BY c.cliente_id, c.nome_cliente, p.produto_id, p.nome_produto
HAVING SUM(v.quantidade * p.preco) > 3000;