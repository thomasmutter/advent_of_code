import Data.IntMap (IntMap, fromAscList, (!), insert, insertWith, mapAccum)
import Data.Char (isAlpha, isNumber)

type Stacks = IntMap [Char]
data MoveStep = MoveStep {
    quantity :: Int,
    source   :: Int,
    target   :: Int
} deriving (Show)

main :: IO()
main = do
       contents <- readFile "input.txt"
       print (solvePartOne (mapTuple (initialStacks (indexPositions 9)) (map (parseMoveStep . parseInstruction)) (listToTuple . parseInput . lines $ contents)))
       print (solvePartTwo (mapTuple (initialStacks (indexPositions 9)) (map (parseMoveStep . parseInstruction)) (listToTuple . parseInput . lines $ contents)))

solvePartOne :: (Stacks, [MoveStep]) -> String
solvePartOne (stacks, steps) = topCrates (rearrange steps stacks)

solvePartTwo :: (Stacks, [MoveStep]) -> String
solvePartTwo (stacks, steps) = topCrates (rearrange' stacks steps)

readInt :: String -> Int
readInt = read

mapTuple :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
mapTuple f g (x, y) = (f x, g y)

parseInput :: [String] -> [[String]]
parseInput [] = []
parseInput xs = takeWhile (not . null) xs : parseInput (drop 1 (dropWhile (not . null) xs))

listToTuple :: [a] -> (a,a)
listToTuple [] = error "Not enough elements"
listToTuple [x] = error "Not enough elements"
listToTuple (x:y:_) = (x,y)

indexOf :: Int -> Int
indexOf n = n + 3 * (n - 1)

indexPositions :: Int -> IntMap Int
indexPositions n = fromAscList  [(indexOf x, x)| x <- [1..n]]

initialStacks :: IntMap Int -> [String] -> Stacks
initialStacks _ [] = fromAscList [(x,[]) | x <- [1..9]]
initialStacks pos (x:xs) = addCratesFromRow x pos stacks
    where
        stacks = initialStacks pos xs

addCratesFromRow :: String -> IntMap Int -> Stacks -> Stacks
addCratesFromRow [] _ stacks = stacks
addCratesFromRow str pos stacks = go 0 str
    where
        go _ [] = stacks
        go n (c:cs)
            | isAlpha c = insert (pos ! n) (c : (stacks ! (pos ! n))) (go (n+1) cs)
            | otherwise = go (n+1) cs

parseInstruction :: String -> [Int]
parseInstruction [] = []
parseInstruction str =  readInt number : parseInstruction rest
    where
        (number, rest) = span isNumber (dropWhile (not . isNumber) str)

parseMoveStep :: [Int] -> MoveStep
parseMoveStep [] = error "not enough elements"
parseMoveStep [x] = error "not enough elements"
parseMoveStep [x,y] = error "not enough elements"
parseMoveStep (x:y:z:_) = MoveStep {
    quantity = x,
    source = y,
    target = z
}

move :: (Int, [Char]) -> Int -> Stacks -> Stacks
move (_, []) _ stacks = stacks
move (source, c:cs) target stacks = let
    removed = insert source cs stacks
    in insert target (c : (stacks ! target)) removed

moveQuantity :: Int -> Int -> Int -> Stacks -> Stacks
moveQuantity q s t stacks = let
    source = (stacks ! s)
    target = (stacks ! t)
    in insert t (take q source ++ target) (insert s (drop q source) stacks)

rearrange :: [MoveStep] -> Stacks -> Stacks
rearrange [] stacks = stacks
rearrange (m:ms) stacks = rearrange ms (go 0 stacks)
    where
        go n s
            | n == quantity m = s
            | otherwise = go (n+1) (move (keyValue (source m) s) (target m) s)

rearrange' :: Stacks -> [MoveStep] -> Stacks
rearrange' = foldl (\ stacks m -> moveQuantity (quantity m) (source m) (target m) stacks)

keyValue :: Int -> Stacks -> (Int, [Char])
keyValue n stacks = (n, stacks ! n)

topCrates :: Stacks -> String
topCrates = let f a b = head a : b
            in foldr f []
