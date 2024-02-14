/*
Napisać skrypt, pozwalający wyświetlić następujące dane z tabeli wydziały.
WYDZIAŁ 	LITERA
Przykład:
Fizyka	F
Matematyka	M
Prawo	P
*/

SELECT UPPER (nazwa) wydzial, UPPER (SUBSTR(nazwa, 1, 1)) litera
FROM wydzialy
ORDER BY 1 ASC;

/*
Napisać skrypt, pozwalający wyświetlić następujące dane z tabeli osoby. 
OSOBA	INICJAŁY
Przykład:
Duda Barbara	D. B.
Nowak Adam	N. A.
Nowak Maria	N. M.
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1) osoba,SUBSTR (UPPER(nazwisko), 1, 1) ||'.'|| SUBSTR (UPPER(imie1), 1, 1) ||'.' inicjaly
FROM osoby
ORDER BY 1 ASC;

/*
Napisać skrypt pozwalający wyświetlić dla poszczególnych osób ich aktualne pensje i aktualne pensje zaokrąglone do pełnych tys. złotych.
PRACOWNIK	PENSJA	PELNE_TYS
*/

SELECT id_os pracownik, pensja, TRUNC(pensja/1000) pelne_tys
FROM zatrudnienia
WHERE do IS NULL
ORDER BY pensja DESC;

/*
Wyświetlić listę id tych osób, które były kiedykolwiek gdziekolwiek zatrudnione.
*/

SELECT DISTINCT id_os id
FROM zatrudnienia
ORDER BY 1 ASC;

/*
Obliczyć dla każdej osoby liczbę pełnych lat, jakie przepracowała w aktualnym miejscu zatrudnienia.
*/

SELECT id_os, TRUNC((MONTHS_BETWEEN(SYSDATE, od)/12)) lata_pracy
FROM zatrudnienia
WHERE do IS NULL
ORDER BY lata_pracy DESC, id_os ASC;


/*
Wyświetlić te osoby, których długość nazwiska jest zawarta między 5 a 10
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1) osoba, LENGTH(nazwisko) dlugosc
FROM osoby
WHERE LENGTH(nazwisko) BETWEEN 5 AND 10
ORDER BY dlugosc DESC, INITCAP(nazwisko) ASC;

/*
Wyświetlić te osoby, których imię zawiera przynajmniej jedną pierwszą literę alfabetu (przynajmniej jedno A)
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1) osoba
FROM osoby
WHERE UPPER(imie1) LIKE '%A%'
ORDER BY osoba;

/*
Wyświetlić wszystkie osoby z tabeli osoby, których imiona zaczynają się na litery: B, C, D, E, F, I, J, G, H, K
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1) osoba
FROM osoby
WHERE UPPER(imie1) BETWEEN 'B%' AND 'L%'
ORDER BY imie1 ASC;

/*
Wyświetlić dane tych osób z tabeli osoby, których nazwisko zaczyna się na literę K lub L i urodziły się one w czerwcu,
listopadzie i grudniu, lub te kobiety, które mają drugie imię
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1)||' '||INITCAP(imie2) osoba, d_ur, plec
FROM osoby
WHERE ((SUBSTR(INITCAP(nazwisko), 1, 1) IN ('K', 'L')) AND (TO_CHAR(d_ur, 'mm') IN ('06', '11', '12'))) 
      OR ((plec = 'K') AND (imie2 IS NOT NULL))
ORDER BY osoba;

/*
Wyświetlić listę aktualnych kierowników wydziałów
*/

SELECT UPPER(w.nazwa) WYDZIAL, INITCAP(o.nazwisko)||' '||INITCAP(o.imie1) KIEROWNIK, k.od, z.pensja
FROM zatrudnienia z, wydzialy w, kierownicy k, osoby o
WHERE o.id_os = k.id_os AND k.id_w = w.id_w AND o.id_os = z.id_os AND k.do IS NULL AND z.do IS NULL
ORDER BY 1 ASC;



-- KWERENDY AGREGUJĄCE

/*
Wyświetlić datę urodzenia najstarszej osoby
*/

SELECT MIN(d_ur) najstarsza_osoba FROM OSOBY;

/*
Wyświetl aktualną liczbę osób wpisanych do tabeli osoby
*/

SELECT COUNT(id_os) liczba_osob
FROM osoby;

/*
Wyświetlić aktualną liczbę kobiet i mężczyzn w tabeli osoby
*/

SELECT plec, COUNT (id_os) liczba_osob
FROM osoby
GROUP BY plec
ORDER BY liczba_osob DESC;

/*
Wyświetlić dla poszczególnych stanowisk i dla poszczególnych liter alfabetu liczbę osób, o imionach
zaczynających się na tą samą literę zatrudnionych na poszczególnych stanowiskach
*/

SELECT LOWER(s.nazwa) stanowisko, SUBSTR(UPPER(o.imie1),1,1) litera, COUNT(o.id_os) liczba_osob
FROM stanowiska s, osoby o, zatrudnienia z
WHERE o.id_os = z.id_os AND s.id_s = z.id_s
GROUP BY LOWER(s.nazwa), SUBSTR(UPPER(o.imie1),1,1)
ORDER BY 1 ASC, 2 ASC, 3 ASC;

