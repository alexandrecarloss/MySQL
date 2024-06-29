CREATE DATABASE TUTORIAL_CURSOR;
  USE TUTORIAL_CURSOR;

  CREATE TABLE VEICULOS(
  VEICULO varchar(32) NOT NULL,
  KILOMETRAGEM int NOT NULL
  );

  INSERT INTO VEICULOS (VEICULO, KILOMETRAGEM) VALUES ('Carro 1',  '5230');
  INSERT INTO VEICULOS (VEICULO, KILOMETRAGEM) VALUES ('Carro 2',  '7800');
  INSERT INTO VEICULOS (VEICULO, KILOMETRAGEM) VALUES ('Carro 3', '16540');
  INSERT INTO VEICULOS (VEICULO, KILOMETRAGEM) VALUES ('Carro 4', '32230');

  DROP PROCEDURE IF EXISTS TUTORIAL_CURSOR.SomaKilometragem;

  DELIMITER $$
  CREATE PROCEDURE TUTORIAL_CURSOR.SomaKilometragem (OUT resultado INT)
  BEGIN

  -- Definição de variáveis utilizadas na Procedure
  DECLARE existe_mais_linhas INT DEFAULT 0;
  DECLARE kilometros INT DEFAULT 0;
  DECLARE total_de_kilometros INT DEFAULT 0;

  -- Definição do cursor
  DECLARE meuCursor CURSOR FOR SELECT KILOMETRAGEM FROM VEICULOS;

  -- Definição da variável de controle de looping do cursor
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET existe_mais_linhas=1;

  -- Abertura do cursor
  OPEN meuCursor;

  -- Looping de execução do cursor
  meuLoop: LOOP
  FETCH meuCursor INTO kilometros;

  -- Controle de existir mais registros na tabela
  IF existe_mais_linhas = 1 THEN
  LEAVE meuLoop;
  END IF;

  -- Soma a kilometragem do registro atual com o total acumulado
  SET total_de_kilometros = total_de_kilometros + kilometros;

  -- Retorna para a primeira linha do loop
  END LOOP meuLoop;

  -- Setando a variável com o resultado final
  SET resultado = total_de_kilometros;

  END $$

  DELIMITER ;

  CALL SomaKilometragem(@variavel_temporaria);
  SELECT @variavel_temporaria;