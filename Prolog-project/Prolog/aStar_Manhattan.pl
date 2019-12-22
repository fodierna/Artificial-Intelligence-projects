%
%nodo = da tenere in memoria così da memorizzare l'albero
aStar():-
    iniziale(PosizioneIniziale),
    aStar_aux([nodo(_,_,PosizioneIniziale,[])],[],Soluzione,CostoRicerca),
    length(Soluzione, Profondita),
    FattoreRamificazione is CostoRicerca/Profondita,
    approssima(FattoreRamificazione,2,FattoreRamificazioneApprossimato),
    format("Costo di Ricerca: ~w~nFattore di Ramificazione Effettivo: ~w~nProfondita: ~w~nPath: ~w",
    [CostoRicerca,FattoreRamificazioneApprossimato,Profondita,Soluzione]).

% aStar_aux(MossePossibili,PosizioniVisitate,Soluzione,CostoRicerca)
%% CASO BASE: posizione nodo coincide con posizione finale
%% Azioni inverse perché ultima mossa in testa
aStar_aux([nodo(_,_,Stato,Azioni)|MosseRimanenti],MosseEseguite,Soluzione,CostoRicerca):-finale(Stato),invertiLista(Azioni, Soluzione),conta(MosseRimanenti,MosseEseguite,CostoRicerca),!.

%%CASO GENERALE
%Nodo(Stato e Azioni fino a quel nood)
%Quando una mossa (nodo, posizione labirinto) viene fatto passa dalle Mosse MosseRimanenti alle Mosse
aStar_aux([nodo(_,_,Stato,Azioni)|MosseRimanenti],MosseEseguite,Soluzione,CostoRicerca):-
    %Azione e applicabile. Tutto ciò che matcha è inserito nella lista delle azioni applicabili
    %% Azione = Template azione
    %% Cerca tutte le azioni che sono applicabili in stato
    findall(Azione,applicabile(Azione,Stato),ListaAzioniApplicabili),

    %% #azioni fino allo stato = costo
    length(Azioni, CostoEffettuato),
    %% genera i nodi
      %% a partire dal nodo considera le mosse ListaAzioniApplicabili
      %% le mosse eseguite + il nodo corrente -> mosse già effettuate
      %%
    generaMosse(nodo(CostoEffettuato,[],Stato,Azioni),ListaAzioniApplicabili,[Stato|MosseEseguite],ListaNuoveMosse),
    finale(pos(RigaFinale,ColonnaFinale)),
    ordinaMosse(ListaNuoveMosse,RigaFinale,ColonnaFinale,MosseRimanenti,ListaEuristicaOrdinata),
    aStar_aux(ListaEuristicaOrdinata,[Stato|MosseEseguite],Soluzione,CostoRicerca).

% generaMosse(Posizione&AzioniFinOra,AzioniPossibili,MosseEseguite,ListaPossibiliMosse)
%% CASO BASE: no azioni MossePossibili e non si genera niente
generaMosse(_,[],_,[]):-!.

%% CASO GENERALE: prende l'azione applicabile nello stato
 %% NUOVO COSTO = costo attuale incrementato di 1
 %% Nuovo stato = stato aggiornato
 %%AzioniFinOra = aggiunge l'azione effettuata alle azioni fatte per raggiungere i nodi
 %%E aggiunge le mosse alla lista mosse
generaMosse(nodo(CostoEffettuato,[],Stato,AzioniFinOra),[Azione|AltreAzioni],MosseEseguite,[nodo(NuovoCosto,[],NuovoStato,[Azione|AzioniFinOra])|ListaMosse]):-
    %e transisce nel nuovo stato
    trasforma(Azione,Stato,NuovoStato),
    %aumenta il CostoEffettuato di 1 -> costo fino al nodo n + costo nodo successivo
    NuovoCosto is CostoEffettuato + 1,
    %se il nuovo stato non è nelle mosse eseguite
    \+member(NuovoStato,MosseEseguite),!,
    %T
    %% Nessuna posizione visitata
    generaMosse(nodo(CostoEffettuato,[],Stato,AzioniFinOra),AltreAzioni,MosseEseguite,ListaMosse).
    %F
