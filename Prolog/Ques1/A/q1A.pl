% given predicates 
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

% returns true if X is uncle of Y
uncle(X, Y) :-  
    male(X),                        % checks if X is male
    parent(PX, X),
    parent(PY, Y),
    (PY \= X),
    parent(GPY, PY),
    (GPY = PX).                     % checks if parent of X matches grandparent of Y
