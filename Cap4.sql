--
SELECT * FROM TALUNO;

--
SELECT Concat(COD_ALUNO,NOME) FROM TALUNO; -- FUNÇÃO CONCAT JUNTA DUAS COLUNAS  OU DOIS VALORES

--
SELECT COD_ALUNO||' - '||NOME FROM TALUNO; -- MESMA MANEIRA DE JUNTAR COLUNAS OU DOIS VALORES USANDO ||   (CONCATENA)

--
SELECT nome, InitCap(NOME) FROM TALUNO;   -- INITCAP TRANFORMA A PRIMEIRA LETRA DE CADA PALVARA EM MAIÚSCULA E O RESTO EM MINÚSCULA

--
SELECT nome, InStr(NOME,'R') FROM TALUNO; -- InStr rertorna dentro do caractere a posição da letra ex(R)

--
SELECT nome, Length(NOME) FROM TALUNO;  -- CONTA QUANTOS CARACTERES TEM (LENGTH)

--
SELECT nome, Lower(NOME) FROM TALUNO    --  LOWER TRANSFORMA PARA MINÚSCULO, SÓ PARA O SELECT

--
SELECT nome, Upper(NOME) FROM TALUNO;   -- UPPER TRANSFORMA PARA MAIÚSCULA

--
SELECT InitCap('JOSE DA SILVA') FROM dual;  --  InitCap transforma as primeiras letras em maiúsculas

-- left - esquerda
SELECT cod_aluno, LPad(COD_ALUNO,5,'0') FROM TALUNO; -- formata os números a esquerda coloca caracteres a esquerda

-- direita
SELECT nome, salario, RPad(SALARIO,8,'0') FROM TALUNO; -- Rpad coloca caracteres a direita

--
SELECT nome, RPad(NOME,10,'$') FROM TALUNO;   -- Rpad coloca caracteres a direita   até dez caracteres


-- copia parte de um texto
-- substr ( campo/texto, posicao, qtde de caract )
SELECT nome, SubStr(NOME,1,3) FROM TALUNO;

--
SELECT SubStr(NOME,1,1) FROM TALUNO;

--
SELECT nome, SubStr(NOME,3,1) FROM TALUNO;

--
SELECT REPLACE(Upper(NOME),'R','$') FROM TALUNO;  -- replace substituir 'R' POR '$' APENAS NO SELECT

--

SELECT SubStr(NOME,Length(nome),1) FROM TALUNO;   -- COPIA O ÚLTIMO CARACTERE

--
SELECT SubStr(NOME,Length(nome)-1, 2) FROM TALUNO;-- COPIA OS DOIS ÚLTIMOS CARACTERES

--
SELECT nome, SubStr(NOME, 3, Length(nome)-3 ) FROM TALUNO; -- COPIA A PARTIR DA POSIÇÃO TRÊS OS DOIS ÚLTIMOS CARACTERES


--
SELECT * FROM TALUNO
WHERE Lower(NOME) = 'marcio';  -- LOWER TRANSFORMA EM MINÚSCULA PARA O SELECT

SELECT * FROM TALUNO
WHERE Upper(NOME) = 'MARCIO';  -- FAZ O MESMO - É MAIS USADO QUE O ANTERIOR

