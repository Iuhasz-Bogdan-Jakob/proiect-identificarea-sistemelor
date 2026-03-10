# proiect-identificarea-sistemelor

Identificarea Sistemelor Dinamice (Ordin II)

Acest proiect explorează diverse metode de identificare a modelelor matematice pentru sisteme dinamice, utilizând un set de date realizat experimental și prelucrarea acestora în MATLAB. Lucrarea este structurată pe trei piloni principali de analiză: identificarea aperiodică, analiza în frecvență (metode neparametrice) și metodele parametrice.

Capitole și Metodologii

1. Identificarea prin Regresie Liniară (Sistem Hidraulic)

    Proces: Reglarea nivelului în două rezervoare deschise conectate în serie.

    Metodă: Utilizarea semnalelor de tip treaptă pentru determinarea factorului de proporționalitate K și a constantelor de timp (T1​, T2​) prin logaritmarea răspunsului indicial.

    Validare: Compararea modelului în condiții inițiale nule (funcție de transfer) versus condiții inițiale nenule (spațiul stărilor), obținând o precizie mult superioară în spațiul stărilor (eroare medie pătratică sub 10%).

2. Identificarea prin Semnale Chirp (Răspuns în Frecvență)

    Proces: Același sistem hidraulic de ordinul II.

    Metodă: Utilizarea semnalelor Chirp pentru a mătura o gamă largă de frecvențe și a identifica pulsația naturală ωn​ și factorul de amortizare ζ.

    Rezultat: Reconstruirea constantelor de timp pornind de la faza de −90∘ identificată experimental cât și cu ajutorul cunoștintelor a priori despre diagrama Nyquist.

3. Metode Parametrice (Convertor DC-DC Boost)

    Proces: Identificarea dinamicii unui circuit electric de tip convertor ridicător de tensiune.

    Semnal de intrare: Combinație de semnal trapezoidal (pentru punctul de funcționare) și SPAB (Semnal Pseudo-Aleator Binar) pentru excitarea dinamicii.

    Modele Explorate: ARMAX, Output-Error (OE) și State-Space (ssest).

    Model Optim: Structura Output-Error (OE [2 2 0]) a fost selectată ca fiind cea mai robustă, fiind singura care a satisfăcut integral testele de intercorelație statistică a reziduurilor.

 Unelte utilizate

    MATLAB & System Identification Toolbox: Pentru estimarea modelelor (funcțiile armax, oe, ssest, compare, resid).

    Identificare Parametrică: Tehnici de rafinare a datelor precum detrend, decimare și filtrare mediană.
