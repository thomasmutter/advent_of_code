import Data.Char (ord, isUpper)
import Data.Set (Set, member, fromList, intersection, elems)

main :: IO()
main = do
       contents <- readFile "input.txt"
       print . solvePartOne . lines $ contents
       print . solvePartTwo . lines $ contents

solvePartOne :: [[Char]] -> Int
solvePartOne = sum . map (priority .  doublyPackedEntry . compartments)

solvePartTwo :: [[Char]] -> Int
solvePartTwo = sum . map (priority . findBadge) . elveGroups

elveGroups :: [[Char]] -> [[Set Char]]
elveGroups [] = []
elveGroups xs = group 3 (map fromList xs)

group :: Int -> [a] -> [[a]]
group _ [] = []
group n xs = l : group n r
    where
        (l,r) = splitAt n xs

compartments :: [Char] -> ([Char], Set Char)
compartments str =
    let (l, r) = splitHalf str
    in (l, fromList r)

splitHalf :: [Char] -> ([Char], [Char])
splitHalf str = splitAt (length str `div` 2) str

doublyPackedEntry :: ([Char], Set Char) -> Char
doublyPackedEntry ([], _) = error "No double entry found"
doublyPackedEntry (x:xs, set)
    | member x set = x
    | otherwise = doublyPackedEntry (xs, set)

findBadge :: [Set Char] -> Char
findBadge [] = error "No badge found"
findBadge [x] = (head . elems) x
findBadge (x:y:xs) = findBadge (intersection x y : xs)

priority :: Char -> Int
priority c
    | isUpper c =  ord c - 38
    | otherwise = ord c - 96
    