/*
Wyświetlić listę wydziałów, które zatrudniają aktualnie co najmniej dwie kobiety
*/

SELECT INITCAP(w.nazwa) wydzial, COUNT(o.id_os) liczba_kobiet
FROM wydzialy w, zatrudnienia z, osoby o
WHERE o.id_os = z.id_os AND w.id_w = z.id_w AND o.plec = 'K' AND z.do IS NULL
GROUP BY INITCAP(w.nazwa)
HAVING COUNT (o.id_os) >= 2
ORDER BY 2 DESC, 1 ASC;

/*
Wyświetlić alfabetyczną listę osób, które nie były jeszcze zatrudnione
*/

SELECT INITCAP(o.nazwisko)||' '||INITCAP(o.imie1) osoba
FROM osoby o LEFT JOIN zatrudnienia z ON o.id_os = z.id_os 
WHERE z.od IS NULL
ORDER BY 1 ASC;

/*
Wyświetlić dane najstarszej osoby (Katarzyna Wilk)
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1) osoba, d_ur data_urodzenia, plec
FROM osoby
WHERE d_ur = (SELECT MIN(d_ur) FROM osoby);

/*
Wyświetlić dane najstarszego mężczyzny
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1) osoba, d_ur data_urodzenia, plec
FROM osoby 
WHERE d_ur = (SELECT MIN(d_ur)
FROM osoby
WHERE plec = 'M');

/*
yświetlić dane najstarszej kobiety i najstarszego mężczyzny
*/

SELECT INITCAP(a.nazwisko)||' '||INITCAP(a.imie1) osoba, a.d_ur data_urodzenia, a.plec
FROM osoby a
WHERE d_ur = (SELECT MIN(d_ur)
FROM osoby b
WHERE a.plec = b.plec)
ORDER BY plec;

/*
Wyświetlić dane osoby o najdłuższym nazwisku
*/

SELECT INITCAP(nazwisko)||' '||INITCAP(imie1) osoba, d_ur data_urodzenia, plec
FROM osoby 
WHERE LENGTH(nazwisko) = (SELECT MAX(LENGTH(nazwisko)) FROM osoby);

/*
Wyświetlić dla każdego stanowiska, dane osoby o najdłuższym nazwisku, aktualnie zatrudnioną na danym stanowisku
*/

SELECT INITCAP(o.nazwisko)||' '||INITCAP(o.imie1) osoba, o.plec, s.nazwa stanowisko, LENGTH(o.nazwisko) nazwisko_dlugosc
FROM osoby o JOIN zatrudnienia z ON o.id_os = z.id_os JOIN stanowiska s ON s.id_s = z.id_s
WHERE z.do IS NULL AND LENGTH(o.nazwisko) = (SELECT MAX(LENGTH(o1.nazwisko))
      FROM osoby o1 JOIN zatrudnienia z1 ON o1.id_os = z1.id_os JOIN stanowiska s1 ON s1.id_s = z1.id_s
      WHERE s1.nazwa = s.nazwa AND z1.do IS NULL)
ORDER BY o.nazwisko ASC;

/*
Wyświetlić tę płeć, z której więcej osób jest wpisanych do tabeli osoby 
*/

--widok słownikowy

CREATE OR REPLACE VIEW plec_max_osob AS
SELECT plec, COUNT(id_os) liczba_osob
FROM osoby
GROUP BY plec;

SELECT plec, liczba_osob
FROM plec_max_osob
WHERE liczba_osob = (SELECT MAX(liczba_osob) FROM  plec_max_osob);

--widok tymczasowy

WITH plec_max_osob AS
(SELECT plec, COUNT(id_os) liczba_osob
FROM osoby
GROUP BY plec)
SELECT plec, liczba_osob
FROM plec_max_osob
WHERE liczba_osob = (SELECT MAX(liczba_osob) FROM plec_max_osob);

/*
Wyświetlić dla poszczególnych wydziałów tę płeć, z której najwięcej osób jest aktualnie zatrudnionych na nich
*/

--widok słownikowy

CREATE OR REPLACE VIEW wydzial_max_osob AS
SELECT INITCAP(w.nazwa) wydzial, o.plec plec, COUNT(o.id_os) liczba_osob
FROM osoby o JOIN zatrudnienia z ON o.id_os = z.id_os JOIN wydzialy w ON w.id_w = z.id_w
WHERE z.do IS NULL
GROUP BY INITCAP(w.nazwa), o.plec;

SELECT wmp.wydzial, wmp.plec, wmp.liczba_osob
FROM wydzial_max_osob wmp
WHERE wmp.liczba_osob = (SELECT MAX(wmp1.liczba_osob) 
                        FROM wydzial_max_osob wmp1
                        WHERE wmp1.wydzial = wmp.wydzial)
ORDER BY 1 ASC, 2 ASC; 
