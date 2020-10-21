parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,katappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).

male(katappa).
male(jolly).
male(bahubali).

female(shivkami).
female(avantika).

halfsister(X, Y) :-
    parent(A, X),
    parent(B, X),
    (A \= B),
    parent(M, Y),
    parent(N, Y),
    (M \= N),
    (A = M),
    (B \= N).