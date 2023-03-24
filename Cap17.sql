-- Capitulo 17
--Record
DECLARE

 --
TYPE Rec_Aluno IS RECORD
(
  cod_aluno NUMBER NOT NULL := 0,
  nome TALUNO.Nome%TYPE,
  cidade TALUNO.Cidade%TYPE
  );
  --  variável (Registro rec_aluno
  Registro rec_aluno;
BEGIN
  registro.cod_aluno := 50;
  registro.nome      := 'Master';
  registro.cidade    := 'Novo Hamburgo';
  Dbms_Output.Put_Line('Código: '||registro.cod_aluno);
  Dbms_Output.Put_Line('  Nome: ' ||registro.nome);
  Dbms_Output.Put_Line('Cidade: '||registro.cidade);

END;

----------

DECLARE
 reg TAluno%ROWTYPE; --Record
 vcep VARCHAR(10) := '98300000';
BEGIN
  SELECT COD_ALUNO, NOME, CIDADE
  INTO Reg.cod_aluno, Reg.nome, Reg.cidade
  FROM TAlUNO
  WHERE COD_ALUNO = 1;


  reg.cep := '93500000';
  reg.salario := 1500;

  Dbms_Output.Put_Line('Código: '||reg.cod_aluno);
  Dbms_Output.Put_Line('Nome  : '||reg.nome);
  Dbms_Output.Put_Line('Cidade: '||reg.cidade);
  Dbms_Output.Put_Line('Cep   : '||reg.cep);
  Dbms_Output.Put_Line('Salario:'||reg.salario);
END;

--

DECLARE
 TYPE T_ALUNO IS TABLE OF TALUNO.NOME%TYPE
 INDEX BY BINARY_INTEGER; --Matriz

 REGISTRO T_ALUNO; --Record
BEGIN
  REGISTRO(1) := 'MARCIO';
  REGISTRO(2) := 'JOSE';
  REGISTRO(3) := 'PEDRO';
  Dbms_Output.Put_Line('Nome 1: '||registro(1));
  Dbms_Output.Put_Line('Nome 2: '||registro(2));
  Dbms_Output.Put_Line('Nome 3: '||registro(3));
END;

--

SELECT cod_aluno, NOME
FROM tALUNO WHERE COD_ALUNO = 1;


--

DECLARE
 TYPE nome_type IS TABLE OF tALUNO.nome%TYPE;
 nome_table nome_type := nome_type(); --Criando Instancia
BEGIN
  nome_table.EXTEND;-- alocando uma nova linha
  nome_table(1) := 'Pedro';
  nome_table.EXTEND; -- alocando uma nova linha
  nome_table(2) := 'Marcio';
  Dbms_Output.Put_Line('Nome 1: '||nome_table(1));
  Dbms_Output.Put_Line('Nome 2: '||nome_table(2));
END;

--





