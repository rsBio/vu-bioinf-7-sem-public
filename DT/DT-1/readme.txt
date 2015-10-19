Turedamas atributu sarasa faile 'attributes' ir skaicius faile 'data', 
skaitau juos su programa 'make-arff'
ir pagaminu 'arff.arff' arff sintakses faila.
Tada su programa "weka" pasidarau 4 failus:
'my_arff.arff' - palikti tik 3 (2 numeric ir 1 nominalusis(?)) atributai
'my_arff--x' - atributu duomenys diskretizuoti intervalais.
Programa 'grep-count.pl' paskaiciuoja ir isveda
kiek kokiu iverciu patenka i intervalus. Sitie stulpeliai suvedami i 
atitinkamas excel lenteles.
