--Capitulo 19  tratamento de exceções (erros)
DECLARE
  vCod taluno.cod_aluno%TYPE := 1;
  vCidade taluno.cidade%TYPE;
  x NUMBER;
BEGIN
  SELECT Cidade INTO vCidade
  FROM TAluno
  --where nome like '%';
  WHERE cod_aluno = vCod;
  x := 0 / 0;
  Dbms_Output.Put_Line('Cidade: '||vCidade);
EXCEPTION
  WHEN no_data_found THEN
    RAISE_APPLICATION_ERROR(-20001,
        'Aluno Inexistente" '||SQLCODE||''||SQLERRM);
  WHEN Too_Many_Rows THEN
    Raise_Application_Error(-20002,
        'Regsitro Duplicado" '||SQLCODE||''||SQLERRM);
  WHEN OTHERS THEN
    Raise_Application_Error(-20003,
        'Excecao Desconhecida! '||SQLCODE||''||SQLERRM);
  END;

  --

--SELECT * FROM taluno

CREATE TABLE CONTAS
(
  Codigo     INTEGER NOT NULL PRIMARY KEY,
  Valor      NUMBER (10, 2),
  Juros      NUMBER (10, 2),
  Vencimento DATE
  );

INSERT INTO CONTAS VALUES (100, 550, 50, SYSDATE-10);

SELECT * FROM  CONTAS;

COMMIT;


--
DECLARE
 vDt_vencimento DATE;
 vConta NUMBER := 100; -- codigo da conta
 eConta_vencida EXCEPTION;

BEGIN
  SELECT vencimento INTO vDt_vencimento
  FROM CONTAS WHERE codigo = vConta;
  IF vDt_vencimento < Trunc(SYSDATE) THEN
  RAISE eConta_vencida; -- dispara erro conta vencida
END IF;

EXCEPTION
  WHEN eConta_vencida THEN
  Dbms_Output.Put_Line('Conta vencida');
  UPDATE contas SET valor = valor + juros
  WHERE codigo = vConta;
END;

-- VALOR MUDA JUROS PARA 600
SELECT * FROM contas;

---
---
DECLARE
 eFk_inexistente EXCEPTION;
 PRAGMA EXCEPTION_INIT(eFk_inexistente, -02291); --PRAGMA - PARA INTERCEPTAR UM ERRO
BEGIN
  INSERT INTO TBAIRRO VALUES ( 100, 100, 'ERRO');
EXCEPTION
 WHEN eFk_Inexistente THEN
  Raise_Application_Error(-20200, 'Cidade nao existe" ');
END;
----

SELECT * FROM TBAIRRO;
SELECT * FROM TCIDADE;

