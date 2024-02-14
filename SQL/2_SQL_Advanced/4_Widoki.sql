-- Tworzenie i wykorzystanie widoków
CREATE OR REPLACE VIEW V_PRACOWNICY AS
  SELECT pierwsze_imie || ' ' || nazwisko as dane, 
    decode(lower(plec), 'k', 'Kobieta', 'm', 'Mezczyzna') as plec
  FROM pracownicy;

/* Widok łączy imie i nazwisko pracownika w jedno pole oraz konwertuje płeć na pełne słowa   */

SELECT *
FROM V_PRACOWNICY
WHERE plec = 'Kobieta';
/* Filtrowanie danych na podstawie płci z widoku*/



-- Operacje na widokach i manipulacja danymi
CREATE OR REPLACE VIEW V_PRACOWNICY_DANE AS
SELECT id, pierwsze_imie, nazwisko, pesel, plec, data_urodzenia, id_oddzialu
FROM pracownicy;

-- Wstawianie, aktualizacja i usuwanie danych przez widok:
-- Sprawdzenie możliwości i ograniczeń operacji DML na widokach
INSERT INTO V_PRACOWNICY_DANE VALUES (
55, 'Roman', 'Nowak', '77091956714', 'M',
TO_DATE('19/09/1977', 'DD/MM/YYYY'), 2
);


SELECT * FROM pracownicy
WHERE pesel = '77091956714';


UPDATE V_PRACOWNICY_DANE
SET pierwsze_imie = 'Robert'
WHERE id = 55;


DELETE FROM V_PRACOWNICY_DANE
WHERE id = 55;


SELECT * FROM USER_UPDATABLE_COLUMNS;

-- Agregacja danych i tworzenie widoków agregujących
CREATE OR REPLACE VIEW V_PRACOWNICY_LICZBA_OSOB AS
SELECT id_oddzialu, count(id) as liczba_osob
FROM pracownicy
GROUP BY id_oddzialu
ORDER BY 1;


SELECT * FROM V_PRACOWNICY_LICZBA_OSOB;

SELECT * FROM USER_UPDATABLE_COLUMNS
WHERE table_name = 'V_PRACOWNICY_LICZBA_OSOB';


-- Unikalność danych i aktualizacje
CREATE OR REPLACE VIEW V_PRACOWNICY_ROZNE_IMIONA AS
SELECT DISTINCT pierwsze_imie
FROM pracownicy;

SELECT * FROM V_PRACOWNICY_ROZNE_IMIONA;

-- Operacje na widoku z unikalnymi imionami: Próba aktualizacji i usunięcia z widoku, sprawdzenie ograniczeń widoku
UPDATE V_PRACOWNICY_ROZNE_IMIONA
SET pierwsze_imie = 'Alina'
WHERE pierwsze_imie = 'Alicja';

DELETE FROM V_PRACOWNICY_ROZNE_IMIONA
WHERE pierwsze_imie = 'Alicja';

SELECT * FROM USER_UPDATABLE_COLUMNS
WHERE table_name = 'V_PRACOWNICY_ROZNE_IMIONA';




-- MERGE 

-- DROP TABLE przedmioty;
-- DROP TABLE przedmioty_nowe;
CREATE TABLE przedmioty(
kod VARCHAR2(20) CONSTRAINT przedmioty_pk PRIMARY KEY,
nazwa VARCHAR2(50) NOT NULL,
liczba_punktow_ECTS NUMBER);
CREATE TABLE przedmioty_nowe(
kod VARCHAR2(20) CONSTRAINT przedmioty_nowe_pk PRIMARY KEY,
nazwa VARCHAR2(50) NOT NULL,
liczba_punktow_ECTS NUMBER);
INSERT INTO przedmioty VALUES('1100-PB0LII', 'Podstawy baz danych', 6);
INSERT INTO przedmioty VALUES('1100-BP0LII', 'Projektowanie systemów bazodanowych', 6);
INSERT INTO przedmioty VALUES('1100-PZ0OII', 'Projekt zespołowy', 4);
INSERT INTO przedmioty VALUES('1100-UM0IWH', 'Wstęp do uczenia maszynowego', 5);
INSERT INTO przedmioty_nowe VALUES ('1100-MN0LII', 'Metody numeryczne', 5);
INSERT INTO przedmioty_nowe VALUES ('1100-APZPAD', 'Analiza portfelowa', 8); 
INSERT INTO przedmioty_nowe VALUES ('1100-PZ0OII', 'Projekt zespołowy', 5);
COMMIT;
SELECT * FROM przedmioty ORDER BY kod;
SELECT * FROM przedmioty_nowe ORDER BY kod;

