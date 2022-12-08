import Data.Array ( Array, listArray, (!), bounds )
import Data.Char ( digitToInt )

type Matrix = Array Int (Array Int Int)

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . listToArray . map (listToArray . map digitToInt) . lines $ fileContents
       print . solvePartTwo . listToArray . map (listToArray . map digitToInt) . lines $ fileContents

solvePartOne :: Matrix -> Int
solvePartOne m = let (r, c) = matrixBounds m
                 in (length . filter (==True)) [isVisible (matrixElem (i,j) m) (neighbors (i, j) m ) | i <- [1..(c-1)], j <- [1..(r-1)]] + circumference m

solvePartTwo :: Matrix -> Int
solvePartTwo m = let (r, c) = matrixBounds m
                 in maximum [scenicScore (matrixElem (i,j) m) (neighbors (i, j) m ) | i <- [1..(c-1)], j <- [1..(r-1)]]

listToArray :: [a] -> Array Int a
listToArray list = listArray (0, length list - 1) list

matrixElem :: (Int, Int) -> Matrix -> Int
matrixElem (x, y) m = (m ! x) ! y

matrixBounds :: Matrix -> (Int, Int)
matrixBounds m = ((snd . bounds) (m ! 0), (snd . bounds) m)

circumference :: Matrix -> Int
circumference m = let (r, c) = matrixBounds m
                  in (1 + r) * 2 + (1 + c) * 2 - 4

-- It would be better to not compute all neighbors before checking if trees are visible or to compute the scenic score
-- A more performant method would only check the necessary trees
neighbors :: (Int, Int) -> Matrix -> [[Int]]
neighbors (x, y) m = let (r, c) = matrixBounds m
                     in [
                            [matrixElem (x, n) m | n <- [(y+1)..c]],
                            [matrixElem (n, y) m | n <- [(x+1)..r]],
                            [matrixElem (x, n) m | n <- reverse [0..(y-1)]],
                            [matrixElem (n, y) m | n <- reverse [0..(x-1)]]
                        ]

isVisible :: Int -> [[Int]] -> Bool
isVisible _ [] = False
isVisible n (x:xs) = all (<n) x || isVisible n xs

scenicScore :: Int -> [[Int]] -> Int
scenicScore _ [] = 1
scenicScore n (x:xs) = go x * scenicScore n xs
    where 
        go [] = 0
        go (y:ys)
            | y < n = 1 + go ys
            | otherwise = 1
