
---VAMOS USAR A TABELA DE VENDAS JÁ FEITA NO EXERCÍCIO ANTERIOR
USE DB1609DB_VENDAS
GO


---INSERE A COLUNA DE VALOR TOTAL QUE FALTA NA TABELA DE VENDAS
ALTER TABLE vendas
ADD valor_total DECIMAL (10,2)


--- A LÓGICA AQUI É REALIZAR MÚLTIPLAS INSERÇÕES DE FORMA CONTROLADA, USANDO VARIÁVEIS PARA ARMAZENAR DADOS

---INICIALIZAR TRANSAÇÃO
BEGIN TRANSACTION;

--- DECLARAR AS VARIÁVEIS - @ É USANDO OU CRIANDO VARIÁVEIS - UMA CAIXINHA
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

---VALIDAÇÃO PARA GARANTIR QUE A QUANTIDADE SEJA VÁLIDA
IF @quantidade <=0
BEGIN
	SET @status_transacao = 'Falha: Quantidade Inválida!';
	ROLLBACK TRANSACTION;  --- REVERTE A TRANSAÇÃO CASO A QTD SEJA INVÁLIDA
	PRINT @status_transacao;
	RETURN;
END

---INSERINDO OUTRA VENDA USANDO NOSSO NOVO 'MÉTODO'
INSERT INTO vendas (cliente_id,produto_id,quantidade,valor_total,data_venda)
VALUES (@cliente_id, @produto_id, @quantidade, @valor_total, @data_venda);

---VALIDANDO O SUCESSO DA INSERÇÃO
IF @@ERROR <> 0
BEGIN
	SET @status_transacao = 'Falha: Erro na Inserção da Venda';
	ROLLBACK TRANSACTION;
	PRINT @status_transacao;
	RETURN;
END

--- SE TODAS AS INSERÇÕES FOREM OK, CONFIRMA A TRANSAÇÃO
SET @status_transacao = 'Sucesso: Vendas Inseridas com Sucesso';
COMMIT TRANSACTION; ---confirmando a transação


---VERIFICANDO O STATUS DA TRANSAÇÃO - PRINT EXIBE O QUE ESTÁ EM ALGUM LOCAL
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
	SET @status_transacao = 'Falha: Quantidade Inválida!';
	ROLLBACK TRANSACTION;  --- REVERTE A TRANSAÇÃO CASO A QTD SEJA INVÁLIDA
	PRINT @status_transacao;
	RETURN;
END

INSERT INTO vendas (cliente_id,produto_id,quantidade,valor_total,data_venda)
VALUES (@cliente_id, @produto_id, @quantidade, @valor_total, @data_venda);

COMMIT TRANSACTION;