SELECT * FROM TALUNO
WHERE Upper(SubStr(CIDADE,1,3)) = 'CAN'; -- CONSULTA TODOS OS ALUNOS, CUJO AS TRES PRIMEIRAS LETRAS ESTÃO CADASTRADAS COM "CAN".
 -- Upper(SubStr(CIDADE,1,3) VAI COPIAR AS 3 PRIMEIRAS LETRAS E TANFORMAR EM MAIÚSCULO, E COMPARAR COM A STRING "CAN".


UPDATE TALUNO SET
SALARIO = 633.47
WHERE COD_ALUNO = 1;


SELECT
  SALARIO,
  REPLACE(SALARIO, ',' , ''),
  RPad(SALARIO, 10,'0'),     --Zeros a direita até 10 casas
  LPad(SALARIO, 10,'0'),     --Zeros a esquerda até 10 casas
  LPad(REPLACE(SALARIO,',',''),10,'0')
FROM TALUNO;



------------------Data
SELECT * FROM DUAL;   -- DUAL TABELA VIRTUAL

--SysDate retorna data/hora do Servidor.
SELECT SYSDATE FROM DUAL;  -- TRAZ A DATA E HORA ATUAL

-- Round e Trunc
SELECT Round(45.925, 2 ),  --45.93   -- ROUND ARREDONDA NO NUMERO
       Trunc(45.929, 2 ),  --45.92   -- TRUNC ARREDONDA PARA BAIXO
       Mod(10, 2) AS RESTO_DIVISAO,  -- MOD FAZ O RESTO DA DIVISÃO
       Trunc(1.99),
       Trunc(1.99, 2)
FROM DUAL;

SELECT * FROM TCONTRATO;

--Funcoes de Data/Hora
SELECT DATA, SYSDATE, DATA + 5 FROM TCONTRATO;  -- CONSULTA, DATA ATUAL, SYSDATE DATA ATUAL, DATA + 5 = DATA + CINCO DIAS

SELECT SYSDATE - DATA AS DIF_DIAS FROM TCONTRATO;

SELECT Trunc(SYSDATE - DATA) as DIAS FROM TCONTRATO;

--Somando horas em uma data
SELECT SYSDATE, SYSDATE + 5 / 24 as ADD_HORAS FROM TCONTRATO;

--Somar minutos
SELECT SYSDATE, SYSDATE + 15 / 1440 as ADD_MINUTOS FROM TCONTRATO;

SELECT SYSDATE, SYSDATE + 30 / (3600 * 24) as ADD_SEGUNDOS FROM TCONTRATO;


--Hora fica 00:00:00
SELECT SYSDATE, Trunc(SYSDATE) FROM DUAL; -- mostra hora e data

--Diferenca de meses entre datas
SELECT Months_Between(SYSDATE, SYSDATE-90) AS DIF_MES FROM DUAL;

--Adiciona meses
SELECT Add_Months(SYSDATE, 5) AS ADICIONA_MES_DATA FROM DUAL;

--Proxima data a partir de uma dia da semana
SELECT Next_Day(SYSDATE, 'QUARTA-FEIRA') AS PROXIMA_QUARTA_DATA FROM DUAL; -- erro aguardando resposta
select to_char(sysdate, 'DAY') from dual

--Ultimo dia do mes
SELECT Last_Day(SYSDATE) AS ULTIMO_DIA_MES FROM DUAL;  -- mostra o último dia do mês

--Primeiro dia do proximo mes
--até dia 15 do mes pega o primeiro dia do mes atual
--a partir do dia 16 retorna o primeiro dia do proximo mes


--Primeiro dia do mes
SELECT Trunc(SYSDATE,'MONTH') AS PRIMEIRO_DIA_MES_CORRENTE FROM DUAL;   -- mostra o primeiro dia do mês


---Formatação de data

--Conversor to_char(data, formato)

--DD -> dia do mes
SELECT SYSDATE, To_Char(SYSDATE,'DD') FROM DUAL  --mostra dia do mês

--
SELECT To_Char(SYSDATE,'DD/MM/YYYY') DATA FROM DUAL;

SELECT To_Char(SYSDATE,'DD/MM') DIA_MES FROM DUAL;

SELECT To_Char(SYSDATE,'DD') DIA FROM DUAL;

SELECT To_Char(SYSDATE,'MM') MES FROM DUAL;

SELECT To_Char(SYSDATE,'YYYY') ANO FROM DUAL;

SELECT To_Char(SYSDATE,'YY') ANO FROM DUAL;

--
SELECT To_Char(SYSDATE,'MONTH') MES1 FROM DUAL;

--
SELECT To_Char(SYSDATE,'D') DIA_SEMANA FROM DUAL;

--
SELECT To_Char(SYSDATE,'DY') DIA_SEMANA FROM DUAL;   -- QUA

--
SELECT To_Char(SYSDATE,'DAY') DIA_SEMANA1 FROM DUAL; -- QUARTA

--
SELECT To_Char(SYSDATE,'YEAR') ANO FROM DUAL;        -- Em Ingles

--
SELECT To_Char(SYSDATE,'"NOVO HAMBURGO", fmDAY "," DD "de" fmMonth "de" YYYY') FROM DUAL;

--
SELECT To_Char(SYSDATE,'HH24:MI') HORA_MIN FROM DUAL;

--
SELECT To_Char(SYSDATE,'HH24:MI:SS') HORA_MIN_SEG FROM DUAL;

--
SELECT To_Char(SYSDATE,'DD/MM HH24:MI') DATA_HORA FROM DUAL;

--
SELECT To_Char(SYSDATE,'DD/MM/YYYY HH24:MI:SS') DATA_HORA FROM DUAL;




--L -> R$
--G -> ponto
--D -> casas decimais
-- tRIM ESPAÇOES EM BRANCO

SELECT * FROM TALUNO

SELECT Trim(To_Char(Salario,'L99999.99')) salario1, trim(To_Char(Salario,'L99G999D99')) salario2
FROM TALUNO;

--
SELECT 'R$ '||(Round(Salario,2)) AS salario FROM TALUNO;



-----
--NVL e NVL2
SELECT * FROM tcontrato;

SELECT Total,
       Desconto,
       Desconto+Total,
       Nvl(Desconto,0),
       Nvl(Desconto,0) + TOTAL,
       Nvl2(DESCONTO, TOTAL, 0)
FROM TContrato;

SELECT * FROM TALUNO

UPDATE TALUNO SET
NOME = NULL
WHERE COD_ALUNO = 5;

SELECT Cod_Aluno, Nvl(Nome, 'SEM NOME') FROM TALUNO

SELECT * FROM TALUNO;


UPDATE TAluno SET
Estado = 'SC'
WHERE Cod_Aluno=3;

UPDATE TAluno SET
Estado = 'RJ'
WHERE Cod_Aluno=5;

--Case
SELECT NOME, Estado,
       CASE
         WHEN Estado = 'RS' THEN 'GAUCHO'
         WHEN Estado = 'AC' THEN 'ACREANO'
         WHEN Estado = 'RJ' AND SALARIO > 500 THEN 'CARIOCA'
         ELSE 'OUTROS'
       END AS Apelido
FROM TALUNO;

--
SELECT SYSDATE AS DATA FROM DUAL

--
SELECT NOME, ESTADO,                     -- FAZ O MESMO QUE O ANTERIOR
       Decode(ESTADO,'RS','GAUCHO',
                     'AC','ACREANO',
                     'SP','PAULISTA',
                          'OUTROS' ) AS APELIDO
FROM TALUNO;



---------- Fim ----------