/*
Dla pracowników, którzy mają mają nieparzyste id_pracownika i jednocześnie nie mają przyznanego dodatku wypisz
imiona i nazwiska połączone spacją, id_pracownika oraz pensję. Uporządkuj wyniki malejąco według pensji. Spraw,
aby pierwsze litery imion i nazwisk były wielkie, a pozostałe – małe. Zadbaj o alias.
*/

SELECT INITCAP(imie) || ' ' || INITCAP(nazwisko) osoba, id_pracownika, pensja
FROM pracownicy
WHERE dodatek IS null AND MOD(id_pracownika, 2) = 1
ORDER BY 3 DESC;

/*
Dla pracowników zatrudnionych w drugim kwartale roku wypisz imiona, nazwiska, roczne zarobki (czyli 12 pensji)
oraz całkowite roczne zarobki (12 pensji wraz z wypłacanym raz w roku (opcjonalnym) dodatkiem). Przedostatnią
kolumnę zatytułuj „ROCZNE ZAROBKI”, a ostatnią - „CAŁKOWITE ROCZNE ZAROBKI” (zwróć uwagę na
wielkość liter w nagłówku). Uporządkuj wyniki alfabetycznie według nazwisk, a w przypadku takich samych nazwisk
– alfabetycznie według imion.
*/

SELECT imie, nazwisko, 12*pensja "ROCZNE ZAROBKI", 12*pensja+NVL(dodatek,0) "CAŁKOWITE ROCZNE ZAROBKI"
FROM pracownicy 
WHERE TO_CHAR(data_zatrudnienia,'Q')='2'
ORDER BY 2 ASC, 1 ASC;

/*
Wyświetl inicjały osób, których zawody kończą się na literę K. Napisz to zapytanie na dwa sposoby – raz
z wykorzystaniem operatora LIKE, a raz z wykorzystaniem funkcji SUBSTR (złożonej z funkcją LENGTH albo
wywołanej z ujemnym parametrem).
*/

SELECT SUBSTR(imie, 1, 1)||'.'||SUBSTR(nazwisko, 1, 1)||'.' "Inicjaly"
FROM pracownicy
WHERE SUBSTR(zawod, -1, 1) = 'K';

SELECT SUBSTR(imie, 1, 1)||'.'||SUBSTR(nazwisko, 1, 1)||'.' "Inicjaly"
FROM pracownicy
WHERE zawod LIKE '%K';

/*
Wyświetl aktualną datę i godzinę systemu operacyjnego, na którym znajduje się SZBD (w podanym formacie).
Kolumnę zatytułuj AKTUALNA DATA I CZAS
*/

SELECT TO_CHAR(sysdate, 'DD fmRM YYYY HH:MI:SS') "AKTUALNA DATA I CZAS"
FROM dual;

/*
Wypisz imiona i nazwiska wszystkich osób. Dodatkowo w ostatniej kolumnie wyświetl napis „KOBIETA” lub
„MĘŻCZYZNA” w zależności od płci danej osoby. Ostatnią kolumnę zatytułuj PŁEĆ. Napisz to zapytanie na dwa
sposoby – raz z konstrukcją CASE, a raz z funkcją DECODE
*/

SELECT imie, nazwisko, DECODE(plec, 'K', 'KOBIETA', 'M', 'MEZCZYZNA') plec
FROM pracownicy ;

SELECT imie, nazwisko, DECODE(plec, 'K', 'KOBIETA', 'M', 'MEZCZYZNA') plec
FROM pracownicy ;
SELECT imie, nazwisko, CASE plec 
WHEN 'K' THEN 'KOBIETA' 
WHEN 'M' THEN 'MEZCZYZNA' 
END plec
FROM pracownicy;

/*
Wyświetl imiona, nazwiska i zawody tych osób, których nazwisko ma najmniejszą liczbę znaków (czyli jest
najkrótsze ze wszystkich nazwisk).
*/

SELECT imie, nazwisko, zawod
FROM pracownicy 
WHERE LENGTH(nazwisko) = (SELECT MIN(LENGTH(nazwisko)) FROM pracownicy);

/*
Wypisz wszystkie nazwiska pracowników, każde poprzedzone taką liczbą spacji jak długość danego nazwiska
*/

SELECT LPAD(nazwisko, 2*LENGTH(nazwisko), ' ') lista
FROM pracownicy;

/*
Wypisz imiona i nazwiska pracowników połączone spacją a za nazwiskiem tyle gwiazdek, jaki jest identyfikator
placówki, w której pracownik pracuje.
*/

SELECT RPAD(imie||' '||nazwisko, LENGTH(imie||' '||nazwisko)+id_placowki , '*') napis
FROM pracownicy;

