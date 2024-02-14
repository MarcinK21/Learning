/*
Znajdź nazwiska występujące jednocześnie w placówce o identyfikatorze 1 i w placówce o identyfikatorze 6
*/

SELECT nazwisko 
FROM pracownicy 
WHERE id_placowki = 1 
INTERSECT
SELECT nazwisko
FROM pracownicy
WHERE id_placowki = 6;

/*
Znajdź nazwiska występujące w placówce o nazwie BIURO, ale nie występujące w placówce o nazwie
SKLEP I. Uporządkuj wyniki alfabetycznie. Nadaj kolumnie nazwę „Nazwiska – różnice”
*/

SELECT nazwisko "Nazwiska - różnice"
FROM pracownicy p JOIN placowki pl USING(id_placowki)
WHERE pl.nazwa = 'BIURO'
MINUS
SELECT nazwisko
FROM pracownicy p JOIN placowki pl USING(id_placowki)
WHERE pl.nazwa = 'SKLEP I'

/*
Wykorzystując operator algebraiczny wypisz w porządku alfabetycznym nazwiska wszystkich pracowników,
przy czym za nazwiskami pracowników z placówki o identyfikatorze 1 wypisz dodatkowo znak *
*/

SELECT nazwisko||'*' as nazwisko
FROM pracownicy
WHERE id_placowki = 1
UNION ALL
SELECT nazwisko
FROM pracownicy
where id_placowki != 1;

-- wykorzystując CASE

SELECT CASE 
  WHEN id_placowki = 1 then nazwisko||'*'
  ELSE nazwisko
  END "Nazwisko"
FROM pracownicy;
  
/*
Wykorzystując dowolną technikę wyświetl imiona i nazwiska pracowników oraz datę o trzy miesiące
późniejszą od daty zatrudnienia dla osób, które mają parzyste id_pracownika i datę o 6 miesięcy późniejszą od
daty zatrudnienia dla osób o nieparzystym id_pracownika. Ostatnią kolumnę zatytułuj „DATA SZKOLENIA”.
Uporządkuj wyniki alfabetycznie według nazwisk, a w przypadku takich samych nazwisk – alfabetycznie
według imion. Spraw, aby daty zostały wypisane w formacie DD/MM/YYYY
*/

SELECT imie, nazwisko,
TO_CHAR(ADD_MONTHS(data_zatrudnienia, 3), 'DD/MM/YYYY') "DATA SZKOLENIA"
FROM pracownicy
WHERE mod(id_pracownika, 2) = 0
UNION ALL
SELECT imie, nazwisko,
TO_CHAR(ADD_MONTHS(data_zatrudnienia, 6), 'DD/MM/YYYY') "DATA SZKOLENIA"
FROM pracownicy
WHERE mod(id_pracownika, 2) = 1;

/*
Wyświetl nazwy placówek wraz ze średnimi pensjami, które są w nich wypłacane. Uporządkuj wyniki
alfabetycznie według nazw placówek. Następnie zmodyfikuj instrukcję tak, aby dodatkowo został wyświetlony
wiersz z całkowitym podsumowaniem (średnią dla wszystkich pracowników)
*/

SELECT nazwa, avg(pensja) "średnia pensja"
FROM pracownicy p JOIN placowki pl USING(id_placowki)
GROUP BY nazwa
ORDER BY 1;

-- z podsumowaniem
SELECT nazwa, avg(pensja) "średnia pensja"
FROM pracownicy p JOIN placowki pl USING(id_placowki)
GROUP BY rollup(nazwa);

/*
Napisz zapytanie, które wyświetli nazwy miesięcy wraz z liczbą osób urodzonych w danym miesiącu oraz
podsumowaniem całkowitym pokazującym liczbę wszystkich osób. Uporządkuj wyniki rosnąco według liczby
osób
*/

SELECT TO_CHAR(data_urodzenia, 'MONTH'), count(id_pracownika)
from pracownicy
group by rollup(TO_CHAR(data_urodzenia, 'MONTH'));

/*
Napisz zapytanie wyświetlające średnie pensje w każdym z zawodów dla każdej z płci. Uporządkuj wyniki
alfabetycznie względem zawodów, a w przypadku takich samych zawodów – alfabetycznie względem płci
*/

SELECT zawod, plec, avg(pensja) as srednia_pensja
from pracownicy
group by zawod, plec
ORDER BY 1;

