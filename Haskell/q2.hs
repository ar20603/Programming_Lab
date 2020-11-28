import System.IO
import Data.List
import Data.Maybe
import Data.IORef
import System.IO.Unsafe
import System.Random


teams :: [[Char]]
teams = ["BS", "CM", "CH", "CV", "CS", "DS", "EE", "HU", "MA", "ME", "PH", "ST"]


matchTimings :: [[Char]]
matchTimings = ["1-12-2020    9:30 AM", "1-12-2020    7:30 PM", "2-12-2020    9:30 AM", "2-12-2020    7:30 PM", "3-12-2020    9:30 AM", "3-12-2020    7:30 PM"]


seed :: IORef Int
seed = unsafePerformIO $ newIORef 0


printMatches :: Int -> Int -> [[Char]] -> IO()
printMatches matchIndex totalMatches schedule = do
    putStrLn(schedule!!(2*matchIndex) ++ " vs " ++ schedule!!(2*matchIndex+1) ++ "\t" ++ matchTimings!!matchIndex)
    if matchIndex /= totalMatches-1
        then printMatches (matchIndex+1) totalMatches schedule
    else putStr ""


generateFixtures :: Int -> IO()
generateFixtures index = do 
    let schedule = permutations teams !! index
    let totalMatches = length matchTimings
    printMatches 0 totalMatches schedule


fixture :: [Char] -> IO()
fixture "all" = do
    let newRand = randomIO :: IO Int
    random <- newRand
    let all_possible = 479001600
    let randomIndex = mod random 1000

    if randomIndex < 0
        then writeIORef seed (randomIndex + all_possible)
    else writeIORef seed randomIndex

    randomSeed <- readIORef seed
    generateFixtures randomSeed


fixture team = do
    randomSeed <- readIORef seed
    let schedule = permutations teams !! randomSeed

    if randomSeed == 0
        then putStrLn "No fixtures generated yet."
    else 
        if team `elem` teams
            then do
                let teamIndex = fromJust(team `elemIndex` schedule)
                let matchIndex = teamIndex `div` 2 
                printMatches matchIndex (matchIndex+1) schedule
        else putStrLn "No such registered team."


nextMatch :: Int -> Double -> IO()
nextMatch day time = do
    randomSeed <- readIORef seed  
    let schedule = permutations teams !! randomSeed
      
    if randomSeed == 0
        then putStrLn "No fixtures generated yet."
    else 
        if day < 1 || day > 31 || time < 0 || time > 24    
            then putStrLn "Invalid Input Date or Time"
        else if day == 1 && time <= 9.5                   
            then printMatches 0 1 schedule
        else if day == 1 && time <= 19.5                  
            then printMatches 1 2 schedule
        else if day == 1 || (day == 2 && time <= 9.5)     
            then printMatches 2 3 schedule
        else if day == 2 && time <= 19.5                  
            then printMatches 3 4 schedule
        else if day == 2 || (day == 3 && time <= 9.5)     
            then printMatches 4 5 schedule
        else if day == 3 && time <= 19.5                  
            then printMatches 5 6 schedule
        else
            putStrLn "No next match available. All matches already played."
