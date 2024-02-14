# Dokumentacja projektu: Analiza danych medycznych z użyciem technik uczenia maszynowego

## Cel projektu:
Celem projektu jest zastosowanie różnych technik przetwarzania danych i uczenia maszynowego do analizy zbioru danych medycznych dotyczących guzów piersi. Projekt ma na celu identyfikację cech charakterystycznych dla guzów łagodnych i złośliwych oraz budowę modeli predykcyjnych klasyfikujących guzy na podstawie dostępnych cech

## Dane:
źródło: https://www.kaggle.com/datasets/uciml/breast-cancer-wisconsin-data

Dane zawierają 569 wierszy i 11 kolumn (po usunięciu zbędnych kolumn)

Kolumny obejmują różnorodne pomiary związane z diagnozą raka piersi, takie jak(po usunięciu zbędnych kolumn):
* diagnosis - diagnoza ( M - malignant(złośliwy), B - benign(łagodny))
* radius - promień - średnia odległości od środka do punktów na obwodzie
* texture - tekstura - wartości w skali szarości
* perimeter -  obwód
* area - obszar
* smoothness - gładkość (lokalne zmiany długości promienia)
* compactness - zwartość (obwód^2 / powierzchnia -1)
* concavity - wklęsłość (nasilenie wklęsłych części konturu)
* concave points - punkty wklęsłe (liczba części wklęsłych konturu)
* symmetry - symetria
* fractal dimension - wymiar fraktalny 

Wszystkie wartości cech są z czterema cyframi znaczącymi

## Przetwarzanie danych:
* Usunięcie niepotrzebnych kolumn: Z danych usunięto kolumny nieistotne dla analizy, w tym identyfikatory pacjentów i mary błędów standardowych, a także miary "najgorsze" dla każdej z cech
* Zamiana etykiet: Etykiety 'M' i 'B' zostały zastąpione wartościami numerycznymi (1 dla złośliwych, 0 dla łagodnych) dla łatwiejszej obróbki danych
* Standaryzacja: Dane zostały znormalizowane do zakresu [0,1], co zapewnia równomierny wpływ wszystkich cech na model

## Analiza i wizualizacja danych:
* Wizualizacja: 

Przeprowadzono również wizualizacje danych za pomocą wykresów rozkładu, wykresów pudełkowych i wykresów gęstości, aby lepiej zrozumieć charakterystyki i rozkłady poszczególnych cech

* PCA:

Przeprowadzaono redukcję wymiarowości danych do dwóch głównych komponentów, co pozwoliło na wizualizację rozkładu próbek w przestrzeni dwuwymiarowej. Analiza PCA ujawniła częsciowe rozdzielenie między guzami złośliwymi i łagodnymi, co sugeruje jej potencjalną użyteczność w klasyfikacji guzów

* t-SNE:

Zastosowano t-SNE do dalszej wizualizacji danych w przestrzeni dwuwymiarowej. Metoda ta lepiej niż PCA uwypukliła grupowanie próbek w zależności od diagnozy, pokazując wyraźniejsze rozdzielenie między guzami

## Budowa modeli predykcyjnych:
* Las losowy (Random Forest):

Zbudowano i przetestowano model klasyfikacyjny. Model wykazał wysoką dokładność w rozróżnianiu guzów, co zostało zweryfikowane za pomocą macierzy błędów i raportu klasyfikacji

* Regresja Logistyczna:
* KNN
* SVM

## Wnioski z budowy modeli predykcyjnych:

Analiza z użyciem technik uczenia maszynowego pokazała, że modele potrafią skutecznie klasyfikować guzy na podstawie dostępnych cech. Wizualizacje PCA i t-SNE dostarczyły cennych wglądów w strukturę danych, podkreślając różnice między guzami 

Model lasu losowego wyróżnił się najwyższą wydajnością

## Ranking istotności cech (Rekurencyjna eliminacja cech z walidacją krzyżową RFECV):

W projekcie wykorzystano również RFECV z regresją logistyczną jako estymatorem, co pozwoliło na precyzyjne określenie i wybór najbardziej istotnych cech dla modelowania. Proces ten ułatwia budowę bardziej efektywnych modeli, skupiając się tylko na cechach, które mają największy wpływ na wyniki

## Podsumowanie i wnioski:

Projekt wykazał, jak techniki przetwarzania danych i uczenia maszynowego mogą być wykorzystywane do analizy zbiorów danych medycznych. Wykorzystanie różnych metod, od wstępnego przetwarzania danych, przez analizę i wizualizację, po budowę i ocenę modeli predykcyjnych, pozwoliło na uzyskanie cennych wglądów w charakterystykę guzów piersi oraz na rozwój skutecznych narzędzi do ich klasyfikacji. Metody redukcji wymiarowości, takie jak PCA i t-SNE, dostarczyły dodatkowych wglądów, umożliwiając wizualną ocenę rozdzielenia klas guzów

Modele takie jak Las Losowy, Regresja Logistyczna, KNN, i SVM wykazały się dużą skutecznością w rozróżnianiu między guzami

## Dalsze możliwości rozwoju projektu:
Dalsze badania mogą koncentrować się na eksploraacji bardziej zaawansowanych technik uczenia maszynowego oraz przede wszystkim uczenia głębokiego.

Rozszerzenie danych o dodatkowe cechy, większą liczbę próbek, oraz porównanie wyników z aktualnymi metodami mogłoby zwiększyć wartość i dokładność analizy
