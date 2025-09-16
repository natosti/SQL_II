
---VAMOS USAR A TABELA DE VENDAS J� FEITA NO EXERC�CIO ANTERIOR
USE DB1609DB_VENDAS
GO


---INSERE A COLUNA DE VALOR TOTAL QUE FALTA NA TABELA DE VENDAS
ALTER TABLE vendas
ADD valor_total DECIMAL (10,2)


--- A L�GICA AQUI � REALIZAR M�LTIPLAS INSER��ES DE FORMA CONTROLADA, USANDO VARI�VEIS PARA ARMAZENAR DADOS

---INICIALIZAR TRANSA��O
BEGIN TRANSACTION;

--- DECLARAR AS VARI�VEIS - @ � USANDO OU CRIANDO VARI�VEIS - UMA CAIXINHA
DECLARE @cliente_id INT = 1; --- CLIENTE PARA O PEDIDO (JOTAEL)
DECLARE @produto_id INT = 2; --- PRODUTO COMPRADO (SMARTPHONE)
DECLARE @quantidade INT = 3; --- QUANTIDADE COMPRADA 3 UNIDADES)
DECLARE @valor_total DECIMAL (10,2); --- VALOR TOTAL DO PEDIDO
DECLARE @data_venda DATETIME = GETDATE() --- DATA ATUAL DA VENDA
DECLARE @status_transacao VARCHAR(50)

--- CALCULAR O VALOR TOTAL DA VENDA
SELECT @valor_total = p.preco * @quantidade
FROM produtos p
WHERE p.produto_id = @produto_id;

---VALIDA��O PARA GARANTIR QUE A QUANTIDADE SEJA V�LIDA
IF @quantidade <=0
BEGIN
	SET @status_transacao = 'Falha: Quantidade Inv�lida!';
	ROLLBACK TRANSACTION;  --- REVERTE A TRANSA��O CASO A QTD SEJA INV�LIDA
	PRINT @status_transacao;
	RETURN;
END

---INSERINDO OUTRA VENDA USANDO NOSSO NOVO 'M�TODO'
INSERT INTO vendas (cliente_id,produto_id,quantidade,valor_total,data_venda)
VALUES (@cliente_id, @produto_id, @quantidade, @valor_total, @data_venda);

---VALIDANDO O SUCESSO DA INSER��O
IF @@ERROR <> 0
BEGIN
	SET @status_transacao = 'Falha: Erro na Inser��o da Venda';
	ROLLBACK TRANSACTION;
	PRINT @status_transacao;
	RETURN;
END

--- SE TODAS AS INSER��ES FOREM OK, CONFIRMA A TRANSA��O
SET @status_transacao = 'Sucesso: Vendas Inseridas com Sucesso';
COMMIT TRANSACTION; ---confirmando a transa��o


---VERIFICANDO O STATUS DA TRANSA��O - PRINT EXIBE O QUE EST� EM ALGUM LOCAL
PRINT @status_transacao

---VERIFICANDO OS DADOS INSERIDOS - VEJO TUDO O QUE TEM NO BANCO
SELECT * FROM vendas;

----------------------------- CASO DE FALHA -------------------------

BEGIN TRANSACTION;
DECLARE @cliente_id INT = 1; --- CLIENTE PARA O PEDIDO (JOTAEL)
DECLARE @produto_id INT = 2; --- PRODUTO COMPRADO (SMARTPHONE)
DECLARE @quantidade INT = 3; --- QUANTIDADE COMPRADA 3 UNIDADES)
DECLARE @valor_total DECIMAL (10,2); --- VALOR TOTAL DO PEDIDO
DECLARE @data_venda DATETIME = GETDATE() --- DATA ATUAL DA VENDA
DECLARE @status_transacao VARCHAR(50)


SET @quantidade = -1;
SET @cliente_id = 1
SET @produto_id = 1
SET @data_venda = GETDATE()

SELECT @valor_total = p.preco * @quantidade
FROM produtos p
WHERE p.produto_id = @produto_id;

IF @quantidade <=0
BEGIN
	SET @status_transacao = 'Falha: Quantidade Inv�lida!';
	ROLLBACK TRANSACTION;  --- REVERTE A TRANSA��O CASO A QTD SEJA INV�LIDA
	PRINT @status_transacao;
	RETURN;
END

INSERT INTO vendas (cliente_id,produto_id,quantidade,valor_total,data_venda)
VALUES (@cliente_id, @produto_id, @quantidade, @valor_total, @data_venda);

COMMIT TRANSACTION;