bus(123, amingaon, jalukbari, 14.5, 15, 3, 10).
bus(222, jalukbari, panbazar, 2, 6, 4, 45).
bus(245, jalukbari, panbazar, 7, 10, 10, 50).
bus(756, panbazar, chandmari, 16, 15, 7, 8).
bus(111, jalukbari, chandmari, 5, 2, 1, 100).
bus(177, amingaon, chandmari, 13, 15, 23, 1000).
bus(999, jalukbari, amingaon, 14.5, 15, 3, 10).


clone([],[]).
clone([H|T],[H|Z]):- clone(T,Z).

timeDifference(Time1, Time2, TotalTime) :-
    Time2 \= -1,
    Time2 < Time1,
    TotalTime is (24 - (Time1 - Time2)).

timeDifference(Time1, Time2, TotalTime) :-
    Time2 \= -1,
    Time2 >= Time1,
    TotalTime is (Time2 - Time1).

timeDifference(Time1, Time2, TotalTime) :-
    Time2 = -1,
    TotalTime is 0.

getPathDetails([Dest], Distance, Cost, Time, NextBusTime) :-
    Distance is 0,
    Cost is 0,
    Time is 0,
    NewNextBusTime is -1.

getPathDetails([Src-BusID | RestPath], Distance, Cost, Time, NextBusTime) :-
    getPathDetails(RestPath, NewDistance, NewCost, NewTime, NewNextBusTime),
    bus(BusID, Src, _, StartTime, EndTime, Dist, Fare),
    Distance is NewDistance + Dist,
    Cost is NewCost + Fare,
    timeDifference(StartTime, EndTime, TravelTime),
    timeDifference(EndTime, NewNextBusTime, WaitTime),
    Time is (NewTime + TravelTime + WaitTime),
    NextBusTime is StartTime.


% For optimum distance path
updateMinDistancePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Distance >= OldBestDistance,
    BestDistance is OldBestDistance,
    BestCost is OldBestCost,
    BestTime is OldBestTime,
    clone(OldBestPath, BestPath).

updateMinDistancePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Distance < OldBestDistance,
    BestDistance is Distance,
    BestCost is Cost,
    BestTime is Time,
    clone(Path, BestPath).


findMinDistancePath([], BestDistance, BestCost, BestTime, BestPath) :-
    BestDistance is 10000000.

findMinDistancePath([Path | OtherPaths], BestDistance, BestCost, BestTime, BestPath) :-
    getPathDetails(Path, Distance, Cost, Time, StartBusTime),
    findMinDistancePath(OtherPaths, OldBestDistance, OldBestCost, OldBestTime, OldBestPath),
    updateMinDistancePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath).


% For optimum cost path
updateMinCostPath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Cost >= OldBestCost,
    BestDistance is OldBestDistance,
    BestCost is OldBestCost,
    BestTime is OldBestTime,
    clone(OldBestPath, BestPath).

updateMinCostPath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Cost < OldBestCost,
    BestDistance is Distance,
    BestCost is Cost,
    BestTime is Time,
    clone(Path, BestPath).


findMinCostPath([], BestDistance, BestCost, BestTime, BestPath) :-
    BestCost is 10000000.

findMinCostPath([Path | OtherPaths], BestDistance, BestCost, BestTime, BestPath) :-
    getPathDetails(Path, Distance, Cost, Time, StartBusTime),
    findMinCostPath(OtherPaths, OldBestDistance, OldBestCost, OldBestTime, OldBestPath),
    updateMinCostPath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath).


% For optimum time path
updateMinTimePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Time >= OldBestTime,
    BestDistance is OldBestDistance,
    BestCost is OldBestCost,
    BestTime is OldBestTime,
    clone(OldBestPath, BestPath).

updateMinTimePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Time < OldBestTime,
    BestDistance is Distance,
    BestCost is Cost,
    BestTime is Time,
    clone(Path, BestPath).


findMinTimePath([], BestDistance, BestCost, BestTime, BestPath) :-
    BestTime is 10000000.

findMinTimePath([Path | OtherPaths], BestDistance, BestCost, BestTime, BestPath) :-
    getPathDetails(Path, Distance, Cost, Time, StartBusTime),
    findMinTimePath(OtherPaths, OldBestDistance, OldBestCost, OldBestTime, OldBestPath),
    updateMinTimePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath).



validPath(Src, Dest, Visited, Path) :- 
    Src = Dest,
    reverse(Visited, Path).

validPath(Src, Dest, [Src | OtherVisited], Path) :- 
    Src \= Dest,
    bus(BusID, Src, NextStop, _, _, _, _),
    NextStop \= Src,
    \+ (member(NextStop-_, OtherVisited); member(NextStop, OtherVisited)),
    validPath(NextStop, Dest, [NextStop | [Src-BusID | OtherVisited]], Path).


route(Src, Dest) :-
    findall(Path, ( validPath(Src, Dest, [Src], Path) ), AllPaths),
    %  write(AllPaths), nl,
    %  Finding optimum distance path

    findMinDistancePath(AllPaths, Distance1, Cost1, Time1, Path1),
    write("Optimum Distance:"), nl,
    write(Path1), nl, 
    format('Distance=~2f, Time=~2f, Cost=~2f ~n~n', [Distance1, Time1, Cost1]),

    %  Finding optimum cost path

    findMinCostPath(AllPaths, Distance2, Cost2, Time2, Path2),
    write("Optimum Cost:"), nl,
    write(Path2), nl, 
    format('Distance=~2f, Time=~2f, Cost=~2f ~n~n', [Distance2, Time2, Cost2]),

    %  Finding optimum time path

    findMinTimePath(AllPaths, Distance3, Cost3, Time3, Path3),
    write("Optimum Time:"), nl,
    write(Path3), nl, 
    format('Distance=~2f, Time=~2f, Cost=~2f ~n~n', [Distance3, Time3, Cost3]).
