-- Capitulo 22
-- CREATE [OR REPLACE] PACKAGE nome_package
--IS|AS
-- DECLARA��O DE VARIAVEL
-- DECLARA��O DE CURSOR
-- DECLARA�AO DE PROCEDIMENTO
-- DECLARA��O DE FUN�AO
--END;[nome_package};

-- ESPECIFICA��O OU DECLARA��O
CREATE OR REPLACE PACKAGE PKG_ALUNO
IS
  vCidade VARCHAR2(30); --Vari�vies p�blicas
  vMedia  NUMBER(8,2);   --Vari�vies p�blicas
  vNome   VARCHAR2(30);  --Vari�vies p�blicas
  PROCEDURE DELETA_ALUNO(pCod_ALUNO NUMBER);
  PROCEDURE MEDIA_CONTRATOS;
  PROCEDURE CON_ALUNO(pCOD_ALUNO NUMBER);
 END;


-------
------- CORPO
CREATE OR REPLACE PACKAGE BODY PKG_ALUNO -- CORPO
IS
-- Vari�veis locais
 vTESTE VARCHAR(20);
 --*************
 PROCEDURE MEDIA_CONTRATOS
 IS
 BEGIN
  vTESTE :=  'teste';
  SELECT Avg(total) INTO vMEDIA FROM tcontrato;
  END;
  --************consulta aluno
  PROCEDURE CON_ALUNO(pCOD_ALUNO NUMBER)
  IS
  BEGIN
   vNOME := '';
   SELECT NOME INTO vNOME FROM TALUNO
   WHERE COD_ALUNO=pCOD_ALUNO;
  EXCEPTION
    WHEN No_Data_Found THEN
     Dbms_Output.Put_Line('Aluno nao existe');
    END;
   --****************
   PROCEDURE DELETA_ALUNO(pCOD_ALUNO NUMBER)
   IS
   BEGIN
    CON_ALUNO(pCOD_ALUNO);
    IF Length(vNOME) > 0 THEN
    DELETE FROM TALUNO WHERE COD_ALUNO = pCOD_ALUNO;
    Dbms_Output.Put_Line('->Excluido');
  END IF;
END;

END;

--usando
EXEC PKG_ALUNO.DELETA_ALUNO(62);


--
SELECT * FROM TALUNO;

--
DECLARE
 M NUMBER;
BEGIN
  pkg_aluno.media_contratos; --executa a procedure
  m := pkg_aluno.vmedia;
  Dbms_Output.Put_Line('Media: '||m);
END;

--
DECLARE




-- fim do package




