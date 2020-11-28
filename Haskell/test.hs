-- Comment
{-
    Multi Comment
-}

import Data.List
import System.IO

maxInt = maxBound :: Int
minInt = minBound :: Int
md = mod maxInt 5

array = [2,2,3,4,5]

val = array !! 3
val1 = head array
val3 = tail array

zeroToTen = [0..10]
evens = [2,4..24]

arr = [x*3 | x <- [1..10], x*3 <= 20]
y = sort arr

e2 = takeWhile (<=20) [2,4..]

num2 = 2
getDouble x = x * 2
