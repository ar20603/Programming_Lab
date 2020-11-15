% some bus details predicates
bus(123, amingaon, jalukbari, 14.5, 15, 3, 10).
bus(222, jalukbari, panbazar, 2, 6, 4, 45).
bus(245, jalukbari, panbazar, 7, 10, 10, 50).
bus(756, panbazar, chandmari, 16, 15, 7, 8).
bus(111, jalukbari, chandmari, 5, 2, 1, 100).
bus(177, amingaon, chandmari, 13, 15, 23, 1000).
bus(999, jalukbari, amingaon, 14.5, 15, 3, 10).


% used to clone a list
clone([],[]).
clone([H|T],[H|Z]):- clone(T,Z).

% returns true if a list is empty
isEmpty([]).


% 'timeDifference' helps to calculate the time travelled in the path
% when day changes between two buses
timeDifference(Time1, Time2, TotalTime) :-
    Time2 \= -1,
    Time2 < Time1,
    TotalTime is (24 - (Time1 - Time2)).

% getting next bus on same day
timeDifference(Time1, Time2, TotalTime) :-
    Time2 \= -1,
    Time2 >= Time1,
    TotalTime is (Time2 - Time1).

% Time2 = -1 shows its the last stop, so no more bus wait time
timeDifference(_, Time2, TotalTime) :-
    Time2 = -1,
    TotalTime is 0.


% 'printPath' helps to output the path in desired format as given in question

printPath([Dest]) :-
    write(Dest).

printPath([Src-BusID | RestPath]) :-
    format("~s,~w -> ", [Src, BusID]),
    printPath(RestPath).


% 'getPathDetails' helps to calculate the distance travelled, cost involved, time spent in a path

getPathDetails([_], Distance, Cost, Time, NextBusTime) :-
    Distance is 0,
    Cost is 0,
    Time is 0,
    NextBusTime is -1.

getPathDetails([Src-BusID | RestPath], Distance, Cost, Time, NextBusTime) :-
    getPathDetails(RestPath, NewDistance, NewCost, NewTime, NewNextBusTime),
    % check that current stop should have a bus to next stop 
    bus(BusID, Src, _, StartTime, EndTime, Dist, Fare),
    
    % Add distance, cost and time involved with that bus
    Distance is NewDistance + Dist,
    Cost is NewCost + Fare,

    % add travel time in bus as well as wait time for next bus
    timeDifference(StartTime, EndTime, TravelTime),
    timeDifference(EndTime, NewNextBusTime, WaitTime),
    Time is (NewTime + TravelTime + WaitTime),
    NextBusTime is StartTime.


% 'updateMinDistancePath' helps in updating optimum distance path

% if distance of this path >= old best distance, old best path is retained and copied to new best path
updateMinDistancePath(Distance, _, _, _, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Distance >= OldBestDistance,
    BestDistance is OldBestDistance,
    BestCost is OldBestCost,
    BestTime is OldBestTime,
    clone(OldBestPath, BestPath).

% if distance of this path < old best distance, old best path is removed and current path is treated as the best path
updateMinDistancePath(Distance, Cost, Time, Path, OldBestDistance, _, _, _, BestDistance, BestCost, BestTime, BestPath) :-
    Distance < OldBestDistance,
    BestDistance is Distance,
    BestCost is Cost,
    BestTime is Time,
    clone(Path, BestPath).


findMinDistancePath([], BestDistance, _, _, _) :-
    BestDistance is 10000000.

findMinDistancePath([Path | OtherPaths], BestDistance, BestCost, BestTime, BestPath) :-
    getPathDetails(Path, Distance, Cost, Time, _),
    
    % recursively checking other paths
    findMinDistancePath(OtherPaths, OldBestDistance, OldBestCost, OldBestTime, OldBestPath),
    
    % updating best path, by comapring this path with last best path 
    updateMinDistancePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath).


% 'updateMinCostPath' helps in updating optimum distance path

