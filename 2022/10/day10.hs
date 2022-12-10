import Data.List (intercalate)

parseProgram :: [String] -> [Int]
parseProgram [] = []
parseProgram (s:str) = let w = words s in if head w == "noop" then 0 : parseProgram str else 0 : read (last w) : parseProgram str

solvePartOne :: [Int] -> Int
solvePartOne cycles = sum [((*n) . sum . take n) cycles | n <- [20, 60..220]]

spritePosition :: Int -> [Int] -> [Int]
spritePosition c cycles = let mid = (sum . take c) cycles in [mid - 1, mid, mid + 1]

draw :: Int -> [Int] -> Char
draw cycle sprite
    | (cycle `mod` 40) `elem` sprite = '#'
    | otherwise = ' '

display :: [Int] -> [String]
display cycles = [[draw (40 * m + n) (spritePosition (40 * m + n + 1) cycles) | n <- [0..39]] | m <- [0..5]]

solvePartTwo :: [Int] -> String
solvePartTwo = intercalate "\n" . display

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . (1:) . parseProgram . lines $ fileContents
       putStrLn . solvePartTwo . (1:) . parseProgram . lines $ fileContents