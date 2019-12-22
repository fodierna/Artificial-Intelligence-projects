%

aStar():-
    iniziale(PosizioneIniziale),
    aStar_aux([nodo(_,_,PosizioneIniziale,[])],[],Soluzione,CostoRicerca),
    length(Soluzione, Profondita),
    FattoreRamificazione is CostoRicerca/Profondita,
    approssima(FattoreRamificazione,2,FattoreRamificazioneApprossimato),
    format("Costo di Ricerca: ~w~nFattore di Ramificazione Effettivo: ~w~nProfondita: ~w~nPath: ~w", 
    [CostoRicerca,FattoreRamificazioneApprossimato,Profondita,Soluzione]).

% aStar_aux(MossePossibili,PosizioniVisitate,Soluzione,CostoRicerca)

aStar_aux([nodo(_,_,Stato,Azioni)|MosseRimanenti],MosseEseguite,Soluzione,CostoRicerca):-finale(Stato),invertiLista(Azioni, Soluzione),conta(MosseRimanenti,MosseEseguite,CostoRicerca),!.
aStar_aux([nodo(_,_,Stato,Azioni)|MosseRimanenti],MosseEseguite,Soluzione,CostoRicerca):-
    findall(Azione,applicabile(Azione,Stato),ListaAzioniApplicabili),
    length(Azioni, CostoEffettuato),
    generaMosse(nodo(CostoEffettuato,[],Stato,Azioni),ListaAzioniApplicabili,[Stato|MosseEseguite],ListaNuoveMosse),
    finale(pos(RigaFinale,ColonnaFinale)),
    ordinaMosse(ListaNuoveMosse,RigaFinale,ColonnaFinale,MosseRimanenti,ListaEuristicaOrdinata),
    aStar_aux(ListaEuristicaOrdinata,[Stato|MosseEseguite],Soluzione,CostoRicerca).

% generaMosse(Posizione&AzioniFinOra,AzioniPossibili,MosseEseguite,ListaPossibiliMosse)

generaMosse(_,[],_,[]):-!.
generaMosse(nodo(CostoEffettuato,[],Stato,AzioniFinOra),[Azione|AltreAzioni],MosseEseguite,[nodo(NuovoCosto,[],NuovoStato,[Azione|AzioniFinOra])|ListaMosse]):-
    trasforma(Azione,Stato,NuovoStato),
    NuovoCosto is CostoEffettuato + 1,
    \+member(NuovoStato,MosseEseguite),!,
    generaMosse(nodo(CostoEffettuato,[],Stato,AzioniFinOra),AltreAzioni,MosseEseguite,ListaMosse).
generaMosse(nodo(CostoEffettuato,[],Stato,AzioniPerStato),[_|AltreAzioni],MosseEseguite,ListaMosse):-
    generaMosse(nodo(CostoEffettuato,[],Stato,AzioniPerStato),AltreAzioni,MosseEseguite,ListaMosse).

% ordinaMosse(ListaNuoveMosse,PosizioneFinale,MosseRimanenti,MosseConMossaMiglioreInCima)

ordinaMosse(ListaNuoveMosse,RigaFinale,ColonnaFinale,MosseRimanenti,[MossaMigliore|AltreMosse]):-
	applicaEuristica(ListaNuoveMosse,RigaFinale,ColonnaFinale,ListaMosseEuristica),
	append(MosseRimanenti,ListaMosseEuristica,ListaEuristica),
	cercaMossaMigliore(ListaEuristica,MossaMigliore),
	delete(ListaEuristica, MossaMigliore, AltreMosse).

% riordinaEuristica(ListaPossibiliMosse,RigaFinale,ColonnaFinale,ListaPossibiliMosseConEuristica)

applicaEuristica([],_,_,[]):-!.
applicaEuristica([nodo(CostoEffettuato,_,pos(Riga,Colonna),AzioniFinOra)|MosseRestanti],RigaFinale,ColonnaFinale,[nodo(Euristica,CostoFuturo,pos(Riga,Colonna),AzioniFinOra)|ListaMosseEuristica]):-
	calcolaEuristica(Riga,Colonna,RigaFinale,ColonnaFinale,CostoFuturo),
	Euristica is CostoFuturo + CostoEffettuato,
	applicaEuristica(MosseRestanti,RigaFinale,ColonnaFinale,ListaMosseEuristica).

% Euristica della distanza Diagonale tra posizioni date

calcolaEuristica(Riga,Colonna,RigaFinale,ColonnaFinale,Distanza):-
	differenza(Riga,RigaFinale,DifferenzaRiga),
	differenza(Colonna,ColonnaFinale,DifferenzaColonna),
	Distanza is max(DifferenzaRiga,DifferenzaColonna).

% Calcola il valore assoluto della differenza di 2 numeri

