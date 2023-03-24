-- domine o PL/SQL
DECLARE
 SOMA NUMBER;
BEGIN
  SOMA := 45+55;
  Dbms_Output.Put_Line('Soma :'||soma);
exception
  WHEN OTHERS THEN
    Raise_Application_Error(-20001, 'Erro ao somar valores');
END;

SELECT * FROM TALUNO
SELECT * FROM TCURSO;
SELECT * FROM TCONTRATO
SELECT * FROM tcidade




-- ENABLE ESTA PROCEDURE HABILITA CHAMADAS PARA PUT
BEGIN
 Dbms_Output.Put_Line(2000);
 Dbms_Output.Put_Line('TESTE');
END;

-- DISABLE ESTA PROCEDURE DESABILITA  AS CHAMADAS PARA PUT

BEGIN
  Dbms_Output.DISABLE;
  Dbms_Output.Put_Line('TESTE');
END;


--PUT
--  Esta procedure recebe um parâmetro
-- cujo o valor será armazenado na área do
-- buffer imediatamente após a última informação

BEGIN
   Dbms_Output.Put('T');
   Dbms_Output.Put('E');
   Dbms_Output.Put('S');
   Dbms_Output.Put('T');
   Dbms_Output.Put('E');
   Dbms_Output.new_Line;
END;

-- put_line
-- este procedimento envia o parâmetro informado para a área de buffer,
--acrescentando, automaticamente, um caractere indicativo de fim de linha
--após o texto enviado.

BEGIN
 Dbms_Output.Put_Line('T');
 Dbms_Output.Put_Line('E');
 Dbms_Output.Put_Line('S');
 Dbms_Output.Put_Line('T');
 Dbms_Output.Put_Line('E');
END;

-- Get_Line
-- este procedimento permite ler do buffer uma única linha de
--cada vez.
SET serveroutput OFF
BEGIN
  Dbms_Output.ENABLE(2000);
  --
  Dbms_Output.Put('Como');
  Dbms_Output.new_Line;
  Dbms_Output.Put('Aprender');
  Dbms_Output.new_Line;
  Dbms_Output.Put('PL/SQL?');
  Dbms_Output.new_Line;

END;

 -- GET_LINES
 --ESTE PROCEDIMENTO PERMITE LER VÁRIAS LINHAS DO BUFFER
 --UTILIZANDO  UMA ARRAY DE CARACTERES
 SET serveroutput OFF
 BEGIN
   Dbms_Output.enable(2000);
   --
     Dbms_Output.Put('Como');
  Dbms_Output.new_Line;
  Dbms_Output.Put('Aprender');
  Dbms_Output.new_Line;
  Dbms_Output.Put('PL/SQL?');
  Dbms_Output.new_Line;
END;


SET serveroutput ON
DECLARE
  tab Dbms_Output.chararr;
  qtlines NUMBER               DEFAULT 3;
  res     VARCHAR2(100)        DEFAULT NULL;

  BEGIN
  --
  Dbms_Output.get_Lines(tab,qtlines);
  --
  Dbms_Output.Put_Line(
      'Retornou: '||qtlines||'registros');
      --
  FOR i IN 1..qtlines LOOP
  res := res||' '||tab(i);
  END LOOP;
  --
  Dbms_Output.Put_Line('Pergunta: '||res);
  --
  END;



