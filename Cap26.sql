--Capitulo 26
-- Conectando com o us�rio system

CREATE database LINK curso_link
CONNECT TO aluno identified BY "123"
USING  'xe'

--tns

SELECT * FROM TALUNO@CURSO_LINK
