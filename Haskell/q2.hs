import System.IO
import Data.List
import Data.Maybe
import Data.IORef
import System.IO.Unsafe
import System.Random

-- To store all the registered teams
teams :: [[Char]]
teams = ["BS", "CM", "CH", "CV", "CS", "DS", "EE", "HU", "MA", "ME", "PH", "ST"]

-- To store all the timings of matches possible in increasing order of time
matchTimings :: [[Char]]
matchTimings = ["1-12-2020    9:30 AM", "1-12-2020    7:30 PM", "2-12-2020    9:30 AM", "2-12-2020    7:30 PM", "3-12-2020    9:30 AM", "3-12-2020    7:30 PM"]

{-
    Algo: 
    We get a random permutation of the teams list, store the index of its permutation out of all permutation
    Then simply pair first and second, third and fourth, and so on
    And assign match timings sequentially
    So first and second get match of index 0
-}


-- Stores a refernce of a seed which help us store the index of fixture generated
-- Out of all possible permuation of fixtures
-- Value 0 indicated no fixture generated yet
seed :: IORef Int
seed = unsafePerformIO $ newIORef 0


-- Function takes i and j as input and prints all matches with match index between i and j-1
printMatches :: Int -> Int -> [[Char]] -> IO()
printMatches matchIndex totalMatches schedule = do
    putStrLn(schedule!!(2*matchIndex) ++ " vs " ++ schedule!!(2*matchIndex+1) ++ "\t" ++ matchTimings!!matchIndex)
    if matchIndex /= totalMatches-1
        then printMatches (matchIndex+1) totalMatches schedule
    else putStr ""

-- Function to generate the fixture corresponding to the random seed and printing it
generateFixtures :: Int -> IO()
generateFixtures index = do 
    let schedule = permutations teams !! index
    let totalMatches = length matchTimings
    printMatches 0 totalMatches schedule

-- Main fixture function
fixture :: [Char] -> IO()
-- Function to generate new fixtures
fixture "all" = do
    -- Get a random index from all permutations of the teams
    let newRand = randomIO :: IO Int
    random <- newRand
    let all_possible = 479001600
    let randomIndex = mod random 1000

    -- Making the value of random index positive (if negative)
    if randomIndex < 0
        then writeIORef seed (randomIndex + all_possible)
    else writeIORef seed randomIndex

    -- Storing the random seed value for future use
    randomSeed <- readIORef seed
    generateFixtures randomSeed

-- Function to print fixtures of any team
fixture team = do
    -- Get fixtures corresponding to the random seed chosen
    randomSeed <- readIORef seed
    let schedule = permutations teams !! randomSeed
    
    -- No fixtures generated if randomSeed is 0
    if randomSeed == 0
        then putStrLn "No fixtures generated yet."
    else 
        -- Ensuring team exists
        if team `elem` teams
            then do
                -- Finding match corresponding to the team and printing it
                let teamIndex = fromJust(team `elemIndex` schedule)
                let matchIndex = teamIndex `div` 2 
                printMatches matchIndex (matchIndex+1) schedule
        -- If no such teams exists
        else putStrLn "No such registered team."


-- Function to print the next match given date and time
nextMatch :: Int -> Double -> IO()
nextMatch date time = do
    -- Get fixtures corresponding to the random seed chosen
    randomSeed <- readIORef seed  
    let schedule = permutations teams !! randomSeed
    
    -- No fixtures generated if randomSeed is 0
    if randomSeed == 0
        then putStrLn "No fixtures generated yet."
    else 
        -- If invalid date or time is given as input
        -- For rest cases, use the date and time to get the match index corresponding to the given time
        -- Then printing the match details corresponding to the obtained match index
        -- Or printing if time and date are after last match, "No next match available. All matches already played.".
        if date < 1 || date > 31 || time < 0 || time > 24    
            then putStrLn "Invalid Input Date or Time"
        else if date == 1 && time <= 9.5                   
            then printMatches 0 1 schedule
        else if date == 1 && time <= 19.5                  
            then printMatches 1 2 schedule
        else if date == 1 || (date == 2 && time <= 9.5)     
            then printMatches 2 3 schedule
        else if date == 2 && time <= 19.5                  
            then printMatches 3 4 schedule
        else if date == 2 || (date == 3 && time <= 9.5)     
            then printMatches 4 5 schedule
        else if date == 3 && time <= 19.5                  
            then printMatches 5 6 schedule
        else
            putStrLn "No next match available. All matches already played."
