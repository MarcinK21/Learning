/*
Utworzyć w języku SQL w dialekcie Oracle tabelę studenci składającą się z następujących pól:
nr_studenta – zawiera kolejne liczby naturalne (klucz główny),
nazwisko,
imię – zawierają teksty o maksymalnej długości 15 (nie mogą zawierać wartości pustej),
data_ur – zawiera datę,
plec – powinno zawierać tylko wartości K i M.
a) Ograniczeń nie nazywać.
b) Ograniczenia nazywać
*/
--a )
CREATE TABLE studenci (
nr_studenta NUMBER PRIMARY KEY,
nazwisko VARCHAR2(15) NOT NULL,
imie VARCHAR2(15) NOT NULL,
data_ur DATE,
plec CHAR(1) CHECK(plec='K' OR plec='M')
);

-- b)
CREATE TABLE studenci2 (
nr_studenta NUMBER CONSTRAINT studenci_pk PRIMARY KEY,
nazwisko VARCHAR2(15) CONSTRAINT nazwisko_st NOT NULL,
imie VARCHAR2(15) CONSTRAINT imie_st NOT NULL,
data_ur DATE,
plec CHAR(1) CONSTRAINT plec_st CHECK(plec='K' OR plec='M')
);

/*
Zaimplementować w języku SQL tabelę oceny_studentow składającą się z następujących pól:
id_ocena – zawiera liczby naturalne (klucz główny),
nr_stud – zawiera liczby naturalne (pole klucza obcego łączącego tabelę z tabelą studenci polem nr_studenta),
data_oceny – zawiera daty,
nie może zawierać wartości pustej,
ocena – zawiera oceny w postaci punktowej, 
slownie – zawiera oceny w postaci słownej.
Wszystkie ograniczenia nazwać.
*/

CREATE TABLE oceny (
id_ocena NUMBER CONSTRAINT ocena_pk PRIMARY KEY,
nr_stud NUMBER CONSTRAINT nr_stud_st NOT NULL,
data_oceny DATE CONSTRAINT data_oceny_st NOT NULL,
ocena NUMBER(2,1) CONSTRAINT ocena_st CHECK(ocena IN(2, 3, 3.5, 4, 4.5, 5)),
slownie VARCHAR2(30) CONSTRAINT slownie_st CHECK(slownie IN('niedostateczny', 
   'dostateczny', 'dostateczny plus', 'dobry', 'dobry plus', 'bardzo dobry')),
CONSTRAINT nr_studenta_fk FOREIGN KEY (nr_stud) REFERENCES studenci(nr_studenta)
);

/*
Zmienić nazwę tabeli oceny_studentow na oceny.
*/

RENAME oceny_studentow TO oceny;

/*
Zmień nazwe tabeli oceny_studnetów na oceny
*/

RENAME oceny_studentów TO oceny;

/*
Podczas tworzenia tabeli studenci utworzono pole nazwisko , które maksymalnie może zawierać 15 
znaków a powinno 30. Skorygować pomyłkę bez usuwania tabeli
*/

ALTER TABLE studenci MODIFY(nazwisko VARCHAR2(30));

/*
Podczas tworzenia tabeli studenci pominięto pole telefon, które przechowuje 7 cyfrowe 
numery telefonów. Skorygować pomyłkę
*/

ALTER TABLE studenci ADD(telefon CHAR(7));

/*
Okazuje się że pole telefon jest jednak zbyteczna i należy je usunąć.
*/

ALTER TABLE studenci DROP COLUMN telefon;

/*
Wstawić do tabelki studenci i oceny przykładowe rekordy:
STUDENCI:
1 Tkaczyk Jerzy 15/10/1994 M 
2 Krawczyk Manika 19/05/2006 K
3 Matczyk Maria 09/07/2008 K
4 Balcerek Janusz 02/09/1999 M

OCENY:
1 1 15/10/2019 5 bardzo dobry
2 1 19/10/2019 4.5 dobry plus
3 2 19/10/2019 3 dostateczny
4 3 21/10/2019 3.5 dostateczny plus
*/

INSERT INTO studenci(nr_studenta, nazwisko, imie, data_ur, plec)
VALUES(1, 'Tkaczyk', 'Jerzy', TO_DATE('15/10/1994', 'DD/MM/YYYY'), 'M');