/*
Zmień domyślny format wyświetlania daty na DD MON YYYY HH24:MI
*/

ALTER SESSION SET NLS_DATE_FORMAT='DD MON YYYY HH24:MI';
SELECT * FROM V$NLS_PARAMETERS;

/*
W pierwszej kolumnie wypisz daty urodzenia wszystkich pracowników,
w drugiej kolumnie datę o trzy dni późniejszą od daty z pierwszej kolumny,
w trzeciej kolumnie datę o 5 dni wcześniejszą od daty pierwszej kolumny,
w czwartej kolumnie datę o miesiąc późniejszą od daty pierwszej kolumny
i w piątej kolumnie datę o trzy miesiące wcześniejszą od daty pierwszej kolumny.
Nadaj kolumnom aliasy.
*/

SELECT data_urodzenia d_ur, 
data_urodzenia+3 "D_UR + 3 dni", 
data_urodzenia-5 "D_UR - 5 dni", 
ADD_MONTHS(data_urodzenia, 1) "D_UR + miesiac", 
ADD_MONTHS(data_urodzenia, -3) "D_UR - 3 miesiace" 
FROM pracownicy;

/*
W pierwszej kolumnie wyświetl aktualną datę i czas systemu operacyjnego, w drugiej moment, który nastąpi godzinę
później, a w trzeciej moment, który nastąpił 5 godziny wcześniej niż teraz
*/

SELECT sysdate teraz, sysdate+1/24 "GODZINĘ PÓŹNIEJ", sysdate-5/24 "PIEC GODZIN WCZESNIEJ"
FROM dual;

/*
Zmień domyślny format wyświetlania daty na YYYY/MM/DD.
*/

ALTER SESSION SET NLS_DATE_FORMAT='YYYY/MM/DD';
SELECT * FROM V$NLS_PARAMETERS;

/*
Wyświetl datę najbliższego czwartku po dniu 9 maja 2023 roku
*/

SELECT NEXT_DAY(TO_DATE('2023/05/09', 'YYYY/MM/DD'), 'CZWARTEK') "Nastepny czwartek"
FROM dual;

/*
Wyświetl datę ostatniego dnia lutego 2024 roku. Spraw, aby data ta została wyświetlona w formacie dzień miesiąca
dwucyfrowo nazwa miesiąca małymi literami rok czterocyfrowo
*/

SELECT TO_CHAR(LAST_DAY(TO_DATE('01 luty 2024', 'DD MONTH YYYY')), 'DD fmmonth YYYY') "Ostatni dzien"
FROM dual;

/*
Wypisz imiona i nazwiska kobiet urodzonych w niedzielę
*/

SELECT imie, nazwisko
FROM pracownicy 
WHERE plec = 'K' AND TO_CHAR(data_urodzenia, 'day') = 'NIEDZIELA';

/*
W pierwszej kolumnie wyświetl nazwiska pracowników, a w drugiej kolumnie te same nazwiska, tylko z literami K
zamienionymi na znak zapytania i literami A zamienionymi na gwiazdki
*/

SELECT nazwisko, TRANSLATE(nazwisko, 'KA', '?*') "nazwisko po zmianie"
FROM pracownicy;

/*
W pierwszej kolumnie wyświetl nazwiska pracowników, a w drugiej kolumnie te same nazwiska, tylko z fragmentem
SZKA zmienionym na SZKOWA
*/

SELECT nazwisko, REPLACE(nazwisko, 'SZKA', 'SZKOWA') "nazwisko po zmianie"
FROM pracownicy;

/*
Wyświetl nazwiska, w których występuje litera H. Nie używaj operatora LIKE
*/

SELECT nazwisko
FROM pracownicy
WHERE INSTR(nazwisko, 'H') > 0;

/*
Utworzono 10 kategorii zaszeregowania pensji pracowników (dla przedziału [0, 10000)). Wyświetl imiona, nazwiska
i pensje pracowników wraz z numerem kategorii zaszeregowania. Uporządkuj wyniki malejąco według kategorii
*/

SELECT imie, nazwisko, pensja, width_bucket(pensja, 0,10000, 10)
FROM pracownicy;

/*
Wypisz identyfikatory pracowników oraz napis „Zbyt niska pensja” jeśli pensja pracownika jest niższa niż 3500 lub
wartość pensji, jeśli pensja jest większa lub równa 3500. Uporządkuj wyniki rosnąco według identyfikatorów
pracowników.
*/

SELECT id_pracownika, CASE 
                      when pensja < 3500 then 'Zbyt niska pensja'
                      when pensja >= 3500 then to_char(pensja)
                      end "INFORMACJA"
FROM pracownicy;
