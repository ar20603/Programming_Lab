distance_gates('G1','G5',4).
distance_gates('G2','G5',6).
distance_gates('G3','G5',8).
distance_gates('G4','G5',9).
distance_gates('G1','G6',10).
distance_gates('G2','G6',9).
distance_gates('G3','G6',3).
distance_gates('G4','G6',5).
distance_gates('G5','G7',3).
distance_gates('G5','G10',4).
distance_gates('G5','G11',6).
distance_gates('G5','G12',7).
distance_gates('G5','G6',7).
distance_gates('G5','G8',9).
distance_gates('G6','G8',2).
distance_gates('G6','G12',3).
distance_gates('G6','G11',5).
distance_gates('G6','G10',9).
distance_gates('G6','G7',10).
distance_gates('G7','G10',2).
distance_gates('G7','G11',5).
distance_gates('G7','G12',7).
distance_gates('G7','G8',10).
distance_gates('G8','G9',3).
distance_gates('G8','G12',3).
distance_gates('G8','G11',4).
distance_gates('G8','G10',8).
distance_gates('G10','G15',5).
distance_gates('G10','G11',2).
distance_gates('G10','G12',5).
distance_gates('G11','G15',4).
distance_gates('G11','G13',5).
distance_gates('G11','G12',4).
distance_gates('G12','G13',7).
distance_gates('G12','G14',8).
distance_gates('G15','G13',3).
distance_gates('G13','G14',4).
distance_gates('G14','G17',5).
distance_gates('G14','G18',4).
distance_gates('G17','G18',8).

connected_gates(Gate1, Gate2) :-
    distance_gates(Gate1, Gate2, _);
    distance_gates(Gate2, Gate1, _).


clone([],[]).
clone([H|T],[H|Z]):- clone(T,Z).


write_to_file(File, Output) :-
    open(File, write, Stream),
    write(Stream, Output), 
    close(Stream).

append_to_file(File, Output) :-
    open(File, append, Stream),
    write(Stream, Output), 
    write(Stream, '\n'), 
    close(Stream).

printAllPaths([]).

printAllPaths([Path | RestPaths]) :-
    append_to_file('all_paths.txt', Path),
    printAllPaths(RestPaths).


validPath(Src, Dest, Visited, Path) :- 
    Src = Dest,
    reverse(Visited, Path).

validPath(Src, Dest, Visited, Path) :- 
    Src \= Dest,
    connected_gates(Src, NextGate),
    \+ member(NextGate, Visited),
    validPath(NextGate, Dest, [NextGate | Visited], Path).

starts(Src) :-
    Src = 'G1';
    Src = 'G2';
    Src = 'G3';
    Src = 'G4'.

findAllPossiblePaths() :-
    findall(Path, ( starts(Src), validPath(Src, 'G17', [Src], Path) ) , AllPaths),
    write_to_file('all_paths.txt', 'Total Paths Found: \n'),
    printAllPaths(AllPaths),
    length(AllPaths, Count),
    format('Total Paths Found: ~w ~n', [Count]),
    write('All paths stored in file \'all_paths.txt\''), nl.


headOfList([H|_], H).

getPathDistance([CurrGate], Distance) :-
    Distance is 0.

getPathDistance([CurrGate | RestPath], Distance) :-
    getPathDistance(RestPath, NewDistance),
    headOfList(RestPath, NextGate),
    ( distance_gates(CurrGate, NextGate, Dist); distance_gates(NextGate, CurrGate, Dist) ),
    Distance is NewDistance + Dist.


% For updating optimum distance path
updateMinDistancePath(Distance, Path, OldBestDistance, OldBestPath, BestDistance, BestPath) :-
    Distance >= OldBestDistance,
    BestDistance is OldBestDistance,
    clone(OldBestPath, BestPath).

updateMinDistancePath(Distance, Path, OldBestDistance, OldBestPath, BestDistance, BestPath) :-
    Distance < OldBestDistance,
    BestDistance is Distance,
    clone(Path, BestPath).


findOptimalPath([], BestDistance, BestPath) :-
    BestDistance is 10000000.

findOptimalPath([Path | OtherPaths], BestDistance, BestPath) :-
    getPathDistance(Path, Distance),
    findOptimalPath(OtherPaths, OldBestDistance, OldBestPath),
    updateMinDistancePath(Distance, Path, OldBestDistance, OldBestPath, BestDistance, BestPath).


optimal() :-
    findall(Path, ( starts(Src), validPath(Src, 'G17', [Src], Path) ) , AllPaths),

    findOptimalPath(AllPaths, BestDistance, BestPath),
    write("Optimal Path:"), nl,
    write(BestPath), nl, 
    format('Total distance covered : ~w ft ~n', [BestDistance]).

travel([CurrGate]) :-
    CurrGate = 'G17'.

travel([CurrGate | RestPath]) :-
    headOfList(RestPath, NextGate),
    connected_gates(CurrGate, NextGate),
    travel(RestPath).

convertToAtoms([], []).

convertToAtoms([CurrString | RestList], [CurrAtom | RestAtomicList]) :-
    convertToAtoms(RestList, RestAtomicList),
    atom_string(CurrAtom, CurrString).


valid(PathString) :-
    split_string(PathString, ",", "[ ]", Path),
    convertToAtoms(Path, AtomicPath),
    headOfList(AtomicPath, StartGate),
    starts(StartGate),
    travel(AtomicPath).
