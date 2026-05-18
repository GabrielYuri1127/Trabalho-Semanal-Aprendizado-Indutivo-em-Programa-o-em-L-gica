% ============================================================
% EXERCICIO 21.2 - predecessor
% Ivan Bratko - Prolog Programming for Artificial Intelligence
% Compatível com SWISH
% Execute com:
% ?- run.
% ============================================================

:- discontiguous parent/2.
:- discontiguous ex/1.
:- discontiguous nex/1.
:- discontiguous start_hyp/1.
:- discontiguous backliteral/2.
:- discontiguous run/0.

% -------------------- MINI-HYPER CORE -----------------------

prove(Goal, Hypo, Answer):-
    max_proof_length(D),
    prove(Goal, Hypo, D, RestD),
    ( RestD >= 0, Answer = yes
    ; RestD < 0, Answer = maybe
    ).
prove(_, _, no).

prove(_, _, D, D):-
    D < 0, !.

prove([], _, D, D):- !.

prove([G1|Gs], Hypo, D0, D):-
    prove(G1, Hypo, D0, D1),
    prove(Gs, Hypo, D1, D).

% Predicados de fundo
prove(parent(X,Y), _, D, D):-
    parent(X,Y).

prove(atom(X), _, D, D):-
    atom(X).

prove(G, Hypo, D0, D):-
    D0 =< 0, !,
    D is D0 - 1
    ;
    D1 is D0 - 1,
    member(Clause/_, Hypo),
    copy_term(Clause, [Head|Body]),
    G = Head,
    prove(Body, Hypo, D1, D).

% -------------------- INDUÇÃO -------------------------------

induce(Hyp):-
    iter_deep(Hyp, 0).

iter_deep(Hyp, MaxD):-
    write('MaxD= '), write(MaxD), nl,
    start_hyp(Hyp0),
    complete(Hyp0),
    depth_first(Hyp0, Hyp, MaxD)
    ;
    NewMaxD is MaxD + 1,
    iter_deep(Hyp, NewMaxD).

depth_first(Hyp, Hyp, _):-
    consistent(Hyp).

depth_first(Hyp0, Hyp, MaxD0):-
    MaxD0 > 0,
    MaxD1 is MaxD0 - 1,
    refine_hyp(Hyp0, Hyp1),
    complete(Hyp1),
    depth_first(Hyp1, Hyp, MaxD1).

complete(Hyp):-
    not3(
        ex(E),
        once(prove(E, Hyp, Answer)),
        Answer \== yes
    ).

consistent(Hyp):-
    not3(
        nex(E),
        once(prove(E, Hyp, Answer)),
        Answer \== no
    ).

% -------------------- REFINAMENTO ---------------------------

refine_hyp(Hyp0, Hyp):-
    conc(Clauses1, [Clause0/Vars0 | Clauses2], Hyp0),
    conc(Clauses1, [Clause/Vars | Clauses2], Hyp),
    refine(Clause0, Vars0, Clause, Vars).

refine(Clause, Args, Clause, NewArgs):-
    conc(Args1, [A | Args2], Args),
    member(A, Args2),
    conc(Args1, Args2, NewArgs).

refine(Clause, Args, NewClause, NewArgs):-
    length(Clause, L),
    max_clause_length(MaxL),
    L < MaxL,
    backliteral(Lit, Vars),
    conc(Clause, [Lit], NewClause),
    conc(Args, Vars, NewArgs).

% -------------------- LIMITES -------------------------------

max_proof_length(10).
max_clause_length(3).

% -------------------- AUXILIARES ----------------------------

conc([], L, L).
conc([X|T], L, [X|L1]):-
    conc(T, L, L1).

not3(A, B, C):-
    A,
    B,
    C, !, fail.
not3(_, _, _).

% -------------------- FATOS DA FAMÍLIA ----------------------

parent(pam, bob).
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

% -------------------- EXEMPLOS DE TREINAMENTO ---------------

% Exemplos positivos
ex(predecessor(pam, bob)).
ex(predecessor(pam, jim)).
ex(predecessor(tom, ann)).
ex(predecessor(tom, jim)).
ex(predecessor(tom, liz)).

% Exemplos negativos
nex(predecessor(liz, bob)).
nex(predecessor(pat, bob)).
nex(predecessor(pam, liz)).
nex(predecessor(liz, jim)).
nex(predecessor(liz, liz)).

% -------------------- HIPÓTESE INICIAL ----------------------

start_hyp([
    [predecessor(X1,Y1)] / [X1,Y1],
    [predecessor(X2,Y2)] / [X2,Y2]
]).

% -------------------- LITERAIS DE FUNDO ---------------------

backliteral([atom(X), parent(X,Y)], [X,Y]).
backliteral([atom(X), predecessor(X,Y)], [X,Y]).

% -------------------- EXECUÇÃO ------------------------------

run :-
    induce(H),
    nl,
    write('Hipotese encontrada:'), nl,
    write(H), nl, nl,

    prove(predecessor(pam,bob), H, R1),
    write('predecessor(pam,bob) = '), write(R1), nl,

    prove(predecessor(pam,jim), H, R2),
    write('predecessor(pam,jim) = '), write(R2), nl,

    prove(predecessor(tom,ann), H, R3),
    write('predecessor(tom,ann) = '), write(R3), nl,

    prove(predecessor(tom,jim), H, R4),
    write('predecessor(tom,jim) = '), write(R4), nl,

    prove(predecessor(liz,bob), H, R5),
    write('predecessor(liz,bob) = '), write(R5), nl,

    prove(predecessor(pam,liz), H, R6),
    write('predecessor(pam,liz) = '), write(R6), nl.
