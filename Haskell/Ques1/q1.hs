import System.IO
import Data.List

-- Function to check if set is empty
checkEmpty :: [Int] -> Bool
checkEmpty set = null set

-- Function to check if an element is present in a set
presentInSet :: Int -> [Int] -> Bool
presentInSet x (head:restSet) = (x == head) || (presentInSet x restSet)
presentInSet x _ = False

-- Function to find union of two sets
setUnion :: [Int] -> [Int] -> [Int]
setUnion set1 (x:restSet2) = 
    if presentInSet x set1
        then sort (setUnion set1 restSet2)
    else sort (x : (setUnion set1 restSet2))
setUnion set1 _ = set1

-- Function to find intersection of two sets
setIntersection :: [Int] -> [Int] -> [Int]
setIntersection set1 (x:restSet2) = 
    if presentInSet x set1
        then sort (x : (setIntersection set1 restSet2))
    else sort (setIntersection set1 restSet2)
setIntersection set1 _ = []

-- Function to find subtractioon of one set from another
setSubtraction :: [Int] -> [Int] -> [Int]
setSubtraction (x:restSet1) set2 = 
    if presentInSet x set2
        then sort (setSubtraction restSet1 set2)
    else sort (x : (setSubtraction restSet1 set2))
setSubtraction set1 _ = []

-- Function to generate all pairs of an element with all elements of a list/set
gereratePairs :: [Int] -> Int -> [Int]
gereratePairs (x: restSet) num = do
    let sum = x + num
    sort (sum : gereratePairs restSet num)
gereratePairs _ num = []
    
-- Function to find addition of two sets
setAddition :: [Int] -> [Int] -> [Int]
setAddition set1 (x:restSet2) = do
    let partialAnswer = setAddition set1 restSet2
    let answer = gereratePairs set1 x
    setUnion partialAnswer answer
setAddition set1 _ = []

