/*
Biorąc pod uwagę relację bycia szefem ustawiono pracowników w pewnej hierarchii zależnej od liczby
przełożonych dzielących danego pracownika od szefa całej firmy. Wyświetl nazwiska i imiona pracowników
wraz z informacją o poziomie, który został im przypisany. Szef firmy (czyli osoba, która nie ma już na sobą
szefa) ma się znaleźć na pierwszym poziomie, jego bezpośredni podwładni na drugim, ich podwładni na
trzecim, itd
*/

SELECT nazwisko, imie, level
from pracownicy
start with id_szefa is null
connect by id_szefa = PRIOR id_pracownika;

/*
Dołóż do poprzedniego zapytania klauzulę ORDER SIBLINGS BY, aby posortować "dzieci"
danego węzła (czyli rodzeństwo) alfabetycznie według nazwisk.
*/

SELECT nazwisko, imie, level
from pracownicy
start with id_szefa IS NULL
connect by
id_szefa = PRIOR id_pracownika
order SIBLINGS by nazwisko;

/*
W poprzednim zapytaniu zamiast ORDER SIBLINGS BY uporządkuj wyniki rosnąco według poziomów,
a w przypadku takich samych poziomów – alfabetycznie według nazwisk
*/

SELECT nazwisko, imie, level
from pracownicy
start with id_szefa IS NULL
connect by id_szefa = PRIOR id_pracownika
order by level, nazwisko;

/*
Zbuduj analogiczne zapytanie do zapytania z punktu 2, ale zaczynające przeglądanie drzewa od pani
RACZKOWSKIEJ
*/

SELECT nazwisko, imie, level
from pracownicy
start with nazwisko = 'RACZKOWSKA' and plec = 'K'
connect by id_szefa = PRIOR id_pracownika
order SIBLINGS by nazwisko;

/*
Zaczynając od pracownika o nazwisku ZATORSKI wyświetl nazwiska i imiona jego przełożonych wraz
z poziomem, który jest im przypisany oraz dane ZATORSKIEGO
*/

SELECT nazwisko, imie, level
from pracownicy
start with nazwisko = 'ZATORSKI' and plec = 'M'
connect by id_pracownika = PRIOR id_szefa
order SIBLINGS by nazwisko;

/*
W jednym wybranym zadaniu z zapytaniem drzewiastym dodaj przed nazwiskiem tyle spacji, ile wynosi
poziom, który jest danemu pracownikowi przypisany
*/

SELECT lpad(nazwisko, length(nazwisko)+level,' ') nazwisko, imie, level
from pracownicy
start with nazwisko = 'ZATORSKI' and plec = 'M'
connect by id_pracownika = PRIOR id_szefa
ORDER BY nazwisko desc;


-- RÓŻNE ZŁĄCZENIA, PODZAPYTANIA 


/*
Wyświetl imiona, nazwiska i pensje pracowników wraz z nazwami placówek, w których pracują i poziomami
wykształcenia, które są im przypisane. Uporządkuj wyniki alfabetycznie według nazw placówek,
a w przypadku takich samych nazw – alfabetycznie według nazwisk.
*/

-- JOIN ON
SELECT p.imie, p.nazwisko, p.pensja, n.nazwa, w.poziom
from pracownicy p JOIN placowki n 
  ON p.id_placowki = n.id_placowki JOIN wyksztalcenie w 
  ON w.id_wyksztalcenia = p.id_wyksztalcenia
ORDER BY 4,2;


-- JOIN USING
SELECT imie, nazwisko, pensja, nazwa, poziom
from pracownicy JOIN placowki USING(id_placowki) 
  JOIN wyksztalcenie USING(id_wyksztalcenia)
ORDER BY 4,2;

/*
Wyświetl nazwy kursów, w których brały udział osoby powyżej 50 roku życia. Usuń z wyniku duplikaty.
Uporządkuj wyniki alfabetycznie
*/

-- JOIN USING
SELECT DISTINCT(nazwa)
FROM kursy JOIN uczestnictwo USING(id_kursu) 
  JOIN pracownicy USING(id_pracownika)
WHERE months_between(sysdate, data_urodzenia) > 50*12
ORDER BY nazwa;

-- JOIN ON
SELECT distinct(nazwa)
from kursy k JOIN uczestnictwo u ON k.id_kursu = u.id_kursu 
  JOIN pracownicy p ON p.id_pracownika = u.id_pracownika
where months_between(sysdate, data_urodzenia) > 50*12
ORDER BY nazwa;

/*
Napisz polecenie wyświetlające nazwy wszystkich(!) placówek wraz z liczbą osób, które są w nich
zatrudnione. Uporządkuj wyniki malejąco według liczby osób
*/

SELECT nazwa, count(id_pracownika)
from placowki left join pracownicy using(id_placowki)
group by nazwa
order by 2 desc;

/*
Wykorzystując samozłączenie wypisz nazwiska pracowników oraz nazwiska ich bezpośrednich przełożonych
(szefów). Posortuj wyniki według nazwisk przełożonych, a następnie, w przypadku tych samych przełożonych
alfabetycznie według nazwisk podwładnych.
*/

