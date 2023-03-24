
   -- O que � um Equijoin?
   -- A jun��o equijoin conecta duas ou mais tabelas de acordo com dados que s�o comuns a elas,
   --resumindo ela procura  por dados id�nticos nas tabelas envolvidas.

   --   Non-Equijoin
   -- A jun��o  non-Equijoin procura por relaciomentos que n�o correspondam a uma
   -- condi��o de igualdade, s�o geralmente utilizados  para verificar valores
   -- dentro de um certo conjunto de dados.

   --  Outer Joins
   -- Neste tipo de jun��o temos como resultado dados existentes em uma tabela  que n�o
   -- possuem uma condi��o  de igualdade com outra, ou seja, os registros de liga��o s�o
   -- inclu�dos no resultado.
   -- Voc� pode utilizar um outer join para tamb�m visualizar as linhas que n�o correspondem a condi��o de Join
   -- O operador  de outer join � o sinal de adi��o (+).

   -- Self Joins
   -- Nas jun��es deste tipo s�o relacionados os dados de uma mesma tabela mais de uma vez, usando o mesmo
   -- racioc�nio de uma Equijoin, s� que nesse caso com a mesma tabela.


   -- Capitulo 05


  SELECT * FROM TALUNO;

  SELECT * FROM TCONTRATO;

  -- Produto Cartesiano -> ERRADO
  SELECT TALUNO.COD_ALUNO, TALUNO.NOME, TCONTRATO.TOTAL
  FROM TALUNO , TCONTRATO

  -- Correto
  SELECT TALUNO.COD_ALUNO, TALUNO.NOME, TCONTRATO.TOTAL
  FROM TALUNO, TCONTRATO
  WHERE TALUNO.COD_ALUNO = TCONTRATO.COD_ALUNO          -- crit�rio de uni�o de tabelas com where

  UPDATE TALUNO SET
  NOME = 'MARCOS'
  WHERE COD_ALUNO = 5

  -- Errado - Coluna ambigua
  SELECT COD_ALUNO, TALUNO.NOME, TCONTRATO.TOTAL       -- jeito certo> SELECT TALUNO.COD_ALUNO, TALUNO.NOME, TCONTRATO.TOTAL
  FROM TALUNO, TCONTRATO
  WHERE TALUNO.COD_ALUNO = TALUNO.COD_ALUNO
  --Correto, quando uma coluna existe com mesmo nome em mais de uma tabela,
  --colocar prefixo na coluna




  --Uniao da tabela de aluno com contrato
  SELECT ALU.COD_ALUNO, ALU.NOME AS ALUNO,
         CON.COD_CONTRATO,CON.DATA, CON.TOTAL

  FROM TALUNO ALU, TCONTRATO CON       -- Exemplo de apelido na tabela

  WHERE CON.COD_ALUNO = ALU.COD_ALUNO    --Criterio Uniao

  AND Upper(ALU.NOME) LIKE '%'           --Filtro

  ORDER BY ALU.NOME                      --Ordenar por nome





  ------------------------------------------

  SELECT * FROM TALUNO
  SELECT * FROM TCONTRATO
  SELECT * FROM TITEM
  SELECT * FROM TCURSO

  SELECT ALU.COD_ALUNO, ALU.NOME AS ALUNO,
         CON.COD_CONTRATO, CON.DATA, CON.TOTAL,
         ITE.COD_CURSO, CUR.NOME AS CURSO,
         ITE.VALOR

  FROM TALUNO ALU, TCONTRATO CON,
       TITEM ITE, TCURSO CUR

  WHERE ALU.COD_ALUNO = CON.COD_ALUNO(+)  --Criterio Uniao
  AND   CON.COD_CONTRATO = ITE.COD_CONTRATO(+)
  AND   ITE.COD_CURSO = CUR.COD_CURSO(+)

  ORDER BY CON.TOTAL DESC;

  INSERT INTO TALUNO VALUES (10, 'PEDRO', 'NOVO HAMBURGO', NULL)  -- N�o funcionou dessa forma
  -- INSERT INTO TALUNO(COD_ALUNO, NOME, CIDADE,CEP)
--VALUES (10, 'PEDRO', 'NOVO HAMBURGO', N            -- Funcionou dessa forma


----------------------------------------------------

  CREATE TABLE TDESCONTO
  ( CLASSE VARCHAR(1) PRIMARY KEY,
    INFERIOR NUMBER(4,2),
    SUPERIOR NUMBER(4,2)
   );

  INSERT INTO TDESCONTO VALUES ('A',00,10);
  INSERT INTO TDESCONTO VALUES ('B',11,15);
  INSERT INTO TDESCONTO VALUES ('C',16,20);
  INSERT INTO TDESCONTO VALUES ('D',21,25);
  INSERT INTO TDESCONTO VALUES ('E',26,30);

  SELECT * FROM TDESCONTO;


  COMMIT;


  ---------

  SELECT * FROM TCONTRATO

  UPDATE TCONTRATO SET
  DESCONTO = 27
  WHERE COD_CONTRATO = 6;


  UPDATE TCONTRATO SET
  DESCONTO = 18
  WHERE COD_CONTRATO = 5;


  -------------
  SELECT	CON.COD_CONTRATO AS CONTRATO, CON.DESCONTO,
          DES.CLASSE AS DESCONTO

  FROM	  TCONTRATO CON, TDESCONTO DES
  WHERE CON.DESCONTO BETWEEN DES.INFERIOR AND DES.SUPERIOR

  ORDER BY CON.COD_CONTRATO;


  --Mostrar cursos vendidos
  SELECT CUR.COD_CURSO, CUR.NOME, ITE.VALOR
  FROM TCURSO CUR, TITEM ITE
  WHERE CUR.COD_CURSO = ITE.COD_CURSO


  --Mostrar cursos nao vendidos
  SELECT CUR.COD_CURSO, CUR.NOME, ITE.COD_ITEM
  FROM TCURSO CUR, TITEM ITE
  WHERE CUR.COD_CURSO = ITE.COD_CURSO(+)
  AND ITE.COD_ITEM IS NULL;

  SELECT * FROM TCURSO

  INSERT INTO TCURSO VALUES (6, 'PHP', 1000, 100);-- erro na hora de executar
  INSERT INTO TCURSO VALUES (7,'LOGICA',100,20)



  --Add coluna na tabela
  ALTER TABLE TCURSO ADD PRE_REQ INTEGER;


  SELECT * FROM TCURSO

  UPDATE TCURSO SET PRE_REQ = 7
      WHERE COD_CURSO = 1;

  UPDATE TCURSO SET PRE_REQ = 7
      WHERE COD_CURSO = 3;

  UPDATE TCURSO SET PRE_REQ = 1
      WHERE COD_CURSO = 2;

  UPDATE TCURSO SET PRE_REQ = 3
      WHERE COD_CURSO = 4;

  UPDATE TCURSO SET PRE_REQ = 7
      WHERE COD_CURSO = 6;


  --Select de duas tabelas (a mesma tabela)
  SELECT Curso.Nome AS Curso,
         Pre_Req.Nome AS Pre_Requisito

  FROM TCURSO CURSO, TCURSO PRE_REQ
  WHERE CURSO.PRE_REQ = PRE_REQ.COD_CURSO(+)


 --Fim