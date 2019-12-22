%

ida():-
	%PosizioneIniziale=(1,1)
	iniziale(PosizioneIniziale),
	calcolaEuristica(PosizioneIniziale,0,Euristica),
	assert(soglia(Euristica)),
	assert(sogliaMinima(100000)),
    ida_aux(Euristica,Soluzione),
    format("Path:  ~w~n", [Soluzione]),
    sogliaMinima(SogliaMinima),
    soglia(Soglia),
    retract(sogliaMinima(SogliaMinima)),
    retract(soglia(Soglia)).

% ida_aux(Soglia,Soluzione)

ida_aux(Soglia,Soluzione) :-
    format("Profondita:  ~w~n", Soglia),
    ( dfs(Soluzione,Soglia) ->
    true
    ; aggiornaSoglia(Soglia,NuovaSoglia),
    ida_aux(NuovaSoglia,Soluzione)).

% dfs(Soluzione,Soglia)

dfs(Soluzione,Soglia):-
    iniziale(PosizioneIniziale),
    dfs_aux(PosizioneIniziale,Soluzione,[PosizioneIniziale],Soglia).

% dfs_aux(PosizioneIniziale,Soluzione,Azioni,Soglia)
%%CASO BASE
dfs_aux(PosizioneCorrente,[],_,_):-finale(PosizioneCorrente).

%%CASO GENERALE:
dfs_aux(PosizioneCorrente,[Azione|AltreAzioni],MosseEseguite,Soglia):-
	calcolaEuristicaNodo(PosizioneCorrente,MosseEseguite),
    Soglia>0,
    applicabile(Azione,PosizioneCorrente),
    trasforma(Azione,PosizioneCorrente,NuovoStato),
    \+member(NuovoStato,MosseEseguite),
    NuovaSoglia is Soglia-1,
    dfs_aux(NuovoStato,AltreAzioni,[NuovoStato|MosseEseguite],NuovaSoglia).

% calcolaEuristicaNodo(PosizioneCorrente,MosseEseguite)

calcolaEuristicaNodo(PosizioneCorrente,MosseEseguite):-
	%%C = MosseEseguite
	length(MosseEseguite, C),
    CostoEffettuato is C-1,
	calcolaEuristica(PosizioneCorrente,CostoEffettuato,Euristica),
	soglia(SogliaCorrente),
	% SE SFORANTE
	( Euristica > SogliaCorrente ->
	%Fallisce dfs_aux
	aggiornaSogliaMinima(Euristica), false
	; true
	).

% aggiornaSoglia(Soglia,NuovaSoglia)
%%aggiorna soglia con il minimo sforante e pone la soglia minima a infinito
aggiornaSoglia(Soglia,NuovaSoglia):-
	sogliaMinima(NuovaSoglia),
	%Se arriva alla soglia termina
	( Soglia is 100000 ->
	false
	; retract(sogliaMinima(NuovaSoglia)),
    assert(sogliaMinima(100000)),
    retract(soglia(Soglia)),
    assert(soglia(NuovaSoglia))
	).

% aggiornaSogliaMinima(Euristica)
%%NODO SFORANTE
aggiornaSogliaMinima(Euristica):-
	%inf
	sogliaMinima(Distanza),
	%min tra gli sforanti
	( Euristica < Distanza ->
	retract(sogliaMinima(Distanza)), assert(sogliaMinima(Euristica))
	; true
	).

% calcolaEuristica(PosizioneCorrente,CostoEffettuato,Euristica)

calcolaEuristica(pos(Riga,Colonna),CostoEffettuato,Euristica):-
	finale(pos(RigaFinale,ColonnaFinale)),
	calcolaDistanzaEuristica(Riga,Colonna,RigaFinale,ColonnaFinale,Distanza),
	Euristica is CostoEffettuato + Distanza.

% Euristica della distanza di Manhattan tra posizioni date

calcolaDistanzaEuristica(Riga,Colonna,RigaFinale,ColonnaFinale,Distanza):-
	differenza(Riga,RigaFinale,DifferenzaRiga),
	differenza(Colonna,ColonnaFinale,DifferenzaColonna),
	Distanza is DifferenzaRiga + DifferenzaColonna.

% Calcola il valore assoluto della differenza di 2 numeri

differenza(A,B,Differenza):- Differenza is A - B, Differenza >= 0,!.
differenza(A,B,Differenza):- Differenza is B - A, Differenza > 0,!.

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
