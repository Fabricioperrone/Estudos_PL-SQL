  -- Capitulo 16

DECLARE
  vNome VARCHAR(30) := 'Outro';
  Vcidade VARCHAR(30);
  vEstado VARCHAR(2);

-- Capitulo 16

BEGIN
 IF (vNome = 'Gaucho') THEN
  vCidade := 'Porto Alegre';
  vEstado := 'RS';
ELSIF (vNome = 'Carioca') THEN
  vCidade := 'Rio de Janeiro';
  vEstado :='RJ';
ELSE
  IF (vEstado='SP') THEN
  vCidade :='Paulista';
  vEstado := 'SP';
ELSE
    vCidade := 'Outros';
    vEstado := 'xx';
  END IF;
END IF;
  Dbms_Output.Put_Line(vCidade|| '-'||vEstado);
END;

-- Case When
--
DECLARE
  vEstado VARCHAR(2) := 'RJ';
  vNome VARCHAR(30);
BEGIN
  CASE
    WHEN vEstado ='RS' THEN vNome := 'Gaucho';
    WHEN vEstado ='RJ' OR vEstado='ES' THEN vNome := 'Carioca';
  ELSE
    vNome := 'Outros';
  END CASE;
  Dbms_Output.Put_Line('Apelido: '||vNome);
END;

--Laço de repetição
DECLARE
  vContador INTEGER := 0;
BEGIN
  LOOP
    vContador := vContador +1;
    Dbms_Output.Put_Line(vContador);
    EXIT WHEN vContador = 10;
  END LOOP;
  Dbms_Output.Put_Line('Fim do loop');
 END;

--For LOOP -> mais indicado para laços em tabelas
DECLARE
  vContador INTEGER;
BEGIN
  FOR vContador IN 1..10
  LOOP
  --vContador := vContador + 1;
  Dbms_Output.Put_Line('For LOOP' ||vContador);
  --EXIT WHEN vContador = 5;
END LOOP;

END;

