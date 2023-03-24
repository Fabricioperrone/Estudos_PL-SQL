create or replace function consulta_preco(pCod_Curso NUMBER) RETURN NUMBER
as
    vValor NUMBER;
begin
    select valor INTO vValor from Tcurso
    where cod_curso = pCod_Curso;
    
    return(vValor);
end;




--Teste | Usando function
declare
    vCod NUMBER := &codigo;
    vValor NUMBER;
begin
    vValor := consulta_preco(vCod);
    dbms_output.put_line('Preco do curso '||vValor);
end;

-- Function PIPELINED
-- Conectado como System
GRANT TYPE ANY TYPE TO FABRICIO
--REGISTRO -ARRAY
DROP TYPE TABLE_REG_ALUNO;

CREATE OR REPLACE TYPE REG_ALUNO AS OBJECT
( CODIGO INTEGER,
  NOME VARCHAR2(30),
  CIDADE VARCHAR(30)  );
  
--MATRIZ
CREATE OR REPLACE TYPE TABLE_REG_ALUNO AS TABLE OF REG_ALUNO;


--ARRAY
[0][1][2][3][4]

--MATRIZ

[0][1][2][3][4]
[1][1][2][3][4]
[2][][][][]

--Function que retorna registros
CREATE OR REPLACE FUNCTION GET_ALUNO(pCODIGO NUMBER)
RETURN TABLE_REG_ALUNO PIPELINED
IS
    outLista REG_ALUNO;
    CURSOR CSQL IS
        SELECT ALU.COD_ALUNO, ALU.NOME, ALU.CIDADE
        FROM TALUNO ALU
        WHERE ALU.COD_ALUNO = pCODIGO;
    REG CSQL%ROWTYPE;
BEGIN
    OPEN CSQL;
    FETCH CSQL INTO REG;
    outLista := REG_ALUNO(REG.COD_ALUNO, REG.NOME, REG.CIDADE);
    PIPE ROW(outLista);-- Escreve a linha
    CLOSE CSQL;
    RETURN;
END;

---USANDO
SELECT * FROM TABLE(GET_ALUNO(1));

--USANDO
SELECT ALU.*, CON.total
FROM TABLE(GET_ALUNO(1)) ALU, TCONTRATO CON
WHERE CON.COD_ALUNO = ALU.CODIGO

--
CREATE OR REPLACE FUNCTION GET_ALUNOS RETURN TABLE_REG_ALUNO PIPELINED
IS
    outLista REG_ALUNO;
    CURSOR CSQL IS
        SELECT COD_ALUNO, NOME, CIDADE FROM TALUNO;
    REG CSQL%ROWTYPE;
BEGIN
    FOR REG IN CSQL
    LOOP -----*****
    outLista := REG_ALUNO(REG.COD_ALUNO, REG.NOME, REG.CIDADE);
    PIPE ROW(outLista);
END LOOP -------********
RETURN;

END;

-- USANDO
SELECT * FROM TABLE(GET_ALUNOS);