INSERT INTO studenci(nr_studenta, nazwisko, imie, data_ur, plec)
VALUES(2, 'Krawczyk', 'Monika', TO_DATE('19/05/2006', 'DD/MM/YYYY'), 'K');

INSERT INTO studenci(nr_studenta, nazwisko, imie, data_ur, plec)
VALUES(3, 'Matczyk', 'Maria', TO_DATE('09/07/2008', 'DD/MM/YYYY'), 'K');

INSERT INTO studenci(nr_studenta, nazwisko, imie, data_ur, plec)
VALUES(4, 'Balcerek', 'Janusz', TO_DATE('02/09/1999', 'DD/MM/YYYY'), 'M');


INSERT INTO oceny(id_ocena, nr_stud, data_oceny, ocena, slownie)
VALUES(1, 1, TO_DATE('15/10/2019', 'DD/MM/YYYY'), 5, 'bardzo dobry');

INSERT INTO oceny(id_ocena, nr_stud, data_oceny, ocena, slownie)
VALUES(2, 1, TO_DATE('19/10/2019', 'DD/MM/YYYY'), 4.5, 'dobry plus');

INSERT INTO oceny(id_ocena, nr_stud, data_oceny, ocena, slownie)
VALUES(3, 2, TO_DATE('19/10/2019', 'DD/MM/YYYY'), 3, 'dostateczny');

INSERT INTO oceny(id_ocena, nr_stud, data_oceny, ocena, slownie)
VALUES(4, 3, TO_DATE('21/10/2019', 'DD/MM/YYYY'), 3.5, 'dostateczny plus');


/*
Okazuje się, że studentka Matczyk Maria powinna nazywać się Marczyk Marta. Napisać skrypt poprawiający te błędy.
*/

UPDATE studenci SET imie = 'Marta', nazwisko = 'Marczyk' WHERE nr_studenta = 3;

/*
a)  Wyłączyć ograniczenie dla pola plec w tabeli studenci.
*/

ALTER TABLE studenci DISABLE CONSTRAINT plec_st;

/*
b) Należy wprowadzić do tabeli studenci rekord 5 Kowalski Janusz 03/10/2001 A.
*/

INSERT INTO studenci(nr_studenta, nazwisko, imie, data_ur, plec)
VALUES (5, 'Kowalski', 'Janusz', TO_DATE('03/10/2001', 'DD/MM/YYYY'), 'A');

/*
c) Spróbować włączyć ograniczenie dla pola plec w tabeli studenci.
*/

ALTER TABLE studenci ENABLE CONSTRAINT plec_st;

/*
d) Napisać skrypt, który umożliwi wprowadzenie powyższego rekordu w taki sposób, aby ograniczenie udało się wyłączyć.
*/

UPDATE studenci
SET plec = 'M'
WHERE plec = 'A';

/*
Utworzyć dwie sekwencje do wprowadzania wartości w polach kluczy głównych tabel studenci i oceny.
1.Sekwencja dla pola nr_studenta: wprowadza kolejne liczby od 1 do 999 z krokiem 1.
*/

CREATE SEQUENCE sekw_studenci
INCREMENT BY 1
START WITH 6
MINVALUE 1
MAXVALUE 999;

/*
2.Sekwencja dla pola id_oceny: wprowadza wartości od 1 do 999 z krokiem 3
*/

CREATE SEQUENCE sekw_oceny
INCREMENT BY 3
START WITH 5
MINVALUE 1
MAXVALUE 999;

/*
Utworzyć indeks o nazwie student na kolumnach nazwisko i imie posortowanych alfabetycznie. Obejrzeć go w słowniku
*/

CREATE INDEX student
ON studenci(nazwisko ASC, imie ASC);

/*
Utworzyć tabelę studentki w ten sposób, aby zawierała wszystkie rekordy z tabeli studenci opisujące studentki
*/

CREATE TABLE studentki AS
SELECT nr_studenta, nazwisko, imie, data_ur
FROM studenci
WHERE plec = 'K';

/*
Usunąć indeks student
*/

DROP INDEX student;

