main :: IO ()
main = do
        contents <- readFile "input.txt"
        print . solvePartOne . parseInput . lines $ contents
        print . solvePartTwo . parseInput . lines $ contents

readInt :: String -> Int
readInt = read

parseInput :: [String] -> [[Int]]
parseInput [] = []
parseInput xs = map readInt (takeWhile (not . null) xs) : parseInput (drop 1 (dropWhile (not . null) xs))

solvePartOne :: [[Int]] -> Int
solvePartOne = maximum . map sum

solvePartTwo :: [[Int]] -> Int
solvePartTwo xs = fst' maxThree + snd' maxThree + thd maxThree
    where
        maxThree = maximumThree (map sum xs) (0, 0, 0)

maximumThree :: [Int] -> (Int, Int, Int) -> (Int, Int, Int)
maximumThree [] acc = acc
maximumThree (x:xs) acc = maximumThree xs (updateTopThree acc x)

fst' :: (a, a, a) -> a
fst' (a, _, _) = a

snd' :: (a, a, a) -> a
snd' (_, a, _) = a

thd :: (a, a, a) -> a
thd (_, _, a) = a

updateTopThree :: Ord a => (a, a, a) -> a -> (a, a, a)
updateTopThree (b, c, d) e
    | d > e  = (b, c, d)
    | c >= e = (b, c, e)
    | b >= e = (b, e, c)
    | otherwise  = (e, b, c)