/*
Następnie zmodyfikuj instrukcję SELECT tak, aby otrzymać dodatkowo podsumowania dla każdego
z zawodów oraz podsumowanie całkowite dla wszystkich pracowników
*/

SELECT zawod, plec, avg(pensja) as srednia_pensja
from pracownicy
group by rollup(zawod, plec)
ORDER BY 1;

/*
Następnie zmodyfikuj poprzednie zapytanie tak, aby do wyniku zostały także dołączone podsumowania dla
każdej z płci.
*/

SELECT zawod, plec, avg(pensja) as srednia_pensja
from pracownicy
group by cube(zawod, plec)
ORDER BY 1;

/*
Napisz zapytanie wyświetlające liczbę osób posiadających dany poziom wykształcenia z podziałem na
poszczególne placówki. Spraw, aby w wyniku wyświetlone były także liczby osób dla poszczególnych
poziomów wykształcenia (bez rozbicia na placówki), a także wiersz z liczbą wszystkich pracowników.
Uporządkuj wyniki alfabetycznie według poziomów wykształcenia, a w przypadku takich samych poziomów
– alfabetycznie według nazw placówek
*/

SELECT w.poziom, pl.nazwa, count(p.id_pracownika) "liczba_osob"
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
  JOIN wyksztalcenie w ON w.id_wyksztalcenia = p.id_wyksztalcenia
GROUP BY GROUPING SETS( (w.poziom, pl.nazwa), w.poziom, () )
ORDER BY 1,2;

/*
Następnie przekształć zapytanie tak, aby nie było podsumowań po samych poziomach wykształceń, ale za to
były podsumowania po samych placówkach
*/

SELECT w.poziom, pl.nazwa, count(p.id_pracownika) "liczba_osob"
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
  JOIN wyksztalcenie w ON w.id_wyksztalcenia = p.id_wyksztalcenia
GROUP BY GROUPING SETS( (w.poziom, pl.nazwa), pl.nazwa, () )
ORDER BY 1,2;

/*
Następnie przekształć zapytanie tak, aby nie było w nim podsumowania całościowego
*/

SELECT w.poziom, pl.nazwa, count(p.id_pracownika) "liczba_osob"
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
  JOIN wyksztalcenie w ON w.id_wyksztalcenia = p.id_wyksztalcenia
GROUP BY GROUPING SETS( (w.poziom, pl.nazwa), pl.nazwa)
ORDER BY 1,2;

/*
Do każdego z zapytań z zadania 8 dołóż wyświetlanie grouping(poziom) i grouping(nazwa).
*/

SELECT w.poziom, pl.nazwa, count(p.id_pracownika), GROUPING(w.poziom), GROUPING(pl.nazwa)
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
  JOIN wyksztalcenie w ON w.id_wyksztalcenia = p.id_wyksztalcenia
GROUP BY GROUPING SETS( (w.poziom, pl.nazwa), pl.nazwa)
ORDER BY 1,2;

/*
Napisz zapytanie, które wyświetli minimalne pensje w każdej z placówek oraz minimalne pensje w każdym
z zawodów. Uporządkuj wyniki malejąco według minimalnych pensji, a w przypadku takich samych
minimalnych pensji – alfabetycznie po nazwie zawodu
*/

SELECT pl.nazwa, p.zawod, min(p.pensja) "minimalna pensja"
FROM pracownicy p JOIN placowki pl USING(id_placowki)
GROUP BY GROUPING SETS( pl.nazwa, p.zawod )
ORDER BY 3 DESC, 2;

/*
Napisz zapytanie, które wyświetli nazwy kursów wraz z liczbą osób, które w nich uczestniczyły, z podziałem
na płcie i ze wszystkimi możliwymi wariantami podsumowań częściowych i podsumowaniem całkowitym.
Weź przy tym pod uwagę jedynie osoby zatrudnione po 15 stycznia 2010 roku. Uporządkuj wyniki
alfabetycznie według nazw kursów, a w przypadku takich samych nazw – alfabetycznie według płci
*/

SELECT k.nazwa, p.plec, COUNT(p.id_pracownika) "liczba osob"
FROM pracownicy p JOIN uczestnictwo u ON p.id_pracownika = u.id_pracownika
  JOIN kursy k ON u.id_kursu = k.id_kursu
WHERE p.data_zatrudnienia > TO_DATE('15/01/2010', 'DD/MM/YYYY')
GROUP BY CUBE(k.nazwa, p.plec)
ORDER BY 1,2;
