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
create or replace function get_aluno(pCODIGO NUMBER)
RETURN TABLE_REG_ALUNO PIPELINED
IS
 outLista REG_ALUNO;
    CURSOR CSQL IS
        SELECT ALU.COD_ALUNO, ALU.NOME, ALU.CIDADE
        FROM TALUNO ALU
        WHERE ALU.COD__ALUNO = pCODIGO;
    REG CSQL%ROWTYPE;
BEGIN
open CSQL;
fetch CSQL into reg;
outLista := REG_ALUNO(REG.COD_ALUNO, REG.NOME, REG.CIDADE);
PIPE ROW (outLista); --escreve a linha
close CSQL;
RETURN;
END;


