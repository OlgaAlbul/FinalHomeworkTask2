CREATE SCHEMA human_friends;
USE human_friends;
CREATE TABLE animal_classes(
Id INT AUTO_INCREMENT PRIMARY KEY,
Class_name VARCHAR(25));
INSERT INTO animal_classes (Class_name)
VALUES ('packed'), ('home');
CREATE TABLE packed_animals (
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_type VARCHAR(25),
Class_id INT, FOREIGN KEY (Class_id) REFERENCES 
animal_classes (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO packed_animals (Animal_type, Class_id) 
VALUES ('horses', 1), ('donkeys', 1), ('camels', 1);
CREATE TABLE home_animals (
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_type VARCHAR(25),
Class_id INT, FOREIGN KEY (Class_id) REFERENCES
animal_classes (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO home_animals (Animal_type, Class_id)
VALUES ('cats', 2), ('dogs', 2), ('hamsters', 2);
CREATE TABLE horses(
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_name VARCHAR(20),
Birthday DATE,
Commands VARCHAR(50),
Type_id INT, FOREIGN KEY (Type_id) REFERENCES 
packed_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO horses (Animal_name, Birthday, Commands, Type_id)
VALUES ('Ron', '1988-05-24', 'но,хоп,галоп', 1), 
('Hermione', '1987-04-11', 'хоп, ап, стой', 1), 
('Garry', '1988-10-31', 'но,галоп,вперед', 1);
CREATE TABLE donkeys(
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_name VARCHAR(20),
Birthday DATE,
Commands VARCHAR(50),
Type_id INT, FOREIGN KEY (Type_id) REFERENCES 
packed_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO donkeys (Animal_name, Birthday, Commands, Type_id)
VALUES ('Fred', '1985-04-17', 'стой', 2), 
('George', '1985-04-17', 'стой', 2), 
('Charly', '1980-11-21', 'вперед, стой', 2);
CREATE TABLE camels(
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_name VARCHAR(20),
Birthday DATE,
Commands VARCHAR(50),
Type_id INT, FOREIGN KEY (Type_id) REFERENCES 
packed_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO camels (Animal_name, Birthday, Commands, Type_id)
VALUES ('Din', '1989-01-14', 'стой', 3), 
('Simus', '1990-07-07', 'стой, лежи', 3), 
('Nevill', '1988-10-01', 'вперед, стой, лежи', 3);
CREATE TABLE cats(
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_name VARCHAR(20),
Birthday DATE,
Commands VARCHAR(50),
Type_id INT, FOREIGN KEY (Type_id) REFERENCES 
home_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO cats (Animal_name, Birthday, Commands, Type_id)
VALUES ('Draco', '1989-02-23', 'кс-кс, место', 1), 
('Crabb', '1987-06-07', 'на, уйди', 1), 
('Goyle', '1988-09-21', 'стой,брысь', 1);
CREATE TABLE dogs(
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_name VARCHAR(20),
Birthday DATE,
Commands VARCHAR(50),
Type_id INT, FOREIGN KEY (Type_id) REFERENCES 
home_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO dogs (Animal_name, Birthday, Commands, Type_id)
VALUES ('Dumbledor', '1879-02-15', 'сидеть, фас, место', 2), 
('Sirius', '1975-07-09', 'фас, на, апорт', 2), 
('Rimus', '1976-03-29', 'фу, лежать, держи', 2);
CREATE TABLE hamsters(
Id INT AUTO_INCREMENT PRIMARY KEY,
Animal_name VARCHAR(20),
Birthday DATE,
Commands VARCHAR(50),
Type_id INT, FOREIGN KEY (Type_id) REFERENCES 
home_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO hamsters (Animal_name, Birthday, Commands, Type_id)
VALUES ('Lavanda', '2022-02-19', 'куси', 3), 
('Polumna', '2021-07-09', 'колесо, кушать', 3), 
('Percy', '2022-08-13', 'умри', 3);

SET SQL_SAFE_UPDATES = 0;
DELETE FROM camels;

SELECT Animal_name, Birthday, Commands FROM horses
UNION SELECT  Animal_name, Birthday, Commands FROM donkeys;

CREATE TEMPORARY TABLE all_animals AS 
SELECT *, 'Лошади' as Animal_type FROM horses
UNION SELECT *, 'Ослы' AS Animal_type FROM donkeys
UNION SELECT *, 'Собаки' AS Animal_type FROM dogs
UNION SELECT *, 'Кошки' AS Animal_type FROM cats
UNION SELECT *, 'Хомяки' AS Animal_type FROM hamsters;

CREATE TABLE yang_animal AS
SELECT Animal_name, Birthday, Commands, Animal_type, TIMESTAMPDIFF(MONTH, Birthday, CURDATE()) AS Age_in_month
FROM all_animals WHERE Birthday BETWEEN ADDDATE(curdate(), INTERVAL -3 YEAR) AND ADDDATE(CURDATE(), INTERVAL -1 YEAR);
 
SELECT * FROM yang_animal;

SELECT h.Animal_name, h.Birthday, h.Commands, pa.Animal_type, ya.Age_in_month 
FROM horses h
LEFT JOIN yang_animal ya ON ya.Animal_name = h.Animal_name
LEFT JOIN packed_animals pa ON pa.Id = h.Type_id
UNION 
SELECT d.Animal_name, d.Birthday, d.Commands, pa.Animal_type, ya.Age_in_month 
FROM donkeys d 
LEFT JOIN yang_animal ya ON ya.Animal_name = d.Animal_name
LEFT JOIN packed_animals pa ON pa.Id = d.Type_id
UNION
SELECT c.Animal_name, c.Birthday, c.Commands, ha.Animal_type, ya.Age_in_month 
FROM cats c
LEFT JOIN yang_animal ya ON ya.Animal_name = c.Animal_name
LEFT JOIN home_animals ha ON ha.Id = c.Type_id
UNION
SELECT d.Animal_name, d.Birthday, d.Commands, ha.Animal_type, ya.Age_in_month 
FROM dogs d
LEFT JOIN yang_animal ya ON ya.Animal_name = d.Animal_name
LEFT JOIN home_animals ha ON ha.Id = d.Type_id
UNION
SELECT hm.Animal_name, hm.Birthday, hm.Commands, ha.Animal_type, ya.Age_in_month 
FROM hamsters hm
LEFT JOIN yang_animal ya ON ya.Animal_name = hm.Animal_name
LEFT JOIN home_animals ha ON ha.Id = hm.Type_id;