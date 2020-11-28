Submitted by:
Aman Raj
170101006

HASKELL

To install in ubuntu:
```
sudo apt-get install haskell-platform
```
Note: Algorithms are given in report for each question

# Question 1 

To run through command line:
```
ghci
:l q1.hs
```

Then, test the functions of set operations. Some examples are shown below: 
```
checkEmpty [1, 2]
setUnion [1, 2, 3, 5] [4, 5]
setIntersection [1, 2, 3, 5] [4, 5]
setSubtraction [1, 2, 3, 5] [4, 5]
setAddition [1, 2, 3, 5] [4, 5]
```


# Question 2

To run through command line:
```
ghci
:l q2.hs
```

Then, test the required functions. Some examples are shown below: 
```
fixture "all"
fixture "HU"
nextMatch 1 4.5
nextMatch 1 20.5
nextMatch 3 2.5
```


# Question 3

To run through command line:
```
ghci
:l q3.hs
```

Then, test the required functions. Some examples are shown below: 
Please wait a few secs, checking all possible cases takes some time.
```
design (1000,3,2)
design (1250,3,2)
design (1500,1,1)
```
Last case shows some unused space as even all the rooms with maximum area can't cover the total space provided.