import System.IO
import Data.List

checkEmpty :: [Int] -> Bool
checkEmpty set = null set


presentInSet :: Int -> [Int] -> Bool
presentInSet x (head:restSet) = (x == head) || (presentInSet x restSet)
presentInSet x _ = False


setUnion :: [Int] -> [Int] -> [Int]
setUnion set1 (x:restSet2) = 
    if presentInSet x set1
        then sort (setUnion set1 restSet2)
    else sort (x : (setUnion set1 restSet2))
setUnion set1 _ = set1


setIntersection :: [Int] -> [Int] -> [Int]
setIntersection set1 (x:restSet2) = 
    if presentInSet x set1
        then sort (x : (setIntersection set1 restSet2))
    else sort (setIntersection set1 restSet2)
setIntersection set1 _ = []


setSubtraction :: [Int] -> [Int] -> [Int]
setSubtraction (x:restSet1) set2 = 
    if presentInSet x set2
        then sort (setSubtraction restSet1 set2)
    else sort (x : (setSubtraction restSet1 set2))
setSubtraction set1 _ = []


gereratePairs :: [Int] -> Int -> [Int]
gereratePairs (x: restSet) num = do
    let sum = x + num
    sort (sum : gereratePairs restSet num)
gereratePairs _ num = []
    

setAddition :: [Int] -> [Int] -> [Int]
setAddition set1 (x:restSet2) = do
    let partialAnswer = setAddition set1 restSet2
    let answer = gereratePairs set1 x
    setUnion partialAnswer answer

setAddition set1 _ = []

