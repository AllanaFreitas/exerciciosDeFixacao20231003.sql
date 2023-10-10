--1 
DELIMITER //
CREATE FUNCTION total_livros_por_genero(nome_genero VARCHAR(255))
RETURNS INT
BEGIN
  DECLARE total INT;
  SET total = 0;

  DECLARE done INT DEFAULT 0;
  DECLARE genre_id INT;

  DECLARE cur CURSOR FOR SELECT id FROM Genero WHERE nome_genero = nome_genero;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  FETCH cur INTO genre_id;

  IF done = 0 THEN
    SELECT COUNT(*) INTO total FROM Livro WHERE id_genero = genre_id;
  END IF;

  CLOSE cur;

  RETURN total;
END;
//
DELIMITER ;

--2
DELIMITER //
CREATE FUNCTION listar_livros_por_autor(primeiro_nome VARCHAR(255), ultimo_nome VARCHAR(255))
RETURNS TEXT
BEGIN
  DECLARE lista TEXT;
  SET lista = '';

  DECLARE done INT DEFAULT 0;
  DECLARE author_id INT;

  DECLARE cur CURSOR FOR
  SELECT Autor.id FROM Autor
  WHERE Autor.primeiro_nome = primeiro_nome AND Autor.ultimo_nome = ultimo_nome;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  FETCH cur INTO author_id;

  IF done = 0 THEN
    DECLARE book_title VARCHAR(255);
    DECLARE cur2 CURSOR FOR
    SELECT Livro.titulo FROM Livro
    JOIN Livro_Autor ON Livro.id = Livro_Autor.id_livro
    WHERE Livro_Autor.id_autor = author_id;

    OPEN cur2;
    FETCH cur2 INTO book_title;

    WHILE done = 0 DO
      SET lista = CONCAT(lista, book_title, ', ');
      FETCH cur2 INTO book_title;
    END WHILE;

    CLOSE cur2;
  END IF;

  CLOSE cur;

  RETURN lista;
END;
//
DELIMITER ;

--3
DELIMITER //
CREATE FUNCTION atualizar_resumos()
RETURNS INT
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE livro_id INT;
  DECLARE resumo_atual TEXT;

  DECLARE cur CURSOR FOR SELECT id, resumo FROM Livro;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  FETCH cur INTO livro_id, resumo_atual;

  WHILE done = 0 DO
    SET resumo_atual = CONCAT(resumo_atual, ' Este é um excelente livro!');
    UPDATE Livro SET resumo = resumo_atual WHERE id = livro_id;
    FETCH cur INTO livro_id, resumo_atual;
  END WHILE;

  CLOSE cur;

  RETURN 1;
END;
//
DELIMITER ;

--4 
DELIMITER //
CREATE FUNCTION media_livros_por_editora()
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE total_livros INT DEFAULT 0;
  DECLARE total_editoras INT DEFAULT 0;

  DECLARE cur CURSOR FOR SELECT COUNT(*) FROM Livro;
  DECLARE cur2 CURSOR FOR SELECT COUNT(*) FROM Editora;

  OPEN cur;
  FETCH cur INTO total_livros;

  OPEN cur2;
  FETCH cur2 INTO total_editoras;

  CLOSE cur;
  CLOSE cur2;

  IF total_editoras > 0 THEN
    RETURN total_livros / total_editoras;
  ELSE
    RETURN 0;
  END IF;
END;
//
DELIMITER ;


--5
DELIMITER //
CREATE FUNCTION media_livros_por_editora()
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE total_livros INT DEFAULT 0;
  DECLARE total_editoras INT DEFAULT 0;

  DECLARE cur CURSOR FOR SELECT COUNT(*) FROM Livro;
  DECLARE cur2 CURSOR FOR SELECT COUNT(*) FROM Editora;

  OPEN cur;
  FETCH cur INTO total_livros;

  OPEN cur2;
  FETCH cur2 INTO total_editoras;

  CLOSE cur;
  CLOSE cur2;

  IF total_editoras > 0 THEN
    RETURN total_livros / total_editoras;
  ELSE
    RETURN 0;
  END IF;
END;
//
DELIMITER ;