generaMosse(nodo(CostoEffettuato,[],Stato,AzioniPerStato),[_|AltreAzioni],MosseEseguite,ListaMosse):-
    generaMosse(nodo(CostoEffettuato,[],Stato,AzioniPerStato),AltreAzioni,MosseEseguite,ListaMosse).

% ordinaMosse(ListaNuoveMosse,PosizioneFinale,MosseRimanenti,MosseConMossaMiglioreInCima)
%%Mosse MosseRimanenti = nodi per cui si ha l'euristica ma non espansi
ordinaMosse(ListaNuoveMosse,RigaFinale,ColonnaFinale,MosseRimanenti,[MossaMigliore|AltreMosse]):-
	applicaEuristica(ListaNuoveMosse,RigaFinale,ColonnaFinale,ListaMosseEuristica),
	append(MosseRimanenti,ListaMosseEuristica,ListaEuristica),
  %cerca la mossa migliore tra quelle disponibili nel nodo espanso e i nodi non espansi con euristica
	cercaMossaMigliore(ListaEuristica,MossaMigliore),
  % sei toglie la lista migliore da ListaEustistica e consideriamo le altre mosse
  %%61 mette la migliore mossa in testa.
	delete(ListaEuristica, MossaMigliore, AltreMosse).

% riordinaEuristica(ListaPossibiliMosse,RigaFinale,ColonnaFinale,ListaPossibiliMosseConEuristica)
%%CASO BASE: no nodi a cui applicare l'eurstica

%% CASO BASE: no nodi a cui applicare l'euristica
applicaEuristica([],_,_,[]):-!.

%% CASO GENERALE: nodo per cui calcolare l'euristica sulla base della posizione finale e mosse cui lo calcoleremo in ricorsione
 %%nuovo nodo -> costo euristica, costo futuro, stessa posizone
applicaEuristica([nodo(CostoEffettuato,_,pos(Riga,Colonna),AzioniFinOra)|MosseRestanti],RigaFinale,ColonnaFinale,[nodo(Euristica,CostoFuturo,pos(Riga,Colonna),AzioniFinOra)|ListaMosseEuristica]):-
  % calcola euristica -> parametri nodo
  calcolaEuristica(Riga,Colonna,RigaFinale,ColonnaFinale,CostoFuturo),
  %% Costo effettuato = g
  %% Costo futuro = h
	Euristica is CostoFuturo + CostoEffettuato,
  %% calcolo l'euristica per i nodi restanti
	applicaEuristica(MosseRestanti,RigaFinale,ColonnaFinale,ListaMosseEuristica).

% Euristica della distanza di Manhattan tra posizioni date

calcolaEuristica(Riga,Colonna,RigaFinale,ColonnaFinale,Distanza):-
	differenza(Riga,RigaFinale,DifferenzaRiga),
	differenza(Colonna,ColonnaFinale,DifferenzaColonna),
	Distanza is DifferenzaRiga + DifferenzaColonna.

% Calcola il valore assoluto della differenza di 2 numeri

differenza(A,B,Differenza):- Differenza is A - B, Differenza >= 0,!.
differenza(A,B,Differenza):- Differenza is B - A, Differenza > 0,!.

% cercaMossaMigliore(ListaMosseConEuristica,MossaMigliore)

%% CASO BASE = resta solo una mossa che è la mossa migliore perché unica
cercaMossaMigliore([MossaMigliore],MossaMigliore):-!.

%% CASO GENERALE1 = F1 < F2
%% primi due nodi
cercaMossaMigliore([nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni),nodo(Euristica,_,_,_)|AltreMosse],MossaMigliore) :-
    EuristicaMigliore < Euristica,
    %%% cerca migliore con nodo e altre mosse
    cercaMossaMigliore([nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni)|AltreMosse],MossaMigliore),!.
