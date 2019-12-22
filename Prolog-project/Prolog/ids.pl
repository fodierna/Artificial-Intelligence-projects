%

% per gestire i casi in cui la soglia non è inf
ids(SogliaInfinita):-
    ids_aux(1,SogliaInfinita, Soluzione),
    nonvar(Soluzione),
    format("Path:  ~w~n", [Soluzione]).

% ids_aux(ProfonditaCorrente,SogliaInfinita,Soluzione)

%CASO BASE: Soglia raggiuta -> SogliaInfinita = SogliaInfinita
ids_aux(SogliaInfinita,SogliaInfinita,_):-!.

%CASO GENERALE:
%%Profondita = profondità
%%Soglia SogliaInfinita
%%Soluzione
ids_aux(Profondita,SogliaInfinita,Soluzione) :-
    format("Profondita:  ~w~n", Profondita),
    cercaSoluzione(Profondita,SogliaInfinita,NuovaProfondita,Soluzione),
    NuovaProfondita<SogliaInfinita
    %Fa in modo che se ha successo la profondità diventi = SogliaInfinita
    ProssimaProfondita is NuovaProfondita+1,
    %Se ha successo chiama il caso base, altrimenti il caso generale
    ids_aux(ProssimaProfondita,SogliaInfinita,Soluzione).

% cercaSoluzione(Profondita,SogliaInfinita,NuovaProfondita,Soluzione)
%Profondità = 1,...,SogliaInfinita
cercaSoluzione(Profondita,SogliaInfinita,NuovaProfondita,Soluzione):-

	dfs(Soluzione,Profondita)
  %T -> Trova la soluzione
	-> NuovaProfondita is SogliaInfinita-1
  %F -> incrementa profondità
	; NuovaProfondita is Profondita.

% dfs_aux(S,ListaAzioni,Visitati,Soglia)

dfs(Soluzione,Soglia):-
    iniziale(PosizioneIniziale),
    dfs_aux(PosizioneIniziale,Soluzione,[PosizioneIniziale],Soglia).

% dfs_aux(PosizioneIniziale,Soluzione,Azioni,Soglia)

%CASO BASE: PosizioneCorrente = finale(PosizioneCorrente)
dfs_aux(PosizioneCorrente,[],_,_):-finale(PosizioneCorrente).

%CASO GENERALE:
%%Soluzione = Insieme azioni -> est, ovest, sud, sud
%%MosseEseguite = memorizza azioni per non ripeterle
dfs_aux(PosizioneCorrente,[Azione|AltreAzioni],MosseEseguite,Soglia):-
    %se non siamo giunti al limite di profondità
    Soglia>0,
    %se applicabile
    applicabile(Azione,PosizioneCorrente),
    %aggiorna lo stato corrente
    trasforma(Azione,PosizioneCorrente,NuovoStato),
    %per evitare di ritornare in stati già visitati
    \+member(NuovoStato,MosseEseguite),
    %decremento soglia -> incremento profondità
    NuovaSoglia is Soglia-1,
    dfs_aux(NuovoStato,AltreAzioni,[NuovoStato|MosseEseguite],NuovaSoglia).

% applicabile(azione,stato) --> ordine di lettura est-sud-ovest-nord per questioni di efficienza
%%backtracking fatto su applicabile
applicabile(est,pos(Riga,Colonna)):-
    num_colonne(NC),
    %se non sforo bordo dx
    Colonna<NC,
    %mi sposto a dx
    ColonnaAccanto is Colonna+1,
    %se non è occupata
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
    \+occupata(pos(RigaAccanto,Colonna)),!. %cut perché non ci sono altre mosse

% trasforma(azione,statoCorrente,statoNuovo)
%%aggiorna lo stato
trasforma(est,pos(Riga,Colonna),pos(Riga,C)):-C is Colonna+1,!.
trasforma(sud,pos(Riga,Colonna),pos(R,Colonna)):-R is Riga+1,!.
trasforma(ovest,pos(Riga,Colonna),pos(Riga,C)):-C is Colonna-1,!.
trasforma(nord,pos(Riga,Colonna),pos(R,Colonna)):-R is Riga-1,!.
