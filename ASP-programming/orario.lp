%*
Progetto Esame IALAB - ASP
Generazione del calendario settimanale delle lezioni di una scuola media che aderisce al progetto “Pellico”
*%

%*
Specifica del dominio di riferimento

Testo cosegna:
<--
ci sono otto aule: lettere (2 aule), matematica, tecnologia, musica, inglese, spagnolo, religione;
ci sono tre laboratori: arte, scienze, educazione fisica (palestra);
-->

Con aula(NomeAula) definiamo le aule che abbiamo deciso di chiamare con colori
Non viene fatta distinzone tra aule e laboratori intendoli il medesimo spazio destinato all'insegnamento
*%

%* [1] *%	aula(rossa;verde;gialla;blu;viola;arancione;bianca;azzurra;marrone;nera;lilla).

%*
Testo cosegna:
<--
ci sono due docenti per ciascuno dei seguenti insegnamenti: lettere, matematica, scienze;
vi è un unico docente per tutti gli altri insegnamenti;
-->

Con docente(NomeDocente) definiamo gli 11 docenti con nomi propri di persona
Con insegnamento(NomeInsegnamento) gli insegnamenti dati dal testo di cosegna
Arbitrariamente abbiamo scelto altri 4 insegnamenti come attività extra-scolastiche
*%

%* [2] *%	docente(andrea;federico;marco;luigi;lorenzo;martina;alice;francesca;rebecca;erica;federica).
%* [3] *%	insegnamento(lettere;matematica;tecnologia;musica;inglese;spagnolo;religione;arte;scienze;educazioneFisica;chimica;tedesco;portoghese;geometria).
%* [4] *%	insegnamento_extra(chimica;tedesco;portoghese;geometria).

%*
Testo cosegna:
<--
ci sono due classi per ogni anno di corso, una a regime “tempo prolungato” ed una a regime “tempo normale”.
Si assuma  che  l’unica  differenza  riguarda  la  frequenza  di attività  extra-scolastiche  e  la  partecipazione  alla  mensa scolastica,
mentre non vi è alcuna differenza per quanto riguarda   il   calendario   delle   lezioni,   di   30   ore complessive,
-->

Con ora(NumeroOra) si definisce l'insieme di ore nella giornata
Con ore_al_giorno(Numero) si definisce il numero massimo di ore nella giornata
Queste ore servono per le classi con attività extra-scolastiche
*%

%* [5] *%	ora(1..10).
%* [6] *%	ore_al_giorno(10).

%*
Testo cosegna:
<--
da distribuire in 5 giorni (da lunedì a venerdì), 6 ore al giorno.
-->

Con giorno(NomeGiorno) si definisco i convenzionali primi 5 giorni della settimana
Con ora_standerd(NumeroOra) si definisce l'insieme di ore dedicare alle lezioni, non per attività extra-scolastiche
*%

%* [7] *%	giorno(lunedi;martedi;mercoledi;giovedi;venerdi).
%* [8] *%	ora_standard(1..6).

%*
Testo cosegna:
<--
le classi sono, pertanto: 1A, 1B, 2A, 2B, 3A, 3B;
-->

Con classe(NomeClasse) si specificano le classi come da consegna
*%

%* [9] *%	classe(a1;b1;a2;b2;a3;b3).

%*
Testo cosegna:
<--
Per convenzione, si assuma che la sezione A sia tempo prolungato e che la sezione B sia tempo normale
-->

Con tempo_prolungato(NomeClasse) si definisco le classi con attività extra-scolastiche
*%

%* [10] *%	tempo_prolungato(a1;a2;a3).

%*
Con aula_riservata(NomeAula,NomeInsegnamento) viene creata la relazione del progetto “Pellico”
la scelta degli accoppiamenti e puramente arbitraria
*%

%* [11] *%
aula_riservata(rossa,lettere).
aula_riservata(verde,lettere).
aula_riservata(gialla,matematica).
aula_riservata(blu,scienze).
aula_riservata(viola,inglese).
aula_riservata(arancione,spagnolo).
aula_riservata(bianca,musica).
aula_riservata(azzurra,tecnologia).
aula_riservata(marrone,arte).
aula_riservata(nera,educazioneFisica).
aula_riservata(lilla,religione).

%*
Testo cosegna:
<--
ogni docente insegna una ed una sola materia, con l’eccezione di matematica e scienze,
ossia un docente incaricato di insegnare matematica risulterà anche insegnante di scienze (non necessariamente per la stessa classe);
-->

Con istruisce(NomeDocente,NomeInsegnamento) viene creata la relazione tra gli insegnanti e le rispettive materie
*%

%* [12] *%
istruisce(andrea,lettere).
istruisce(alice,lettere).
istruisce(marco,matematica).
istruisce(marco,scienze).
istruisce(martina,matematica).
istruisce(martina,scienze).
istruisce(lorenzo,inglese).
istruisce(luigi,spagnolo).
istruisce(rebecca,musica).
istruisce(erica,tecnologia).
istruisce(federica,arte).
istruisce(federico,educazioneFisica).
istruisce(francesca,religione).