/*
Zaimplementować w języku SQL bazę danych „Biblioteka”, której schemat został podany na poniższym rysunku.
Wśród wymagań stawianych na tym etapie tworzenia bazy danych należy uwzględnić następujące właściwości pól: 
UWAGA: Wszystkie ograniczenia w tabelach powinny być nazwane przy ich tworzeniu.  Nie używamy instrukcji ALTER TABLE.
•	polami kluczy głównych są: 
-	tabela „Pracownik” – pole nr_prac, 
-	tabela „Czytelnik” – pole nr_karty, 
-	tabela „Wydawnictwo” – pole kod_wydawcy, 
-	tabela „Ksiazki” – pole sygn 
-	tabela „Wypozyczenia” – pole nr_wyp 
-	tabela „Autor” – pole id_autor 
-	tabela „Tworczosc” – pola sygn i id_a	

•	polami kluczy obcych są: 
-	tabela „Ksiazki” – pole id_wyd 
-	tabela „Wypozyczenia” – pola sygn., pole nr_czyt oraz nr_p 
-	tabela „Pracownik” – pole szef 
-	tabela „Tworczosc” – pola sygn i id_a

•	następujące pola powinny być tak ustawione, aby nie zawierać wartości pustej: 
-	tabela „Pracownicy” – pola nazwisko, imie, data_ur, plec 
-	tabela „Czytelnik” – pola nazwisko, imie, pesel, data_ur, plec 
-	tabela „Wydawnictwa” – pola nazwa, miasto 
-	tabela „Ksiazki” – pola tytuł, cena 
-	tabela „Wypozyczenia” – pole data_w 
-	tabela „Autor” – pola nazwisko, imie, data_ur, kraj

•	inne właściwości pól: 
-	tabela „Czytelnik” 
        * pole nr_karty powinno składać się z dwóch dużych liter + 3 cyfry 
        * pole pesel powinno składać się z 11 cyfr 
        * pole plec powinno zawierać tylko literę K lub M 
-	tabela „Wypozyczenia” 
        * pole data_w musi zawierać daty wcześniejsze niż data_z 
        * pole kara nie może zawierać wartości ujemnych, powinno zawierać dwa miejsca po przecinku 
        * pole kara powinno mieć wartość domyślną ustawioną na 0 
-	tabela „Pracownicy” 
        * pole data_ur musi zawierać daty wcześniejsze niż data_zatr 
        * pole plec powinno zawierać tylko literę K lub M 
-	tabela „Ksiazki” 
        * pole gatunek zawiera wartości: powieść, powieść historyczna, dla dzieci, wiersze, kryminał, powieść science fiction, książka naukowa, poezja
        * pole strony zawiera liczby większe od 1 
        * pole cena zawiera liczby dodatnie, powinno zawierać dwa miejsca po przecinku. 
-	tabela „Autor” 
        * pole data_ur musi zawierać daty wcześniejsze niż data_smierci 
-	tabela „Tworczosc” 
        * pola Nobel i debiut powinny zawierać tylko wartości Tak lub Nie

*/

CREATE TABLE czytelnik (
nr_karty CHAR(5) CONSTRAINT nr_karty_c PRIMARY KEY,
nazwisko VARCHAR2(25) CONSTRAINT nazwisko_c NOT NULL,
imie VARCHAR2(25) CONSTRAINT imie_c NOT NULL, 
pesel CHAR(11) CONSTRAINT pesel_c NOT NULL,
data_ur DATE CONSTRAINT data_ur_c NOT NULL,
plec CHAR(1) CONSTRAINT plec_c CHECK(plec='K' OR plec='M') CONSTRAINT plec2_c NOT NULL,
telefon CHAR(9),
CONSTRAINT nrkarty2_c CHECK (SUBSTR(nr_karty, 1, 1) BETWEEN 'A' AND 'Z' 
  AND SUBSTR(nr_karty, 2, 1) BETWEEN 'A' AND 'Z' 
  AND SUBSTR(nr_karty, 3, 1) BETWEEN '0' AND '9'
  AND SUBSTR(nr_karty, 4, 1) BETWEEN '0' AND '9'
  AND SUBSTR(nr_karty, 5, 1) BETWEEN '0' AND '9'),
CONSTRAINT pesel2_c CHECK (SUBSTR(pesel, 1, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 2, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 3, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 4, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 5, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 6, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 7, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 8, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 9, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 10, 1) BETWEEN '0' AND '9'
  AND SUBSTR(pesel, 11, 1) BETWEEN '0' AND '9')
);

