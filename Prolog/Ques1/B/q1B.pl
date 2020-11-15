% given predicate
% parent(X, Y) means X is a parent of Y
parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,katappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).

% male(X) returns true if X is male
male(katappa).
male(jolly).
male(bahubali).

% female(X) returns true if X is female
female(shivkami).
female(avantika).

% returns true if X and Y are half sisters
halfsister(X, Y) :-
    female(X),
    parent(A, X),
    parent(B, X),
    (A \= B),                           % get two different parents for X
    parent(M, Y),
    parent(N, Y),
    (M \= N),                           % get two different parents for Y
    (A = M),                            % only one parent should match between X and Y
    (B \= N).                           % other parent should not match