%*
Specifica dei docenti per le attività extra-scolastiche che sono insegnate da docenti delle materie tradizionali
Con docente_extra(NomeDocente) si specifica l'insegnante che si occupera delle attività extra-scolastiche
Le relazioni sono state scelte per affinita di materia
*%

%* [13] *%	docente_extra(Docente) :- insegnamento_extra(Insegnamento), istruisce(Docente,Insegnamento).

%* [12] bis *%
istruisce(Docente,chimica) :- istruisce(Docente,scienze).
istruisce(Docente,tedesco) :- istruisce(Docente,inglese).
istruisce(Docente,portoghese) :- istruisce(Docente,spagnolo).
istruisce(Docente,geometria) :- istruisce(Docente,matematica).

%*
Cosi come per i docenti, anche le relative aule per le attività extra-scolastiche vengono specificate
Con aula_extra(NomeAula) si specifica l'aula che ospitera l'attività extra-scolastica
Per scelta vengono riservete le aule delle materie tradizionali
*%

%* [14] *%	aula_extra(Aula) :- insegnamento_extra(Insegnamento), aula_riservata(Aula,Insegnamento).

%* [11] bis *%
aula_riservata(Aula,chimica) :- aula_riservata(Aula,scienze).
aula_riservata(Aula,tedesco) :- aula_riservata(Aula,inglese).
aula_riservata(Aula,portoghese) :- aula_riservata(Aula,spagnolo).
aula_riservata(Aula,geometria) :- aula_riservata(Aula,matematica).

%*
Aggregati
Li utlizziamo per definire quattro diverse tipologie di vincoli

La prima riguarda la specifica delle ore relative ad ogni materia

Testo cosegna:
<--
per ogni classe, sono previste 10 ore di lettere, 4 di matematica, 2 di scienze, 3 di inglese, 2 di spagnolo,
2 di musica, 2 di tecnologia, 2 di arte, 2 di educazione fisica, 1 di religione.
-->

Con ora_riservata(NomeInsegnamento,Classe,Giorno,Ora) si specifica la relazione tra Insegnamento,Classe,Giorno,Ora senza pero vincoli aggiuntivi,
e con l'aggregato l'esatto numero in base al testo della consegna fornito
Sia per le materie tradizionali che per le attività extra-scolastiche la cui frequenza e scelta in maniera arbitraria
*%

