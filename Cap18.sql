-- Capitulo 18 cursores

DECLARE
  vcod_aluno TAluno.Cod_Aluno%TYPE;
  vNome TAluno.nome%TYPE;
  CURSOR c1 IS
  SELECT cod_aluno, nome
  FROM taluno;
BEGIN
  OPEN c1;-- ABRE CURSOR
  LOOP    --laço de repetição
    FETCH c1 INTO vCod_Aluno, vNome;    --FETCH pega registro a registro
    EXIT WHEN c1%ROWCOUNT >= 10 OR c1%NOTFOUND; --condição - sair quando c1 for > ou = 10, ou quando
    -- não encontrar mais registros - NOTFOUND
    Dbms_Output.Put_Line('Codigo: '||
    LPad(vcod_aluno, 4,'0')||' - '||'Nome: '||vNome);
  END LOOP;
  CLOSE c1; -- FECHA CURSOR
END;

--
DECLARE
  CURSOR c1 IS
    SELECT * FROM TAluno;
  Reg c1%ROWTYPE; --record
BEGIN
  OPEN c1;
  LOOP
    FETCH c1 INTO reg;
    EXIT WHEN c1%ROWCOUNT > 10 OR c1%NOTFOUND;
    Dbms_Output.Put_Line('Codigo: '||
    LPad(reg.cod_aluno,5,'0')||'-'||
    'Nome: '||reg.nome);
  END LOOP;
  CLOSE c1;
END;

--
DECLARE
  CURSOR c1 IS
    SELECT * FROM TAluno;
  Reg TAluno%ROWTYPE;
BEGIN
  FOR reg IN c1
  LOOP
  Dbms_Output.Put_Line('Codigo: '||
  LPad(reg.cod_aluno,5,'0')||'-'|| 'Nome: '||reg.nome);
END LOOP;
END;

--
DECLARE
  Reg TALUNO%ROWTYPE;
BEGIN
  FOR reg IN (SELECT *FROM TALUNO) -- select direto no for - usado quando select é pequeno
  LOOP
   Dbms_Output.Put_Line('Codigo: '||
   LPad(reg.cod_aluno,5,'0')||'-'||'Nome: '||reg.nome);
  END LOOP;
END;

--
DECLARE
   CURSOR c1 (pCod_aluno NUMBER) IS--exemplo de cursor com parametro
   SELECT * FROM TAluno
   WHERE Cod_aluno = pCod_aluno
   FOR UPDATE OF NOME NOWAIT;
   -- BLOQUEIA A COLUNA NOME PARA ALTERAÇÃO
   Reg c1%ROWTYPE;
BEGIN
  OPEN c1(&codigo);
  FETCH c1 INTO reg;
  Dbms_Output.Put_Line('Código: '||
  LPad(reg.cod_aluno,5,'0')||'-'|| 'Nome: '||reg.nome);
CLOSE c1;  -- libera o registro para alteração
END;

--

DECLARE
   CURSOR c1 IS
    SELECT  nome FROM TALUNO
    FOR UPDATE;
  Reg_aluno c1%ROWTYPE;
BEGIN
  FOR reg_aluno IN c1
  LOOP
    UPDATE TALUNO
    SET nome = InitCap(reg_aluno.nome)
    WHERE CURRENT OF c1;
    Dbms_Output.Put_Line('Nome: '||InitCap(reg_aluno.nome));
  END LOOP;
  COMMIT;
END;

SELECT * FROM taluno;
