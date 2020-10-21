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

uncle(X, Y) :-  
    male(X), 
    parent(PX, X),
    parent(PY, Y),
    male(PY),
    parent(GPY, PY),
    (GPY = PX). 
