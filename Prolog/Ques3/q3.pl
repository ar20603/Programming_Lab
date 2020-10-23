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

write_to_file(File, Output) :-
    open(File, write, Stream),
    write(Stream, Output), nl, 
    close(Stream).

validPath(Src, Dest, [First]) :- 
    First = Src,
    Src = Dest.

validPath(Src, Dest, [First | RestPath]) :- 
    First = Src,
    Src \= Dest,
    validPath(X, Dest, RestPath),
    \+ member(First, RestPath).


route(Src, Dest) :-
    findall(Path, ( validPath(Src, Dest, Path) ), AllPaths),
    write_to_file('all_paths.txt', AllPaths).