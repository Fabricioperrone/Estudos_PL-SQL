-- Capitulo 14

-- Bloco anômimo
DECLARE
-- VARIÁVEIS
x INTEGER;
y INTEGER;
c INTEGER;
BEGIN
        x := 10;
        y := 20;
        -- SOMA
        c := x +y;
        -- IMPRIME RESULTADO
        Dbms_Output.Put_Line('Resultado: ' ||+c);
        -- ATALHO PARA PUT -- CTRL + ESPAÇO
        Dbms_Output.Put_Line('');
END;

    --

DECLARE
	VDESCONTO NUMBER(6,2) := 0.50;
	VCIDADE VARCHAR(30) := 'NOVO HAMBURGO';
	VCOD_ALUNO TALUNO.COD_ALUNO%TYPE := 5;
	VTOTAL NUMBER(8,2) := 1345.89;
BEGIN
	VTOTAL := Round(VTOTAL * VDESCONTO, 2);
	Dbms_Output.Put_Line('Total: ' || vTotal);
	VDESCONTO := 1.20;
  -- InitCap transforma a primeira letra de cada palavra  em maiuscúla e o resto em minúscula
	vCIDADE := InitCap(VCIDADE);
  -- imprime na tela
	Dbms_Output.Put_Line('Cidade: '||vCidade);
	Dbms_Output.Put_Line('Desconto: '||VDESCONTO);
	Dbms_Output.Put_Line('Aluno '||VCOD_ALUNO);
END;

--
SELECT * FROM Tcurso;
SELECT * FROM Taluno;

DECLARE
  vPreco1 NUMBER(8,2) := 10;
  vPreco2 NUMBER(8,2) := 20;
  vFlag BOOLEAN; --True ou False
BEGIN
  vFlag := (vPreco1>vPreco2);
  IF (vFlag=True) THEN --se vFlag = True Então
   Dbms_Output.Put_Line('Verdadeiro');
  ELSE --SENÃO
    Dbms_Output.Put_Line('Falso');
  END IF; --Fim do IF
  --
  IF (VPRECO1>VPRECO2) THEN
  Dbms_Output.Put_Line('vPreco1 é maior');
ELSE
  Dbms_Output.Put_Line('vPreco é maior');
END IF;
END;


 -- Blind variable
 VARIABLE vDESCONTO2 NUMBER

 DECLARE
  VCOD_ALUNO NUMBER := 1;
  BEGIN
    :vDESCONTO2 := 0.90;
    Dbms_Output.Put_Line('desconto 2: ' || :vDESCONTO2);

    UPDATE TContrato SET
    TOTAL = TOTAL * :vDESCONTO2
    WHERE COD_ALUNO = VCOD_ALUNO;
    END;

    SELECT * FROM tcontrato;

    -- Aninhamento de blocos
      DECLARE
        VTESTE VARCHAR(10) := 'JOSE';
      BEGIN

        DECLARE
          VTESTE VARCHAR(10) :='PEDRO';
      BEGIN
        Dbms_Output.Put_Line('Bloco Interno: '||VTESTE);
      END;

        Dbms_Output.Put_Line('Bloco Externo: '||VTESTE);
      END;