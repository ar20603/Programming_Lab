% given predicates showing the connected gates and distance between them
distance_gates(g1, g5, 4).
distance_gates(g2, g5, 6).
distance_gates(g3, g5, 8).
distance_gates(g4, g5, 9).
distance_gates(g1, g6, 10).
distance_gates(g2, g6, 9).
distance_gates(g3, g6, 3).
distance_gates(g4, g6, 5).
distance_gates(g5, g7, 3).
distance_gates(g5, g10, 4).
distance_gates(g5, g11, 6).
distance_gates(g5, g12, 7).
distance_gates(g5, g6, 7).
distance_gates(g5, g8, 9).
distance_gates(g6, g8, 2).
distance_gates(g6, g12, 3).
distance_gates(g6, g11, 5).
distance_gates(g6, g10, 9).
distance_gates(g6, g7, 10).
distance_gates(g7, g10, 2).
distance_gates(g7, g11, 5).
distance_gates(g7, g12, 7).
distance_gates(g7, g8, 10).
distance_gates(g8, g9, 3).
distance_gates(g8, g12, 3).
distance_gates(g8, g11, 4).
distance_gates(g8, g10, 8).
distance_gates(g10, g15, 5).
distance_gates(g10, g11, 2).
distance_gates(g10, g12, 5).
distance_gates(g11, g15, 4).
distance_gates(g11, g13, 5).
distance_gates(g11, g12, 4).
distance_gates(g12, g13, 7).
distance_gates(g12, g14, 8).
distance_gates(g15, g13, 3).
distance_gates(g13, g14, 4).
distance_gates(g14, g17, 5).
distance_gates(g14, g18, 4).
distance_gates(g17, g18, 8).


% to check if one can go from Gate1 to Gate2
connected_gates(Gate1, Gate2) :-
    distance_gates(Gate1, Gate2, _);                                    
    distance_gates(Gate2, Gate1, _).                                    


% to clone/copy a list
clone([],[]).
clone([H|T],[H|Z]):- clone(T,Z).


% create, open and write to file
write_to_file(File, Output) :-
    open(File, write, Stream),                  % creating a new file and writing a path 
    write(Stream, Output), 
    close(Stream).

% append to an existing file
append_to_file(File, Output) :-
    open(File, append, Stream),
    write(Stream, Output),                      % writing all the paths in file
    write(Stream, '\n'), 
    close(Stream).


% 'printPath' helps to print each path in the desired format with arrows
printPath([Dest]) :-
    write(Dest).

printPath([Src | RestPath]) :-
    format("~s -> ", [Src]),
    printPath(RestPath).


% 'printAllPaths' helps to print all the found paths in the 'all_paths.txt' file
printAllPaths([]).

printAllPaths([Path | RestPaths]) :-
    % appending each path in the created file
    append_to_file('all_paths.txt', Path),
    printAllPaths(RestPaths).


% 'validPath' provides conditions for a valid path from start gate to end gate
% findall() uses this 'validPath' to backtrack and find all valid paths

validPath(Src, Dest, Visited, Path) :-
    % ensuring destination is reached at end
    Src = Dest,
    % copying the visited gates in reverse order gives the 'Path'
    reverse(Visited, Path).

validPath(Src, Dest, Visited, Path) :- 
    Src \= Dest,
    % ensuring next gate is connected and not already visited
    connected_gates(Src, NextGate),
    \+ member(NextGate, Visited),
    validPath(NextGate, Dest, [NextGate | Visited], Path).


% used to match the starting gates of a valid path
starts(Src) :-
    Src = g1; 
    Src = g2; 
    Src = g3; 
    Src = g4. 


% For part 'a' of question 3
% Used to find all the possible paths
% and write all the paths in file 'all_paths.txt'

findAllPossiblePaths() :-

    % findall() helps to find all paths with given validity conditions
    findall(Path, ( starts(Src), validPath(Src, g17, [Src], Path) ) , AllPaths),
    
    write_to_file('all_paths.txt', 'Total Paths Found: \n'),
    printAllPaths(AllPaths),
    length(AllPaths, Count),
    format('Total Paths Found: ~w ~n', [Count]),
    write('All paths stored in file \'all_paths.txt\''), nl.


% return head of any list as H
headOfList([H|_], H).


% 'getPathDistance' helps to calculate distance travelled in any path
getPathDistance([_], Distance) :-
    Distance is 0.

getPathDistance([CurrGate | RestPath], Distance) :-
    getPathDistance(RestPath, NewDistance),
    headOfList(RestPath, NextGate),

    % check that CurrGate should be connected to NextGate and add the distance between them to total distance
    ( distance_gates(CurrGate, NextGate, Dist); distance_gates(NextGate, CurrGate, Dist) ),
    Distance is NewDistance + Dist.


% 'updateMinDistancePath' helps in updating optimum distance path

% if distance of this path >= old best distance, old best path is retained and copied to new best path
updateMinDistancePath(Distance, _, OldBestDistance, OldBestPath, BestDistance, BestPath) :-
    Distance >= OldBestDistance,
    BestDistance is OldBestDistance,
    clone(OldBestPath, BestPath).

% if distance of this path < old best distance, old best path is removed and current path is treated as the best path
updateMinDistancePath(Distance, Path, OldBestDistance, _, BestDistance, BestPath) :-
    Distance < OldBestDistance,
    BestDistance is Distance,
    clone(Path, BestPath).



% 'findOptimalPath' helps to find the optimal path by checking distance of each path, and maintain a best path

findOptimalPath([], BestDistance, _) :-
    % initializing best distance with a max value
    BestDistance is 10000000.

findOptimalPath([Path | OtherPaths], BestDistance, BestPath) :-
    getPathDistance(Path, Distance),

    % recursively checking other paths
    findOptimalPath(OtherPaths, OldBestDistance, OldBestPath),

    % updating best path, by comapring this path with last best path 
    updateMinDistancePath(Distance, Path, OldBestDistance, OldBestPath, BestDistance, BestPath).



% For part 'b' of question 3
% To print the optimal path i.e., minimum distance travelled among all valid paths

optimal() :-
    % finds all the valid paths
    findall(Path, ( starts(Src), validPath(Src, g17,  [Src], Path) ) , AllPaths),

    % iterate over each path to find optimal one
    findOptimalPath(AllPaths, BestDistance, BestPath),

    % printing the optimal path found and its distance
    write("Optimal Path:"), nl,
    printPath(BestPath), nl, 
    format('Total distance covered : ~w ft ~n', [BestDistance]).


% 'travel' helps to check if path leads to final gate for part c of question
% path should end at gate 17
travel([CurrGate]) :-
    CurrGate = g17. 

% checks that two adjacent gates are connected and then recursively check of rest path leads to gate 17
travel([CurrGate | RestPath]) :-
    headOfList(RestPath, NextGate),
    connected_gates(CurrGate, NextGate),
    travel(RestPath).


% For part 'c' of question 3
% checks if the path given as argument is valid

valid([StartGate | RestPath]) :-
    starts(StartGate),                  % matches starting gate
    travel(RestPath).                   % matches rest of the path recursively
