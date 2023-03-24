-- Capitulo 23

--
DECLARE
  HORA VARCHAR2(2);
  H NUMBER;
BEGIN
  H := To_Number(To_Char(SYSDATE,'HH24'));
  Dbms_Output.Put_Line(H||'  '||To_Char(SYSDATE+4, 'DAY'));
END;

--
BEGIN
 IF(To_Char(SYSDATE, 'DAY') IN('SABADO', 'DOMINGO') OR
 To_Number(To_Char(SYSDATE,'HH24')) NOT BETWEEN 8 AND 23)THEN
 Raise_Application_Error ( -20001,'Fora do horario comercial');
  END IF;
END;

--
CREATE or REPLACE TRIGGER VALIDA_HORARIO_CURSO
BEFORE INSERT OR DELETE ON TContrato
BEGIN
 IF (To_Char(SYSDATE,'D') IN (1, 7) OR
 To_Number(To_Char(SYSDATE,'HH24'))
 NOT BETWEEN 8 AND 14) THEN
 Raise_Application_Error(-20001,'Fora do horario comercial');
 END IF;
 END;

 --
 INSERT INTO TCONTRATO VALUES (7665, SYSDATE,  10, 1500, NULL);

 --
 SELECT * FROM TCONTRATO;

 CREATE TABLE Log
 ( USUARIO VARCHAR2(30),
   HORARIO DATE,
   VALOR_ANTIGO VARCHAR2(10),
   VALOR_NOVO VARCHAR2(10)
   );

CREATE OR REPLACE TRIGGER gera_log_alt
AFTER UPDATE OF TOTAL ON TContrato
DECLARE

--VARIAVEIS

BEGIN
  INSERT INTO Log(Usuario, horario) VALUES (USER, SYSDATE);
END;

SELECT * FROM TCONTRATO;
UPDATE TCONTRATO SET TOTAL = 500 WHERE COD_CONTRATO = 1;

SELECT * FROM Log;

CREATE OR REPLACE TRIGGER valida_horario_curso2
BEFORE INSERT OR UPDATE OR DELETE ON TCONTRATO
BEGIN
  IF(To_Char(SYSDATE,'D') IN (1, 7) OR
  To_Number (To_Char(SYSDATE,'HH24'))NOT BETWEEN 8 AND 23) THEN
    IF( INSERTING ) THEN
      Raise_Application_Error(-20001, 'Nao pode inserir');
    ELSIF( DELETING ) THEN
      Raise_Application_Error(-20002, 'Nao pode remover');
    ELSIF( UPDATING('TOTAL') ) THEN
      Raise_Application_Error(-20003, 'Nao pode alterar total');
    ELSE
      Raise_Application_Error(-20004, 'Nao pode alterar');
    END IF;
  END IF;
END;
--testes
ALTER TRIGGER VALIDA_HORARIO_CURSO DISABLE;
--
DELETE FROM TCONTRATO;
UPDATE TCONTRATO SET TOTAL = 5000 WHERE COD_CONTRATO = 1;
INSERT INTO TCONTRATO VALUES (90, SYSDATE, 10, 1500, NULL);
 ROLLBACK

SELECT * FROM TCONTRATO;


--Parte 2


ALTER TABLE Log ADD OBS VARCHAR(80);
--ALTER TABLE TALUNO ADD SALARIO NUMERIC(12,2)

CREATE OR REPLACE  TRIGGER audita_aluno
AFTER INSERT  OR DELETE OR UPDATE  ON TALUNO
FOR EACH ROW --EXECUTA PARA LINHA AFETADA
            -- SEM O FOR  EACH ROW EXCUTA UMA VEZ SÓ

BEGIN
 IF( DELETING ) THEN
    INSERT INTO Log( USUARIO, horario, OBS )
    VALUES (USER, SYSDATE, 'Linhas deletadas.');
  ELSIF (INSERTING)THEN
    INSERT INTO Log(usuario, horario, OBS )
    VALUES(USER, SYSDATE,'Linhas Inserias');
  ELSIF(UPDATING('SALARIO') )THEN
    INSERT INTO Log
    VALUES ( :OLD.NOME, SYSDATE, :OLD.SALARIO, :NEW.SALARIO,
    'Alterado Salario');
      INSERT INTO Log( usuario, horario, OBS )
      VALUES (USER, SYSDATE, 'Atualizacao Aluno.');
     END IF;
    END;


SELECT * FROM TALUNO;
SELECT* FROM Log;
UPDATE TALUNO SET SALARIO = 3000;


------------

CREATE OR REPLACE TRIGGER gera_Log_CURSO
BEFORE UPDATE OF VALOR ON TCURSO
FOR EACH ROW
BEGIN
  INSERT INTO Log(Usuario,Horario, obs,
                  valor_antigo, valor_novo)
  VALUES (USER, SYSDATE,'Curso Alterado: '||:old.nome,
          :old.valor, :new.valor );
END;

SELECT * FROM tcurso;


UPDATE tcurso SET
valor = 3000
WHERE valor > 1500

SELECT *FROM Log;

ALTER TABLE tcontrato ADD valor_comissao NUMERIC(8,2);

CREATE OR REPLACE TRIGGER calc_comissao
BEFORE INSERT OR UPDATE OF total ON TContrato
REFERENCING OLD AS antigo
            NEW AS novo
FOR EACH ROW
WHEN(Novo.Total >= 5000)
DECLARE
  Vcomissao NUMERIC (6,2) := 0.15;
BEGIN
  IF(:novo.Total <= 10000) THEN
    :novo.valor_comissao := :novo.Total*(vComissao);
  ELSE
    :novo.valor_comissao := :novo.Total*(vComissao);
  END IF;
END;


------******-----
ALTER TABLE VALIDA_HORARIO_CURSO2 DISABLE
---------------------
INSERT INTO tcontrato(cod_contrato, total) VALUES(32, 6000);
INSERT INTO tcontrato(cod_contrato, total) VALUES(35,12000);
SELECT * FROM TCONTRATO


-----
--INSERT INTO TCONTRATO VALUES (18, SYSDATE, 5, 7500, NULL);
SELECT * FROM TCONTRATO;

--Exemplo de view com trigger e dml
CREATE OR REPLACE VIEW vcontratos_pares
AS SELECT COD_CONTRATO, DATA, COD_ALUNO, DESCONTO, TOTAL
      FROM tcontrato
      WHERE Mod( COD_CONTRATO, 2 ) = 0;

--------------------------

SELECT * FROM vcontratos_pares;
------------------
CREATE OR REPLACE TRIGGER tri_contratos_pares
instead OF INSERT OR DELETE OR UPDATE ON vcontratos_pares
DECLARE
BEGIN
  INSERT INTO Log( usuario, horario, obs )
  VALUES (USER, SYSDATE, 'DML da view VCONTRATOS_PARES.');
END;

-----

INSERT INTO vContratos_pares VALUES(90, SYSDATE, 10, NULL, 5000);

SELECT * FROM Log;