% if cost of this path >= old best cost, old best path is retained and copied to new best path
updateMinCostPath(_, Cost, _, _, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Cost >= OldBestCost,
    BestDistance is OldBestDistance,
    BestCost is OldBestCost,
    BestTime is OldBestTime,
    clone(OldBestPath, BestPath).

% if cost of this path < old best cost, old best path is removed and current path is treated as the best path
updateMinCostPath(Distance, Cost, Time, Path, _, OldBestCost, _, _, BestDistance, BestCost, BestTime, BestPath) :-
    Cost < OldBestCost,
    BestDistance is Distance,
    BestCost is Cost,
    BestTime is Time,
    clone(Path, BestPath).


% 'findMinCostPath' helps to find the optimal path by checking cost/fare of each path, and maintain a best path

findMinCostPath([], _, BestCost, _, _) :-
    % initializing best path cost with a max value
    BestCost is 10000000.

findMinCostPath([Path | OtherPaths], BestDistance, BestCost, BestTime, BestPath) :-
    getPathDetails(Path, Distance, Cost, Time, _),
    
    % recursively checking other paths
    findMinCostPath(OtherPaths, OldBestDistance, OldBestCost, OldBestTime, OldBestPath),
    
    % updating best path, by comapring this path with last best path 
    updateMinCostPath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath).


% 'updateMinTimePath' helps in updating optimum time path
% if time of this path >= old best time, old best path is retained and copied to new best path
updateMinTimePath(_, _, Time, _, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath) :-
    Time >= OldBestTime,
    BestDistance is OldBestDistance,
    BestCost is OldBestCost,
    BestTime is OldBestTime,
    clone(OldBestPath, BestPath).

% if time of this path < old best time, old best path is removed and current path is treated as the best path
updateMinTimePath(Distance, Cost, Time, Path, _, _, OldBestTime, _, BestDistance, BestCost, BestTime, BestPath) :-
    Time < OldBestTime,
    BestDistance is Distance,
    BestCost is Cost,
    BestTime is Time,
    clone(Path, BestPath).


% 'findMinTimePath' helps to find the optimal path by checking time of each path, and maintain a best path

findMinTimePath([], _, _, BestTime, _) :-
    BestTime is 10000000.

findMinTimePath([Path | OtherPaths], BestDistance, BestCost, BestTime, BestPath) :-
    getPathDetails(Path, Distance, Cost, Time, _),
    
    % recursively checking other paths
    findMinTimePath(OtherPaths, OldBestDistance, OldBestCost, OldBestTime, OldBestPath),
    
    % updating best path, by comapring this path with last best path 
    updateMinTimePath(Distance, Cost, Time, Path, OldBestDistance, OldBestCost, OldBestTime, OldBestPath, BestDistance, BestCost, BestTime, BestPath).


% 'validPath' provides conditions for a valid path from start bus stop to end bus stop
% findall() uses this 'validPath' to backtrack and find all valid paths

validPath(Src, Dest, Visited, Path) :- 
    % ensuring destination is reached at end
    Src = Dest,
    % copying the visited bus stops with bus IDs in reverse order gives the 'Path'
    reverse(Visited, Path).

validPath(Src, Dest, [Src | OtherVisited], Path) :- 
    Src \= Dest,
    % ensuring bus exists for next stop and it is not already visited
    bus(BusID, Src, NextStop, _, _, _, _),
    NextStop \= Src,
    \+ (member(NextStop-_, OtherVisited); member(NextStop, OtherVisited)),
    validPath(NextStop, Dest, [NextStop | [Src-BusID | OtherVisited]], Path).


% main function for question 2
% finds all paths(bus routes) from Src to Dest and then find optimals ones with different parameter
route(Src, Dest) :-

    % findall() helps to find all bus routes with given validity conditions
    findall(Path, ( validPath(Src, Dest, [Src], Path) ), AllPaths),

    (
    % Checking if no such path exists
    isEmpty(AllPaths) -> 
    write("No paths found."), nl
    ;
    
    % Finding optimum distance path
    % calculate distance of each valid path and maintain minimum distance path 
    findMinDistancePath(AllPaths, Distance1, Cost1, Time1, Path1),
    write("Optimum Distance:"), nl,
    printPath(Path1), nl, 
    format('Distance=~2f, Time=~2f, Cost=~2f ~n~n', [Distance1, Time1, Cost1]),

    % Finding optimum cost path
    % calculate cost/fare of each valid path and maintain minimum cost path 
    findMinCostPath(AllPaths, Distance2, Cost2, Time2, Path2),
    write("Optimum Cost:"), nl,
    printPath(Path2), nl, 
    format('Distance=~2f, Time=~2f, Cost=~2f ~n~n', [Distance2, Time2, Cost2]),

    % Finding optimum time path
    % calculate time of each valid path and maintain minimum time path 
    findMinTimePath(AllPaths, Distance3, Cost3, Time3, Path3),
    write("Optimum Time:"), nl,
    printPath(Path3), nl, 
    format('Distance=~2f, Time=~2f, Cost=~2f ~n~n', [Distance3, Time3, Cost3])
    ).