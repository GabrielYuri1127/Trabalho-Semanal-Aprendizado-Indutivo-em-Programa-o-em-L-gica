% ============================================================
% EXERCICIO 21.1 - has_daughter
% Ivan Bratko - Prolog Programming 
% Execute com:
% ?- run.
% ============================================================

:- discontiguous parent/2.
:- discontiguous female/1.
:- discontiguous male/1.
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

prove(female(X), _, D, D):-
    female(X).

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

female(pam).
female(liz).
female(ann).
female(pat).

male(tom).
male(bob).
male(jim).

% -------------------- EXEMPLOS DE TREINAMENTO ---------------

% Exemplos positivos
ex(has_daughter(tom)).
ex(has_daughter(bob)).

% Exemplos negativos
nex(has_daughter(pam)).
nex(has_daughter(pat)).
nex(has_daughter(jim)).

% -------------------- HIPÓTESE INICIAL ----------------------

start_hyp([
    [has_daughter(X)] / [X]
]).

% -------------------- LITERAIS DE FUNDO ---------------------

backliteral(parent(X,Y), [X,Y]).
backliteral(female(X), [X]).

% -------------------- EXECUÇÃO ------------------------------

run :-
    induce(H),
    nl,
    write('Hipotese encontrada:'), nl,
    write(H), nl, nl,

    prove(has_daughter(tom), H, R1),
    write('has_daughter(tom) = '), write(R1), nl,

    prove(has_daughter(bob), H, R2),
    write('has_daughter(bob) = '), write(R2), nl,

    prove(has_daughter(pam), H, R3),
    write('has_daughter(pam) = '), write(R3), nl,

    prove(has_daughter(pat), H, R4),
    write('has_daughter(pat) = '), write(R4), nl,

    prove(has_daughter(jim), H, R5),
    write('has_daughter(jim) = '), write(R5), nl.
