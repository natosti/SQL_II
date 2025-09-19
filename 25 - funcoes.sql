
/*===============================
1) GARANTIR QUE A FUN��O EXISTENTE EXISTA
Se n�o existir, criamos via EXEC(evita conflitos)
===============================*/


IF OBJECT_ID('dbo.fn_Media','FN') IS NULL   -- COM FN entende que � fun��o e consegue chamar as notas la de baixo
BEGIN
	EXEC('
		CREATE FUNCTION dbo.fn_Media(
			@n1 DECIMAL(5,2),
			@n2 DECIMAL(5,2)
		)
		RETURNS DECIMAL(5,2)
		AS
		BEGIN 
			RETURN(@n1+@n2) / 2
		END;
');
END;
GO

/*===============================
2) DADOS DE EXEMPLO
Tabela tempor�ria para n�o afetar nosso esquema
===============================*/

IF OBJECT_ID('tempdb..#Alunos') IS NOT NULL
DROP TABLE #Alunos;

CREATE TABLE #Alunos (
	id INT IDENTITY PRIMARY KEY,
	nome VARCHAR(100),
	nota1 DECIMAL(5,2),
	nota2 DECIMAL(5,2)
);

INSERT INTO #Alunos (nome, nota1,nota2)
VALUES
('Caio',8.5, 7.0),
('Gabriel',6.0,5.5),
('Jotael',9.0,9.5),
('Natalia',4.0,5.0);

/*===============================
3) CONSULTA USANDO A FUN��O J� EXISTENTE
===============================*/

SELECT 
	nome, 
	nota1, 
	nota2,
	dbo.fn_Media(nota1, nota2) AS Media_Atual
	FROM #Alunos
	ORDER BY nome;
	GO

/*===============================
4) CRIAR NOVA FUN��O (SEM ALTERAR A ANTIGA)
- Classifica Aprovado/Reprovado com base na fn_media
===============================*/

IF OBJECT_ID('dbo.fn_situacao2','FN') IS NOT NULL
	DROP FUNCTION dbo.fn_situacao2;
GO

CREATE FUNCTION dbo.fn_situacao2 (
	@n1 DECIMAL(5,2),
	@n2 DECIMAL(5,2))
	RETURNS VARCHAR(20)
	AS
	BEGIN
		DECLARE @media DECIMAL(5,2);
		SET @media = dbo.fn_Media(@n1,@n2)
		
		RETURN CASE
			WHEN @media >=7 THEN 'Aprovado!'
			ELSE 'REPROVADO'

		END;
	END;
	GO

/*===============================
5) CONSULTA FINAL USANDO AS DUAS FUN��ES
===============================*/

SELECT
	a.nome,
	a.nota1,
	a.nota2,
	dbo.fn_Media(a.nota1,a.nota2) AS Media
	dbo.fn_situacao2(a.nota1,a.nota2) AS Situacao
FROM #Alunos AS a
ORDER BY Media DESC, Nome;