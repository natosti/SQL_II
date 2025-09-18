
CREATE DATABASE db1609_DropOtimizado
GO

USE db1609_DropOtimizado
GO

CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME
);

INSERT INTO clientes(cliente_id,nome_cliente, data_cadastro)
VALUES 
(1, 'Caio Ross','2025-01-01'),
(2, 'Gabriel Sousa','2025-01-01'),
(3, 'Jotael Genuino','2025-01-01'),
(4, 'Natalia Sales','2025-01-01');

CREATE TABLE #clientes_temp(
	cliente_id INT,
	nome_cliente VARCHAR(100),
);

INSERT INTO #clientes_temp
(cliente_id, nome_cliente)
VALUES
(4, 'Nicola Tesla'),
(5, 'Heidy Lamar');

---melhor que o delete, pq nao armazena, mas não tem rollback
---deixa de existir sem registro, como se fosse excluir sem passar pela lixeira
---exclui todos os dados da tabela clientes - não registra a exclusão no log
---não pode ser revertido
TRUNCATE TABLE clientes; 

---aqui excluímos a tabela temporária, não apenas limpando seus dados, não reversível
DROP TABLE #clientes_temp;
