-- Capitulo 21
CREATE OR  REPLACE FUNCTION CONSULTA_PRECO
(pCod_Curso NUMBER) RETURN NUMBER
AS
 vValor NUMBER;
BEGIN
   SELECT valor INTO vValor FROM Tcurso
   WHERE cod_curso = pCod_Curso;

   RETURN(vValor);
END;

-- Teste| Usando function
DECLARE
  vCod NUMBER := &codigo;
  vValor NUMBER;
BEGIN
  vValor := consulta_preco(vCod);
  Dbms_Output.Put_Line('Preco do curso: '||vValor);
END;

----
CREATE OR REPLACE FUNCTION existe_aluno
(pCod_Aluno IN tAluno.Cod_Aluno%TYPE)
RETURN BOOLEAN
IS
 vAluno NUMBER(10);
BEGIN
  SELECT cod_Aluno
  INTO vAluno
  FROM taluno
  WHERE cod_aluno = pCod_Aluno;
  RETURN (TRUE);
EXCEPTION
  WHEN OTHERS THEN
    RETURN (FALSE);
END;
 -- teste
DECLARE
  vCodigo INTEGER :=2;
BEGIN
  IF EXISTE_ALUNO(vCodigo) THEN
    Dbms_Output.Put_Line('Codigo encontrado');
  ELSE
    Dbms_Output.Put_Line('Código nao encontrado');
  END IF;
END;
