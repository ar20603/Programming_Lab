Submitted by:
Aman Raj
170101006

SWI-PROLOG

To install in ubuntu:

> sudo apt-add-repository ppa:swi-prolog/stable
> sudo apt-get update
> sudo apt-get install swi-prolog


//////   Question 1 A

>   For uncle(X, Y), we checked X to be a 'male' and then checked if parent of X matches grandparent of Y 
>   Helps to find all the uncles, both on paternal and maternal sides

To run through command line:

>   prolog
>   [q1A].

Then, test the function 'uncle'. Some examples are shown below: 

>   uncle(katappa,avantika).
>   uncle(katappa,A).
>   uncle(A, B).




//////   Question 1 B

>   For A and B to be halfsisters, we need one common parent only.
>   We find two different parents of both A and B
>   Then add a condition that only one parent of A matches one parent of B.

To run through command line:

>   prolog
>   [q1B].

Then, test the function 'halfsister'. Some examples are shown below: 

>   halfsister(avantika, shivkami).
>   halfsister(A, shivkami).
>   halfsister(A, B).




//////   Question 2

>   route() finds all the paths from source to destination using findall()
>   findall() helps to find all paths with backtracking
>   print 'No paths found' if no no such route exists
>   iterates through each path, calculate its cost, distance and time travelled 
>   maintains an optimal path as per required parameter (time/cost/distance), updates it when we get a better path 
>   it even considers the wait time between two buses when adding total time travelled in a path


To run through command line:

>   prolog
>   [q2].

Then, test the required functions. Some examples are shown below: 

>   route(amingaon, chandmari).
>   route(amingaon, amingaon).
>   route(home, iitg).




//////   Question 3

>   For findAllPossiblePaths(), all the paths are stored in a file 'all_paths.txt', giving its count as output too
>   method findall() used in findAllPossiblePaths() handles backtracking to get all possible paths
>   Makes sure in a path, no gate is visited back again
>   optimal() gets all the paths using the findall() and checks each path, computing its distance travelled to get optimal path
>   optimal() maintains a best path, compares each path and updates it if required
>   valid() checks start of path first and then travels along the path provided to see if such a path is possible and ends at the required gate (g17)


To run through command line:

>   prolog
>   [q3].

Then, test the required functions. Some examples are shown below: 
Please wait a few secs, backtracking takes some time.

>   findAllPossiblePaths().
>   optimal().
>   valid([g1, g6, g8, g9, g8, g7, g10, g15, g13, g14, g18, g17]).