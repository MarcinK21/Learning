/*
DROP TABLE czlonkowie_rodzin CASCADE CONSTRAINTS;
DROP TABLE osoby_na_utrzymaniu CASCADE CONSTRAINTS;
DROP TABLE pracownicy CASCADE CONSTRAINTS;
DROP TABLE oddzialy_firmy CASCADE CONSTRAINTS;
DROP SEQUENCE pracownicy_sekw;
*/

CREATE TABLE oddzialy_firmy
  (
    id    			NUMBER(2) CONSTRAINT oddzialy_firmy_PK PRIMARY KEY,
    nazwa 			VARCHAR2(50) NOT NULL,
    id_kierownika	NUMBER(4) CONSTRAINT oddzialy_firmy_kierow_U UNIQUE,
	CONSTRAINT oddzialy_firmy_CH CHECK (INITCAP(nazwa)=nazwa)
  );

CREATE TABLE pracownicy
  (
    id                NUMBER(4) CONSTRAINT pracownicy_PK PRIMARY KEY,
    pierwsze_imie     VARCHAR2(15) NOT NULL,
    drugie_imie       VARCHAR2(15),
    nazwisko          VARCHAR2(30) NOT NULL,
    pesel             VARCHAR2(11) NOT NULL 
	                     CONSTRAINT pracownicy_pesel_CH CHECK(length(pesel)=11) 
	                     CONSTRAINT pracownicy_pesel_U UNIQUE,
    plec              CHAR(1) NOT NULL CONSTRAINT pracownicy_plec_CH CHECK ( plec IN ('K', 'M')),
    data_urodzenia    DATE NOT NULL,
    data_zatrudnienia DATE DEFAULT SYSDATE NOT NULL,
    id_oddzialu       NUMBER(2) NOT NULL CONSTRAINT pracownicy_oddzialy_FK REFERENCES oddzialy_firmy(id),
	id_przelozonego   NUMBER(4) CONSTRAINT pracownicy_przelozony_FK REFERENCES pracownicy (id),
	CONSTRAINT pracownicy_daty_CH CHECK (data_zatrudnienia>data_urodzenia),
	CONSTRAINT pracownicy_nazwisko_CH CHECK (INITCAP(nazwisko)=nazwisko),
	CONSTRAINT pracownicy_p_imie_CH CHECK (INITCAP(pierwsze_imie)=pierwsze_imie),
	CONSTRAINT pracownicy_d_imie_CH CHECK (INITCAP(drugie_imie)=drugie_imie)
  );
  
ALTER TABLE oddzialy_firmy ADD CONSTRAINT oddzialy_firmy_pracownicy_FK FOREIGN KEY (id_kierownika) REFERENCES pracownicy(id) ;

CREATE TABLE CZLONKOWIE_RODZIN
  (
    pierwsze_imie         VARCHAR2(15),
    plec                  CHAR(1) NOT NULL 
	                      CONSTRAINT czlonkowie_rodzin_plec_CH CHECK (plec IN ('K', 'M')),
    data_urodzenia        DATE NOT NULL ,
    stopien_pokrewienstwa VARCHAR2(30) NOT NULL,
	id_pracownika         NUMBER(4) CONSTRAINT czlonkowie_rodzin_prac_FK REFERENCES pracownicy(id),
	CONSTRAINT czlonkowie_rodzin_PK PRIMARY KEY (id_pracownika, pierwsze_imie),
	CONSTRAINT czlonkowie_rodzin_imie_CH CHECK (INITCAP(pierwsze_imie)=pierwsze_imie)
  );


CREATE INDEX pracownicy_NPI_IND on pracownicy(nazwisko, pierwsze_imie);
  
CREATE SEQUENCE pracownicy_SEKW
START WITH 1
INCREMENT BY 1;
  
INSERT INTO oddzialy_firmy VALUES (1, 'Oddział Łódź', NULL);
INSERT INTO oddzialy_firmy VALUES (2, 'Oddział Kraków', NULL);
INSERT INTO oddzialy_firmy VALUES (3, 'Oddział Gdańsk', NULL);    

INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL, 'Jan', 'Piotr', 'Nowak','67110512816', 'M', 	TO_DATE('05/11/1967','DD/MM/YYYY'), TO_DATE('01/01/2021','DD/MM/YYYY'),  1, NULL);

INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL, 'Alicja', NULL, 'Tracz', '76071509449','K', TO_DATE('15/07/1976','DD/MM/YYYY'), TO_DATE('01/01/2021','DD/MM/YYYY'), 1, (SELECT id FROM pracownicy WHERE pesel= '67110512816'));
	
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL, 'Wojciech', 'Jakub', 'Sosnowski','58122478773','M', TO_DATE('24/12/1958','DD/MM/YYYY'), TO_DATE('01/01/2021','DD/MM/YYYY'),  2, (SELECT id FROM pracownicy WHERE pesel= '67110512816'));
				
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL, 'Jakub', NULL, 'Kot','78101908736', 'M', TO_DATE('19/10/1978','DD/MM/YYYY'), DEFAULT,  2, (SELECT id FROM pracownicy WHERE pesel= '58122478773'));
			
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL, 'Anna', 'Maria', 'Wójcik','68032723801', 'K', TO_DATE('27/03/1968','DD/MM/YYYY'), TO_DATE('01/02/2021','DD/MM/YYYY'),  3, (SELECT id FROM pracownicy WHERE pesel= '67110512816'));

INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL, 'Mariola', 'Ewa', 'Zimnicka','74071335781', 'K', TO_DATE('13/07/1974','DD/MM/YYYY'), TO_DATE('01/02/2021','DD/MM/YYYY'), 3, (SELECT id FROM pracownicy WHERE pesel= '68032723801'));

INSERT INTO czlonkowie_rodzin VALUES('Zofia', 'K', TO_DATE('05/11/2009','DD/MM/YYYY'), 'córka',
(SELECT id FROM pracownicy WHERE pesel='74071335781'));

INSERT INTO czlonkowie_rodzin VALUES('Maciej', 'M', TO_DATE('12/04/2011','DD/MM/YYYY'), 'syn',
(SELECT id FROM pracownicy WHERE pesel='74071335781'));

INSERT INTO czlonkowie_rodzin VALUES('Michalina', 'K', TO_DATE('05/11/2012','DD/MM/YYYY'), 'córka',
(SELECT id FROM pracownicy WHERE pesel='68032723801'));

COMMIT;

CREATE UNIQUE INDEX oddzialy_firmy_N_U_IND on oddzialy_firmy(nazwa);

UPDATE oddzialy_firmy 
SET id_kierownika=(SELECT id FROM pracownicy WHERE pesel='67110512816')
WHERE id=1;

UPDATE oddzialy_firmy 
SET id_kierownika=(SELECT id FROM pracownicy WHERE pesel='58122478773')
WHERE id=2;

UPDATE oddzialy_firmy 
SET id_kierownika=(SELECT id FROM pracownicy WHERE pesel='68032723801')
WHERE id=3;
  
COMMIT;

ALTER TABLE oddzialy_firmy MODIFY id_kierownika NOT NULL;

ALTER TABLE czlonkowie_rodzin add CONSTRAINT czlonkowie_rodzin_CH CHECK ((stopien_pokrewienstwa='córka' AND plec='K') OR (stopien_pokrewienstwa='syn' AND plec='M') OR stopien_pokrewienstwa not in ('córka', 'syn'));

/*
INSERT INTO czlonkowie_rodzin VALUES('Marysia', 'M', TO_DATE('05/11/2004','DD/MM/YYYY'), 'córka',(SELECT id FROM pracownicy WHERE pesel='68032723801'));

INSERT INTO czlonkowie_rodzin VALUES('Marysia', 'K', TO_DATE('05/11/1969','DD/MM/YYYY'), 'żona',(SELECT id FROM pracownicy WHERE pesel='68032723801'));
*/

ALTER TABLE czlonkowie_rodzin DROP CONSTRAINT czlonkowie_rodzin_CH;

ALTER TABLE pracownicy MODIFY nazwisko VARCHAR2(40);

ALTER TABLE pracownicy MODIFY id_oddzialu DEFAULT 1;

RENAME czlonkowie_rodzin to osoby_na_utrzymaniu;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_PK TO osoby_na_utrzymaniu_PK;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_plec_CH TO osoby_na_utrzymaniu_plec_CH;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_imie_CH TO osoby_na_utrzymaniu_imie_CH;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_prac_FK TO osoby_na_utrzymaniu__prac_FK;


-- ALTER SESSION SET NLS_DATE_FORMAT='DD MON YYYY';
-------------------------------------------------------------------
SELECT * FROM pracownicy;
SELECT * FROM oddzialy_firmy;
SELECT * FROM osoby_na_utrzymaniu;


