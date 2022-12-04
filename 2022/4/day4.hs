type Range = (Int, Int)

main :: IO()
main = do
       contents <- readFile "input.txt"
       print . solvePartOne . lines $ contents
       print . solvePartTwo . lines $ contents

solvePartOne :: [[Char]] -> Int
solvePartOne = length . filter (uncurry contains . mapTuple readRange . splitFirst ',')

solvePartTwo :: [[Char]] -> Int
solvePartTwo = length . filter (uncurry overlap' . mapTuple readRange . splitFirst ',')

readInt :: String -> Int
readInt = read

splitFirst :: Char -> [Char] -> ([Char], [Char])
splitFirst  _ [] = ([], [])
splitFirst c (x:xs)
    | c == x = ([], xs)
    | otherwise = (x : l, r)
        where
            (l, r) = splitFirst c xs

readRange :: String -> Range
readRange str = (readInt l, readInt r)
    where (l, r) = splitFirst '-' str

mapTuple :: (a -> b) -> (a, a) -> (b, b)
mapTuple f (x, y) = (f x, f y)

contains :: Range -> Range -> Bool
contains x y
    =  fst x <= fst y && snd x >= snd y
    || fst y <= fst x && snd y >= snd x

-- Check if a < c < b or c < a < d for pairs (a,b) and (c,d)
overlap :: Range -> Range -> Bool
overlap x y
    =  fst y >= fst x && fst y <= snd x
    || fst x >= fst y && fst x <= snd y

-- Use natural ordering and (b < c) or (d < a) for pairs (a,b) and (c,d) giving no overlap. Then use De Morgan's law to get not (no overlap) = overlap
overlap' :: Range -> Range -> Bool
overlap' x y = snd x >= fst y && snd y >= fst x