-- Wykorzystanie 'MERGE' do synchronizacji danych
/* Jeśli rekord z tabeli 'przedmioty_nowe' pasuje do rekordu w tabeli 'przedmioty' na podstawie klucza
głównego, to aktualizowane są informacje o liczbie punktów ECTS 
Jeśli rekord z tabeli źródłowej(przedmioty_nowe) nie zanjduje się w tabeli docelowej(przedmioty) jest on wstawiany do tabeli docelowej*/
MERGE INTO PRZEDMIOTY dc1 USING PRZEDMIOTY_NOWE dz1
ON (dc1.kod = dz1.kod)
WHEN MATCHED THEN
UPDATE
SET dc1.liczba_punktow_ECTS = dz1.liczba_punktow_ECTS
WHEN NOT MATCHED THEN
INSERT (dc1.kod, dc1.nazwa, dc1.liczba_punktow_ECTS) VALUES
  (dz1.kod, dz1.nazwa, dz1.liczba_punktow_ECTS);


INSERT INTO przedmioty_nowe VALUES ('1100-SC0UFM', 'Analiza szeregów czasowych', 5);
INSERT INTO przedmioty_nowe VALUES ('1100-KW0ZLM', 'Komputerowe wspomaganie obliczeń', 2); 
UPDATE przedmioty_nowe SET liczba_punktow_ECTS=3 WHERE kod='1100-APZPAD'; 
UPDATE przedmioty_nowe SET liczba_punktow_ECTS=6 WHERE kod='1100-MN0LII'; 
UPDATE przedmioty SET liczba_punktow_ects=2 WHERE kod='1100-UM0IWH';
INSERT INTO przedmioty VALUES('1100-ZA0ZLI', 'Zaawansowane algorytmy', 1);
COMMIT;

SELECT * FROM przedmioty ORDER BY kod;
SELECT * FROM przedmioty_nowe ORDER BY kod;

-- Usuwanie rekordów spełniających określone warunki
/* Aktualizowane są dane o punktach ECTS, a nowe przedmioty są dodawane do tabeli 'przedmioty'
Rekordy, które po aktualizacji spełniają określone kryteria( ECTS <= 4) są usuwane z tabeli docelowej */

MERGE INTO PRZEDMIOTY dc1 USING PRZEDMIOTY_NOWE dz1
ON (dc1.kod = dz1.kod)
WHEN MATCHED THEN
UPDATE
SET dc1.liczba_punktow_ECTS = dz1.liczba_punktow_ECTS
DELETE WHERE dc1.liczba_punktow_ECTS <= 4
WHEN NOT MATCHED THEN
INSERT (dc1.kod, dc1.nazwa, dc1.liczba_punktow_ECTS) VALUES
  (dz1.kod, dz1.nazwa, dz1.liczba_punktow_ECTS);
  

SELECT * FROM PRZEDMIOTY_NOWE ORDER BY 1;

DROP TABLE PRZEDMIOTY;
DROP TABLE PRZEDMIOTY_NOWE;

-- PRZYKŁAD 2

CREATE TABLE osoby(
id NUMBER CONSTRAINT osoby_PK PRIMARY KEY,
imie VARCHAR2(20) NOT NULL,
nazwisko VARCHAR2(50) NOT NULL,
data_urodzenia DATE NOT NULL,
e_mail VARCHAR2(30));


INSERT INTO osoby VALUES(1, 'JAN', 'MICHALAK', TO_DATE('15/04/1994', 'DD/MM/YYYY'), NULL);
INSERT INTO osoby VALUES(2, 'ANNA', 'MICHALAK', TO_DATE('05/12/1990', 'DD/MM/YYYY'), 
'anna_michalak@o2.pl');
INSERT INTO osoby VALUES(3, 'EWA', 'ZATORSKA', TO_DATE('04/07/1980', 'DD/MM/YYYY'), NULL);
INSERT INTO osoby VALUES(4, 'JAN', 'KOWALSKI', TO_DATE('19/11/1983', 'DD/MM/YYYY'), NULL);
COMMIT;


SELECT * FROM osoby ORDER BY id;

/* Wybieranie są rekordy z 'osoby', które nie mają przypisanego e-mail 
 Warunek dopasowania rekordów odbywa się na podstawie id, dzięki temu
  operacja dotyczy tylko dla rekordów w tabeli 'osoby', dla których znajdzie sięodpowiadająćy rekord bez e-maila w źródle danych
 W przypadku znalezienia dopasowania, czyli dla osób bez przypisanego e-mail, generowany jest i ustawiany nowy adres e-mail*/
MERGE INTO OSOBY o USING (SELECT *
  FROM osoby
  WHERE e_mail IS NULL) z
ON (o.id = z.id)
WHEN MATCHED THEN
UPDATE
SET o.e_mail = 
SUBSTR(nazwisko, 1, 2) || SUBSTR(imie, 1, 3) || 
TO_CHAR(data_urodzenia, 'YYYY') || '@uni.pl';