differenza(A,B,Differenza):- Differenza is A - B, Differenza >= 0.
differenza(A,B,Differenza):- Differenza is B - A, Differenza > 0.

% cercaMossaMigliore(ListaMosseConEuristica,MossaMigliore)

cercaMossaMigliore([MossaMigliore],MossaMigliore):-!.

cercaMossaMigliore([nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni),nodo(Euristica,_,_,_)|AltreMosse],MossaMigliore) :-
    EuristicaMigliore < Euristica,
    cercaMossaMigliore([nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni)|AltreMosse],MossaMigliore),!.

cercaMossaMigliore([nodo(Euristica,CostoFuturoMigliore,Stato,Azioni),nodo(Euristica2,CostoFuturo,_,_)|AltreMosse],MossaMigliore) :-
    Euristica =< Euristica2,
    CostoFuturoMigliore < CostoFuturo,
    cercaMossaMigliore([nodo(Euristica,CostoFuturoMigliore,Stato,Azioni)|AltreMosse],MossaMigliore),!.

cercaMossaMigliore([nodo(Euristica,_,_,_),nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni)|AltreMosse],MossaMigliore) :-
    EuristicaMigliore < Euristica,
    cercaMossaMigliore([nodo(EuristicaMigliore,CostoFuturo,Stato,Azioni)|AltreMosse],MossaMigliore),!.
    
cercaMossaMigliore([nodo(Euristica2,CostoFuturo,_,_),nodo(Euristica,CostoFuturoMigliore,Stato,Azioni)|AltreMosse],MossaMigliore) :-
    Euristica =< Euristica2,
    CostoFuturoMigliore < CostoFuturo,
    cercaMossaMigliore([nodo(Euristica,CostoFuturoMigliore,Stato,Azioni)|AltreMosse],MossaMigliore),!.

cercaMossaMigliore([Mossa1,_|AltreMosse],MossaMigliore) :-
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
	
applicabile(sudEst,pos(Riga,Colonna)):-
	num_colonne(NC),
    Colonna<NC,
    num_righe(NR),
    Riga<NR,
    ColonnaAccanto is Colonna+1,
    RigaAccanto is Riga+1,
    \+occupata(pos(RigaAccanto,ColonnaAccanto)).

applicabile(sud,pos(Riga,Colonna)):-
    num_righe(NR),
    Riga<NR,
    RigaAccanto is Riga+1,
    \+occupata(pos(RigaAccanto,Colonna)).

applicabile(est,pos(Riga,Colonna)):-
    num_colonne(NC),
    Colonna<NC,
    ColonnaAccanto is Colonna+1,
    \+occupata(pos(Riga,ColonnaAccanto)).

applicabile(sudOvest,pos(Riga,Colonna)):-
	Colonna>1,
    num_righe(NR),
    Riga<NR,
    ColonnaAccanto is Colonna-1,
    RigaAccanto is Riga+1,
    \+occupata(pos(RigaAccanto,ColonnaAccanto)).

applicabile(nordEst,pos(Riga,Colonna)):-
	num_colonne(NC),
    Colonna<NC,
    Riga>1,
    ColonnaAccanto is Colonna+1,
    RigaAccanto is Riga-1,
    \+occupata(pos(RigaAccanto,ColonnaAccanto)).

applicabile(nordOvest,pos(Riga,Colonna)):-
	Colonna>1,
    Riga>1,
    ColonnaAccanto is Colonna-1,
    RigaAccanto is Riga-1,
    \+occupata(pos(RigaAccanto,ColonnaAccanto)).

applicabile(ovest,pos(Riga,Colonna)):-
    Colonna>1,
    ColonnaAccanto is Colonna-1,
    \+occupata(pos(Riga,ColonnaAccanto)).

applicabile(nord,pos(Riga,Colonna)):-
    Riga>1,
    RigaAccanto is Riga-1,
    \+occupata(pos(RigaAccanto,Colonna)),!.

% trasforma(azione,statoCorrente,statoNuovo)

trasforma(sudEst,pos(Riga,Colonna),pos(R,C)):-C is Colonna+1, R is Riga+1,!.
trasforma(sud,pos(Riga,Colonna),pos(R,Colonna)):-R is Riga+1,!.
trasforma(est,pos(Riga,Colonna),pos(Riga,C)):-C is Colonna+1,!.
trasforma(sudOvest,pos(Riga,Colonna),pos(R,C)):-C is Colonna-1, R is Riga+1,!.
trasforma(nordEst,pos(Riga,Colonna),pos(R,C)):-C is Colonna+1, R is Riga-1,!.
trasforma(nordOvest,pos(Riga,Colonna),pos(R,C)):-C is Colonna-1, R is Riga-1,!.
trasforma(ovest,pos(Riga,Colonna),pos(Riga,C)):-C is Colonna-1,!.
trasforma(nord,pos(Riga,Colonna),pos(R,Colonna)):-R is Riga-1,!.