  DECLARE
    vValor NUMBER(8,2);
    vNome VARCHAR(30);
  BEGIN
    SELECT valor, nome
    INTO vValor, Vnome
    FROM tcurso

    -- abre uma ciaxa para pedir o código do curso
    WHERE cod_curso = &cod_Curso;
    Dbms_Output.Put_Line('Valor: '|| To_Char(vValor,'fm9999.99'));

    Dbms_Output.Put_Line('Curso: '|| InitCap(vNome));
    END;

    SELECT *FROM Tcurso;

    DECLARE
      vDt_compra tcontrato.Data%TYPE;
      vDt_curso  tcontrato.Data%TYPE;

    BEGIN
    -- soma mais dez dias
      SELECT data, data + 10
      INTO vDt_compra, vDt_curso
      FROM tcontrato
      WHERE cod_contrato = &Contrato;
      Dbms_Output.Put_Line('Data Compra: '||vDt_compra);
      Dbms_Output.Put_Line('Data Curso: '||vDt_curso);
      END;

      SELECT * FROM tcontrato

      SELECT Max(cod_contrato) FROM tcontrato;
      CREATE SEQUENCE seq_contrato START WITH 8;

      -- Bloco anônimo

      DECLARE
        vCod tcontrato.cod_contrato%TYPE;
      BEGIN
        SELECT seq_contrato.NEXTVAL
        INTO vCod FROM dual;

      INSERT INTO tContrato(COD_CONTRATO, DATA, COD_ALUNO, DESCONTO)

      VALUES(vCod, SYSDATE, 2, NULL);

        Dbms_Output.Put_Line('Criado Contrato: '|| vCod);
      END;

   -- Pegar o valor atual
   SELECT Seq_Contrato.CURRVAL FROM Dual;

   SELECT * FROM TCONTRATO;

   ------Upadate
   DECLARE
    vValor tCurso.valor%TYPE := &valor;
  BEGIN
    UPDATE tcurso SET
    valor = valor + vValor
    WHERE carga_horaria >= 30;
    END;

    SELECT * FROM Tcurso;

    ------Delete
    DECLARE
      vContrato Tcontrato.COD_CONTRATO%TYPE := &contrato;
    BEGIN
      DELETE FROM Tcontrato
      WHERE Cod_Contrato = vContrato;
    END;

    SELECT *FROM Tcontrato;

    -- Erro No_Data_Found
    -- Select Into que não encontra  registros
    DECLARE
      vdt_compra tcontrato.data%TYPE;
      vTotal     tcontrato.total%TYPE;
      vDt_atual  DATE := SYSDATE;
    BEGIN
      SELECT data, total
      INTO vdt_compra, vTotal
      FROM tcontrato
      WHERE Data = vDt_atual; --
    END;



DECLARE
  vContrato NUMBER := &cod_contrato;
  vtexto VARCHAR2(50);
BEGIN
  UPDATE TContrato SET
  desconto = desconto - 2
  WHERE Cod_Contrato >= VContrato;

  vtexto := SQL%ROWCOUNT;
  --Retorna qtde de registros afetados
  --pelo comando sql

    Dbms_Output.Put_Line(' Linhas atualizadas.');
  END;