CREATE TABLE wypozyczenia (
nr_wyp NUMBER CONSTRAINT nr_wyp_wp PRIMARY KEY,
sygn VARCHAR(25),
nr_czyt CHAR(5),
nr_p NUMBER,
data_w DATE CONSTRAINT data_w_wp NOT NULL,
data_z DATE,
kara NUMBER(7,2) DEFAULT 0, 
CONSTRAINT data_z_wp CHECK (data_z > data_w),
CONSTRAINT kara_wp CHECK (kara >= 0),
CONSTRAINT sygn_fk FOREIGN KEY (sygn) REFERENCES ksiazki(sygn),
CONSTRAINT nr_czyt_fk FOREIGN KEY (nr_czyt) REFERENCES czytelnik(nr_karty),
CONSTRAINT nr_p FOREIGN KEY (nr_p) REFERENCES pracownik(nr_prac)
CONSTRAINT nr_czyt2_c CHECK (SUBSTR(nr_karty, 1, 1) BETWEEN 'A' AND 'Z' 
  AND SUBSTR(nr_karty, 2, 1) BETWEEN 'A' AND 'Z' 
  AND SUBSTR(nr_karty, 3, 1) BETWEEN '0' AND '9'
  AND SUBSTR(nr_karty, 4, 1) BETWEEN '0' AND '9'
  AND SUBSTR(nr_karty, 5, 1) BETWEEN '0' AND '9'),
);

CREATE TABLE ksiazki (
sygn VARCHAR(25)CONSTRAINT sygn_k PRIMARY KEY,
id_wyd NUMBER CONSTRAINT id_wyd2_wd,
tytul VARCHAR2(50) CONSTRAINT tytul_k NOT NULL,
cena NUMBER(7,2) CONSTRAINT cena_k NOT NULL,
strony NUMBER,
gatunek VARCHAR2(50),
CONSTRAINT gatunek_k CHECK(gatunek IN('powieść', 'powieść historyczna', 'dla dzieci', 'wiersze', 'kryminał', 'powieść science fiction', 'książka naukowa', 'poezja')),
CONSTRAINT strony_k CHECK (strony > 1),
CONSTRAINT id_wyd_wd FOREIGN KEY (id_wyd) REFERENCES wydawnictwo(kod_wydawcy),
CONSTRAINT cena_min_k CHECK (cena > 0)
);

CREATE TABLE wydawnictwo (
kod_wydawcy NUMBER CONSTRAINT kod_wydawcy_wd PRIMARY KEY,
nazwa VARCHAR2(50) CONSTRAINT nazwa_wd NOT NULL,
miasto VARCHAR2(50) CONSTRAINT miasto_wd NOT NULL,
telefon CHAR(9)
);

CREATE TABLE pracownik (
nr_prac NUMBER CONSTRAINT nr_prac_p PRIMARY KEY,
nazwisko VARCHAR2(25) CONSTRAINT nazwisko_p NOT NULL,
imie VARCHAR2(25) CONSTRAINT imie_p NOT NULL,
plec CHAR(1) CONSTRAINT plec_p CHECK(plec='K' OR plec='M') CONSTRAINT plec2_p NOT NULL,
data_ur DATE CONSTRAINT data_ur_p NOT NULL,
data_zatr DATE,
szef NUMBER,
CONSTRAINT data_zatr_p CHECK (data_zatr > data_ur),
CONSTRAINT szef_p FOREIGN KEY (szef) REFERENCES pracownik(nr_prac)
);

CREATE TABLE tworczosc (         
sygn VARCHAR(25),
id_a NUMBER,
debiut CHAR(3) CONSTRAINT debiut_t CHECK(debiut='tak' OR debiut='nie'),
Nobel CHAR(3) CONSTRAINT Nobel_t CHECK(Nobel='tak' OR Nobel='nie'),
CONSTRAINT sygn_t FOREIGN KEY (sygn) REFERENCES ksiazki(sygn),
CONSTRAINT id_a_t FOREIGN KEY (id_a) REFERENCES autor(id_autor),
CONSTRAINT klucze_glowne_t PRIMARY KEY(id_a, sygn)    
);

CREATE TABLE autor (
id_autor NUMBER CONSTRAINT id_autor PRIMARY KEY,
nazwisko VARCHAR2(25) CONSTRAINT nazwisko_a NOT NULL,
imie VARCHAR2(25) CONSTRAINT imie_a NOT NULL,
pseudonim VARCHAR2(25),
data_ur DATE CONSTRAINT data_ur_a NOT NULL, 
data_smierci DATE,
kraj VARCHAR2(25) CONSTRAINT kraj_a NOT NULL,
CONSTRAINT data_smierci_a CHECK (data_smierci > data_ur)
);