SELECT p.nazwisko "NAZWISKO PRACOWNIKA", s.nazwisko "NAZWISKO SZEFA"
FROM pracownicy p JOIN pracownicy s ON p.id_szefa = s.id_pracownika
ORDER BY 2,1;

/*
Spraw, aby na liście pracowników i ich bezpośrednich przełożonych zostało wypisane także nazwisko osoby,
która nie ma nad sobą zwierzchnika
*/

SELECT p.nazwisko "NAZWISKO PRACOWNIKA", s.nazwisko "NAZWISKO SZEFA"
FROM pracownicy p LEFT JOIN pracownicy s ON p.id_szefa = s.id_pracownika
ORDER BY 2,1;

/*
Wypisz nazwiska wszystkich pracowników, których bezpośrednim szefem jest pan Konecki. Wyniki
uporządkuj alfabetycznie.
*/

SELECT p.nazwisko "NAZWISKO PRACOWNIKA"
FROM pracownicy p LEFT JOIN pracownicy s ON p.id_szefa = s.id_pracownika
where s.nazwisko = 'KONECKI'
ORDER BY 1;

/*
Podaj imiona i nazwiska pracowników, którzy zostali zatrudnieni wcześniej niż ich szefowie. Uporządkuj
wyniki alfabetycznie według nazwisk, a w przypadku takich samych nazwisk – alfabetycznie według imion.
*/

SELECT p.imie "IMIE", p.nazwisko "NAZWISKO"
FROM pracownicy p JOIN pracownicy s ON p.id_szefa = s.id_pracownika
where s.data_zatrudnienia > p.data_zatrudnienia
order by 2,1;

/*
Wykorzystując podzapytanie wypisz nazwiska i numery pracownicze wszystkich pracowników będących
szefami. Uporządkuj wyniki alfabetycznie według nazwisk
*/

SELECT nazwisko, numer_pracowniczy "NUMER"
FROM pracownicy 
WHERE id_pracownika IN ( SELECT DISTINCT id_szefa FROM pracownicy)
ORDER BY 2;

/*
Wypisz imiona, nazwiska i płeć pracowników, którzy nie są szefami. Uporządkuj wyniki alfabetycznie według
nazwisk, a w przypadku takich samych nazwisk – alfabetycznie według imion. Wykorzystaj operator NOT IN
*/

SELECT imie, nazwisko, plec
FROM pracownicy
WHERE id_pracownika NOT IN ( SELECT DISTINCT id_szefa FROM pracownicy 
                              WHERE id_szefa IS NOT NULL )
ORDER BY 2, 1;

/*
Wykorzystując operator EXISTS wypisz imiona i nazwiska osób, które są szefami. Uporządkuj wyniki
alfabetycznie według nazwisk, a w przypadku takich samych nazwisk – alfabetycznie według imion
*/

SELECT imie, nazwisko
FROM pracownicy p
WHERE EXISTS ( SELECT 1 FROM pracownicy WHERE id_szefa = p.id_pracownika )
ORDER BY 2,1;

/*
Wypisz nazwiska kobiet, które są szefami. Uporządkuj wyniki
alfabetycznie
*/

SELECT nazwisko
FROM pracownicy p
WHERE EXISTS ( SELECT 1 FROM pracownicy WHERE id_szefa = p.id_pracownika) AND plec = 'K'
ORDER BY 1;

/*
Wypisz nazwiska osób, których szefem jest kobieta pracująca
w zawodzie sprzedawcy. Uporządkuj wyniki alfabetycznie
*/

SELECT p.nazwisko "pracownik"
FROM pracownicy p join pracownicy s ON p.id_szefa = s.id_pracownika
WHERE s.zawod = 'SPRZEDAWCA'
  AND s.plec = 'K'
ORDER BY 1;

/*
Wypisz nazwiska i pensje pracowników wraz z informacją o liczbie osób pracujących w tym samym zawodzie
co dana osoba i średniej pensji osób pracujących w tym samym zawodzie, co dana osoba. Trzecią kolumnę
zatytułuj LICZBA OSÓB W ZAWODZIE, czwartą – ŚREDNIA PENSJA W ZAWODZIE. Uporządkuj wyniki
alfabetycznie według nazwisk. Średnie pensje zaokrąglij do dwóch miejsc po przecinku
*/

SELECT nazwisko, pensja,( SELECT COUNT(id_pracownika) FROM pracownicy
  WHERE zawod = p.zawod ) "LICZBA OSOB W ZAWODZIE",
ROUND((SELECT AVG(pensja) FROM pracownicy 
  WHERE zawod = p.zawod ), 2) "SREDNIA PENSJA W ZAWODZIE"
FROM pracownicy p
ORDER BY 1;

/*
Wykorzystując podzapytanie skorelowane na liście SELECT wypisz nazwiska pracowników oraz nazwiska ich
bezpośrednich przełożonych. Posortuj wyniki według nazwisk przełożonych, a następnie, w przypadku tych
samych przełożonych alfabetycznie według nazwisk podwładnych
*/

SELECT p.nazwisko "Nazwisko pracownika", (
  SELECT s.nazwisko
    FROM pracownicy s
    WHERE s.id_pracownika = p.id_szefa 
  ) "Nazwisko szefa"
FROM pracownicy p
ORDER BY 2,1;