%* [15] Per ogni fatto che matcha con classe giorno e ora libere*%
10 { ora_riservata(lettere,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 10 :- classe(Classe).
4 { ora_riservata(matematica,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 4 :- classe(Classe).
2 { ora_riservata(scienze,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe).
3 { ora_riservata(inglese,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 3 :- classe(Classe).
2 { ora_riservata(spagnolo,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe).
2 { ora_riservata(musica,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe).
2 { ora_riservata(tecnologia,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe).
2 { ora_riservata(arte,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe).
2 { ora_riservata(educazioneFisica,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe).
1 { ora_riservata(religione,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 1 :- classe(Classe).

4 { ora_riservata(chimica,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 4 :- classe(Classe), tempo_prolungato(Classe).
2 { ora_riservata(tedesco,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe), tempo_prolungato(Classe).
2 { ora_riservata(geometria,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe), tempo_prolungato(Classe).
2 { ora_riservata(portoghese,Classe,Giorno,Ora) : giorno(Giorno) , ora(Ora) } 2 :- classe(Classe), tempo_prolungato(Classe).

%*
Il secondo aggregato riguarda un aspetto di ottimizzazione della soluzione

Non viene introdotto nessun nuovo vincolo ma l'aggregato impone la frequanza giornaliera dell'insegnamento
che puo andare da zero a massimo due ore al giorno. Il fatto può comparire 0 1 2 volte per ogni tripla
*%

%* [16] *%	{ ora_riservata(Insegnamento,Classe,Giorno,Ora) : ora(Ora) } 2 :- classe(Classe), insegnamento(Insegnamento), giorno(Giorno).

%*
Anche il terzo aggregato riguarda un aspetto di ottimizzazione della soluzione

Con assegnazione(Docente,Insegnamento,Classe) viene specificato un docente per un insegnamento in una classe
e con l'aggregato si impone l'unicita
Per le materie ordinarie il docente e unico per ogni classe
In questo modo si evita che in una classe le ore di italiano ecc. vengano fatte da insegnanti diversi

L'ottimizzazione viene fatta solo per le materie ordinarie, mentre per le attività extra-scolastiche viene fatta la normale assegnazione
*%

%* [17] *%	1 { assegnazione(Docente,Insegnamento,Classe) : istruisce(Docente,Insegnamento) } 1 :- insegnamento(Insegnamento), not insegnamento_extra(Insegnamento), classe(Classe).

%* [17] bis *%
assegnazione(Docente,chimica,Classe) :- assegnazione(Docente,scienze,Classe), tempo_prolungato(Classe).
assegnazione(Docente,tedesco,Classe) :- assegnazione(Docente,inglese,Classe), tempo_prolungato(Classe).
assegnazione(Docente,portoghese,Classe) :- assegnazione(Docente,spagnolo,Classe), tempo_prolungato(Classe).
assegnazione(Docente,geometria,Classe) :- assegnazione(Docente,matematica,Classe), tempo_prolungato(Classe).

%*
Il quarto aggregato riguarda la specifica dell'aula occupata

Con aula_occupata(Aula,Classe,Giorno,Ora) viene specificata una relazione tra Aula,Classe,Giorno e Ora,
(non vengono specificati l'insegnamento ed il docente)
e con l'aggregato si impone l'unicita

Questo e uno dei primi due vincoli essenziali per la costruzione dell'orario
*%

%* [18] *%	1 { aula_occupata(Aula,Classe,Giorno,Ora) : aula_riservata(Aula,Insegnamento) } 1 :- ora_riservata(Insegnamento,Classe,Giorno,Ora).

%*
Specifica il docente occupato
Con docente_occupato(Docente,Insegnamento,Classe,Giorno,Ora) viene messo in relazione il docente e il relativo insegnamento
con Classe,Giorno e Ora
Viene cosi creato il secondo vincolo essenziale per la costruzione dell'orario
*%

%* [19] *%	docente_occupato(Docente,Insegnamento,Classe,Giorno,Ora) :- ora_riservata(Insegnamento,Classe,Giorno,Ora), assegnazione(Docente,Insegnamento,Classe).

%*
Specifica la lezione compone il calendario scolastico con tutte le informazioni necessarie

Con lezione(Aula,Docente,Insegnamento,Classe,Giorno,Ora) si specifica la relazione tra tutti gli elementi del dominio
utlizzando i vincoli [18] e [19].
*%

%* [20] *%	lezione(Aula,Docente,Insegnamento,Classe,Giorno,Ora) :- docente_occupato(Docente,Insegnamento,Classe,Giorno,Ora), aula_occupata(Aula,Classe,Giorno,Ora).

%*
Integrity constrains

Utilizziamo sei diversi vincoli per la correttezza della soluzione

Il primo riguarda le ore, impone l'obbligatorieta della lezione nelle prime 6 ore
*%

%* [21] *%	:- ora(Ora), giorno(Giorno), classe(Classe), not ora_riservata(_,Classe,Giorno,Ora), Ora <= 6.

%*
Il secondo specifica che le classi non a tempo prolungato frequentano le prime 6 ore
*%

%* [22] *%	:- ora_riservata(_,Classe,_,Ora), Ora > 6, not tempo_prolungato(Classe).

%*
Il terzo specifica che un insegnamento non possa essere svolto contemporaneamente ad un secondo nei medesimi luoghi
*%
%* [23] *%	:- ora_riservata(Insegnamento1,Classe,Giorno,Ora), ora_riservata(Insegnamento2,Classe,Giorno,Ora), Insegnamento1 != Insegnamento2.

%*
Il quarto specifica che un docente non possa insegnare contemporaneamente
*%

%* [24] *%	:- docente_occupato(Docente,_,Classe1,Giorno,Ora), docente_occupato(Docente,_,Classe2,Giorno,Ora), Classe1 != Classe2.

%*
Il quinto specifica che un aula non possa avere piu insegnamenti contemporaneamente
*%

%* [25] *%	:- aula_occupata(Aula,Classe1,Giorno,Ora), aula_occupata(Aula,Classe2,Giorno,Ora), Classe1 != Classe2.

%*
Il sesto specifica che una classe non possa avere piu insegnamenti contemporaneamente
*%

%* [26] *%	:- aula_occupata(Aula1,Classe,Giorno,Ora), aula_occupata(Aula2,Classe,Giorno,Ora), Aula1 != Aula2.

%*
Il settimo specifica la consecutivita delle ore
E possibile che nelle ore non standard non ci sia la ripetizione continua
*%

%* [27] *%	:- ora(Ora1), not ora_riservata(_,Classe,Giorno,Ora1), ora_riservata(_,Classe,Giorno,Ora2), Ora1 < Ora2.

%*
L'ottavo specifica per l'insegnamento di letteratura che non e possbile cambiare aula nell'ora successiva
*%

%* [28] *%	:- lezione(Aula1,Docente,Insegnamento,Classe,Giorno,Ora), lezione(Aula2,Docente,Insegnamento,Classe,Giorno,Ora+1),  Aula1 != Aula2, (Ora \ 2) == 1.

%*
L'ultimo vincolo riguarda un ottimizzazione della soluzione
Specifica il concatenamento di due ore del medesimo insegnemto in successione
*%

%* [29] *%	ora_riservata(Insegnamento,Classe,Giorno,Ora+1) :- ora_riservata(Insegnamento,Classe,Giorno,Ora), (Ora \ 2) == 1, Insegnamento != religione.


% --------- SHOW ---------

#show lezione/6.
