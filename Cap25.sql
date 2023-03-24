--Capitulo 25

SELECT COD_ALUNO, Trunc(DATA),
        Sum(DESCONTO) DESCONTO,
        Sum(TOTAL) TOTAL
FROM    TCONTRATO
GROUP BY ROLLUP(COD_ALUNO, Trunc(DATA));

--
SELECT COD_ALUNO,
      CASE
        WHEN Trunc(DATA) IS NULL AND COD_ALUNO IS NOT NULL
          THEN 'SUB-TOTAL'
        WHEN COD_ALUNO IS NULL
          THEN'TOTAL'
        ELSE To_Char(Trunc(DATA))
        END DESCRICAO,
        Round(Avg(DESCONTO),2) DESCONTO,
        Sum(TOTAL) TOTAL
FROM    TCONTRATO
GROUP BY ROLLUP(COD_ALUNO, Trunc(DATA) );

-- Parte 3

SELECT COD_ALUNO,
       Trunc(DATA),     -- zera a hora
       Sum(TOTAL)
FROM TCONTRATO
GROUP BY CUBE(COD_ALUNO,(DATA));

--
SELECT * FROM TCONTRATO;

--------------------------- IDENTIFICA  TOTAL GERAL
SELECT Grouping(COD_ALUNO), Sum(TOTAL)
FROM TCONTRATO
GROUP BY ROLLUP(COD_ALUNO);

------------------------
SELECT Grouping(COD_ALUNO),
   CASE
    WHEN Grouping(COD_ALUNO) = 0 THEN  To_Char(COD_ALUNO)
    ELSE 'Total Geral: '
    END ALUNO,
    Sum(TOTAL)
FROM TCONTRATO
GROUP BY ROLLUP(COD_ALUNO);
---------------------------------
SELECT Trunc(DATA),
      Grouping_ID(Trunc(DATA)) GDT,
      COD_ALUNO,
      Grouping_ID(COD_ALUNO) GCL,
      Sum(TOTAL)
FROM TCONTRATO
GROUP BY ROLLUP (Trunc (DATA), COD_ALUNO);


--------------------*************
SELECT Trunc(DATA), COD_ALUNO,
    CASE
      WHEN GROUPING_ID(COD_ALUNO)=1 AND
        Grouping_ID(Trunc(DATA))=0 THEN 'TOTAL DO DIA : '
      WHEN GROUPING_ID(COD_ALUNO)=1 AND
           GROUPING_ID(Trunc(DATA))=1 THEN 'TOTAL GERAL :'
      END AS DESCRICAO,
      Sum(TOTAL) TOTAL
FROM TCONTRATO
GROUP BY ROLLUP(Trunc(DATA), COD_ALUNO);

---------------- AULA 4
------********* Retorna somente  subtotais
SELECT cod_aluno, Trunc(data), Sum(total)
FROM tcontrato
GROUP BY Grouping sets (cod_aluno, Trunc(data) );



-------------------**************
--Total igual repete o rank
-- 1 - 1 - 3 - 4 - 4- 6
SELECT Trunc(DATA), cod_aluno, Sum(total),
       Rank() OVER (ORDER BY Sum(total) desc) POSICAO

FROM TCONTRATO
GROUP BY (Trunc(DATA), COD_ALUNO)

-------------------------**********
-- RANK -> 1 - 2 - 3 - 3 - 5
SELECT COD_ALUNO, Sum (TOTAL),
      Rank() OVER (ORDER BY Sum (TOTAL) DESC) POSICAO
FROM TCONTRATO
GROUP BY (COD_ALUNO);

---------------------**********Posição por grupo
-- Rank -> 1 - 2 - 1 - 2
SELECT Trunc(DATA), COD_ALUNO, Sum(TOTAL),
       Rank () OVER (PARTITION BY Trunc(DATA)
        ORDER BY Sum(TOTAL) DESC) POSICAO
FROM TCONTRATO
GROUP BY (Trunc(DATA), COD_ALUNO)
ORDER BY TRUNC (DATA);

-----------------

SELECT COD_CONTRATO, TOTAL,
    Rank() OVER (ORDER BY TOTAL DESC) "RANK()",
    Dense_Rank() OVER (ORDER BY TOTAL DESC) "DENSE_RANK()"
FROM TCONTRATO
GROUP BY COD_CONTRATO, TOTAL;

----------------------
SELECT COD_ALUNO, Sum(TOTAL) "Total DO cliente",
  Round (ratio_to_report (Sum(total)) OVER()*100,2)"% DO total"
FROM tcontrato
GROUP BY cod_aluno;

----------------*****
SELECT COD_ALUNO,
      Trunc(DATA),
      Sum(total) "Total DO dia",
      Round(Ratio_To_Report(Sum(total)) OVER (PARTITION BY
      Trunc(data)) * 100,2) "% DO dia"
FROM tcontrato
GROUP BY cod_aluno, Trunc(data)
ORDER BY 2 ASC, cod_aluno;

---------------**********
SELECT Trunc(data), Sum (total) total_dia,
  Lag (Sum(total),1) OVER (ORDER BY Trunc(data)) anterior,
  Lead(Sum(total),1) OVER (ORDER BY Trunc(data))posterior
FROM tcontrato
GROUP BY Trunc (data)
ORDER BY trunc (data);