%% Caso 2 F1 = F2 -> G1 < G2
cercaMossaMigliore([nodo(Euristica,CostoFuturoMigliore,Stato,Azioni),nodo(Euristica2,CostoFuturo,_,_)|AltreMosse],MossaMigliore) :-
    Euristica =< Euristica2,
    CostoFuturoMigliore < CostoFuturo,
    cercaMossaMigliore([nodo(Euristica,CostoFuturoMigliore,Stato,Azioni)|AltreMosse],MossaMigliore),!.

%%Caso 3 F2<F1
cercaMossaMigliore([nodo(Euristica,_,_,_),nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni)|AltreMosse],MossaMigliore) :-
    EuristicaMigliore < Euristica,
    cercaMossaMigliore([nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni)|AltreMosse],MossaMigliore),!.

%%Caso 4 F1 = F2 G2 < G1
cercaMossaMigliore([nodo(Euristica2,CostoFuturo,_,_),nodo(Euristica,CostoFuturoMigliore,Stato,Azioni)|AltreMosse],MossaMigliore) :-
    Euristica =< Euristica2,
    CostoFuturoMigliore < CostoFuturo,
    cercaMossaMigliore([nodo(Euristica,CostoFuturoMigliore,Stato,Azioni)|AltreMosse],MossaMigliore),!.

%Caso 5 F1 = F2 e G1 = G2
cercaMossaMigliore([Mossa1,_|AltreMosse],MossaMigliore) :-
    % la prima perché indifferente
    cercaMossaMigliore([Mossa1|AltreMosse],MossaMigliore),!.

% Conta numero elementi di 2 liste

conta(Lista1,Lista2,Numero):-
	count(L1, Lista1),
	count(L2, Lista2),
	Numero is L1 + L2.

count(0, []):-!.
count(Count, [_|Tail]):- count(TailCount, Tail), Count is TailCount + 1.

% Approssimazione decimale per i numeri positivi

approssima(Numero,Decimali,Risultato):- Numero >= 0, Risultato is floor(10^Decimali*Numero)/10^Decimali, !.

% Approssimazione decimale per i numeri negativi

approssima(Numero,Decimali,Risultato):- Numero <0, Risultato is ceil(10^Decimali*Numero)/10^Decimali, !.

% Inversione di una lista

invertiAux([],Temp,Temp):-!.
invertiAux([Head|Tail],Temp,ListaInvertita):-invertiAux(Tail,[Head|Temp],ListaInvertita).
invertiLista(Lista,ListaInvertita):-invertiAux(Lista,[],ListaInvertita).

% applicabile(azione,stato)

applicabile(est,pos(Riga,Colonna)):-
    num_colonne(NC),
    Colonna<NC,
    ColonnaAccanto is Colonna+1,
    \+occupata(pos(Riga,ColonnaAccanto)).

applicabile(sud,pos(Riga,Colonna)):-
    num_righe(NR),
    Riga<NR,
    RigaAccanto is Riga+1,
    \+occupata(pos(RigaAccanto,Colonna)).

applicabile(ovest,pos(Riga,Colonna)):-
    Colonna>1,
    ColonnaAccanto is Colonna-1,
    \+occupata(pos(Riga,ColonnaAccanto)).

applicabile(nord,pos(Riga,Colonna)):-
    Riga>1,
    RigaAccanto is Riga-1,
    \+occupata(pos(RigaAccanto,Colonna)),!.

% trasforma(azione,statoCorrente,statoNuovo)

trasforma(est,pos(Riga,Colonna),pos(Riga,C)):-C is Colonna+1,!.
trasforma(sud,pos(Riga,Colonna),pos(R,Colonna)):-R is Riga+1,!.
trasforma(ovest,pos(Riga,Colonna),pos(Riga,C)):-C is Colonna-1,!.
trasforma(nord,pos(Riga,Colonna),pos(R,Colonna)):-R is Riga-1,!.
