import System.IO
import Data.List

getThirdFromTuple (_, _, x) = x
getSecondFromTuple (_, x, _) = x
getFirstFromTuple (x, _, _) = x

printBest best_area total_area best_design = do
    putStrLn("Bedroom: " ++ show(getThirdFromTuple (best_design !! 0)) ++ " (" ++ show(getSecondFromTuple (best_design !! 0)) ++ " x " ++ show(getFirstFromTuple (best_design !! 0)) ++ ")")
    putStrLn("Hall: " ++ show(getThirdFromTuple (best_design !! 1)) ++ " (" ++ show(getSecondFromTuple (best_design !! 1)) ++ " x " ++ show(getFirstFromTuple (best_design !! 1)) ++ ")")
    putStrLn("Kitchen: " ++ show(getThirdFromTuple (best_design !! 2)) ++ " (" ++ show(getSecondFromTuple (best_design !! 2)) ++ " x " ++ show(getFirstFromTuple (best_design !! 2)) ++ ")")
    putStrLn("Bathroom: " ++ show(getThirdFromTuple (best_design !! 3)) ++ " (" ++ show(getSecondFromTuple (best_design !! 3)) ++ " x " ++ show(getFirstFromTuple (best_design !! 3)) ++ ")")
    putStrLn("Garden: " ++ show(getThirdFromTuple (best_design !! 4)) ++ " (" ++ show(getSecondFromTuple (best_design !! 4)) ++ " x " ++ show(getFirstFromTuple (best_design !! 4)) ++ ")")
    putStrLn("Balcony: " ++ show(getThirdFromTuple (best_design !! 5)) ++ " (" ++ show(getSecondFromTuple (best_design !! 5)) ++ " x " ++ show(getFirstFromTuple (best_design !! 5)) ++ ")")
    putStrLn("Unused Space: " ++ show(total_area - best_area))

findBestDesign ((dimension_array, area) : restDesigns) totalSpace = do
    let (best_area, best_dimension_array) = findBestDesign restDesigns totalSpace
    if area > best_area
        then (area, dimension_array)
    else (best_area, best_dimension_array)
findBestDesign _ _ = (0, [])

presentArea :: Eq t => t -> [(a, t)] -> Bool
presentArea newArea ((dimension_array, area) : restAreas) = do
    (newArea == area) || (presentArea newArea restAreas)
presentArea newArea _ = False

filtering :: Eq b => [(a, b)] -> [(a, b)]
filtering ((dimension_array, area) : restArray) = do
    let partialFiltered = filtering restArray
    if presentArea area partialFiltered
        then partialFiltered
    else (dimension_array, area) : partialFiltered

filtering _ = []

design :: (Int, Int, Int) -> IO ()
design (totalSpace, num_bedroom, num_hall) = do
    let bedrooms = [(x, y, num_bedroom) | x <- [10..15], y <- [10..15], num_bedroom*x*y <= totalSpace]
    let halls = [(x, y, num_hall) | x <- [15..20], y <- [10..15], num_hall*x*y <= totalSpace]
    
    let max_kitchens = (num_bedroom + 2) `div` 3
    let kitchens = [(x, y, num_kitchen) | x <- [7..15], y <- [5..13], num_kitchen <- [1..max_kitchens], x*y*num_kitchen <= totalSpace]
    let num_bathroom = num_bedroom + 1
    let bathrooms = [(x, y, num_bathroom) | x <- [4..8], y <- [5..9], x*y*num_bathroom <= totalSpace]

    let garden = [(x, y, 1) | x <- [5..10], y <- [5..10], x*y <= totalSpace]
    let balcony = [(x, y, 1) | x <- [10..20], y <- [10..20], x*y <= totalSpace]

    let combined1 = [( [(x1, y1, n1), (x2, y2, n2)], x1 * y1 * n1 + x2 * y2 * n2 ) | (x1, y1, n1) <- bedrooms, (x2, y2, n2) <- halls, x1 * y1 * n1 + x2 * y2 * n2 <= totalSpace]
    let combined_bedrooms_halls = filtering combined1

    let combined2 = [( [(x1, y1, n1), (x2, y2, n2)], x1 * y1 * n1 + x2 * y2 * n2 ) | (x1, y1, n1) <- kitchens, (x2, y2, n2) <- bathrooms, x2 <= x1, y2 <= y1 , x1 * y1 * n1 + x2 * y2 * n2 <= totalSpace]
    let combined_kitchens_balcony = filtering combined2

    let combined3 = [( [(x1, y1, n1), (x2, y2, n2), (x3, y3, n3), (x4, y4, n4)], a1 + a2 ) | ([(x1, y1, n1), (x2, y2, n2)], a1) <- combined_bedrooms_halls, ([(x3, y3, n3), (x4, y4, n4)], a2)  <- combined_kitchens_balcony, x3 <= x1, x3 <= x2, y3 <= y1, y3 <= y2, a1 + a2 <= totalSpace]
    let combined_first_four_types = filtering combined3
    
    let combined4 = [( [(x1, y1, n1), (x2, y2, n2)], x1 * y1 * n1 + x2 * y2 * n2 ) | (x1, y1, n1) <- garden, (x2, y2, n2) <- balcony, x1 * y1 * n1 + x2 * y2 * n2 <= totalSpace]
    let combined_garden_balcony = filtering combined4
    
    let combined5 = [( [(x1, y1, n1), (x2, y2, n2), (x3, y3, n3), (x4, y4, n4), (x5, y5, n5), (x6, y6, n6)], a1 + a2 ) | ([(x1, y1, n1), (x2, y2, n2), (x3, y3, n3), (x4, y4, n4)], a1) <- combined_first_four_types, ([(x5, y5, n5), (x6, y6, n6)], a2)  <- combined_garden_balcony, a1 + a2 <= totalSpace]
    let combined_all = filtering combined5

    let (best_area, best_design) = findBestDesign combined_all totalSpace
    
    printBest best_area totalSpace best_design