{-# LANGUAGE InstanceSigs #-}
import Data.Char ( digitToInt )
import Data.Map ( Map, insertWith, empty, (!?), fromAscList )
import Data.List ( sort )

data Monkey = Monkey
    { monkeyId :: Integer
    , items    :: [Integer]
    , op       :: Integer -> Integer
    , test     :: Integer -> Integer
    }

instance Show Monkey where
    show :: Monkey -> String
    show (Monkey id items _ _) = show id ++ ": " ++ show items

readArray :: String -> [Integer]
readArray =  map read . words . filter (/=',') . drop 18

readOperation :: String -> (Integer -> Integer)
readOperation str
    | l == r = (`mod` (13 * 11 * 19 * 17 * 3 * 7 * 5 * 2)) . square
    | otherwise = (`mod` (13 * 11 * 19 * 17 * 3 * 7 * 5 * 2)) . readOperator op (read r)
        where [l, op, r] = (words . drop 19) str

readOperator :: String -> (Integer -> Integer -> Integer)
readOperator "*" = (*)
readOperator "+" = (+)
readOperator _   = error "Not a monkey operator"

square :: Integer -> Integer
square n = n * n

readTest :: [String] -> (Integer -> Integer)
readTest (test:t:f:_) = \x -> if (x `mod` (read . drop 21) test) == 0 then toInteger (digitToInt (last t)) else toInteger (digitToInt (last f))
readTest xs = error ("Cant read monkey test " ++ show xs)

parseMonkey :: (Integer, [String]) -> Monkey
parseMonkey (n, _:arr:op:test) = Monkey {
    monkeyId = n,
    items    = readArray arr,
    op       = readOperation op,
    test     = readTest test
}
parseMonkey _ = error "Not a monkey"

parseInput :: Integer -> [String] -> [Monkey]
parseInput _ [] = []
parseInput n xs = parseMonkey (n, take 6 xs) : parseInput (n+1) (drop 7 xs)

parseInput' :: Integer -> [String] -> [[String]]
parseInput' _ [] = []
parseInput' n xs = take 6 xs : parseInput' 1 (drop 7 xs)

inspect :: Monkey -> (Integer, Map Integer [Integer])
inspect (Monkey id items op test) = (toInteger (length items), foldr (\x -> insertWith (++) (test (op x)) [op x]) (fromAscList [(id, [])]) items)

distribute :: Map Integer [Integer] -> [Monkey] -> [Monkey]
distribute im = map (\x -> catch (im !? monkeyId x) x)

catch :: Maybe [Integer] -> Monkey -> Monkey
catch Nothing m = m
catch (Just []) m = Monkey { monkeyId = monkeyId m, items = [], op = op m, test = test m}
catch (Just xs) m = Monkey { monkeyId = monkeyId m, items = items m ++ xs, op = op m, test = test m}

update :: Integer -> [Monkey] -> (Integer, [Monkey])
update n ms = let im = inspect (ms !! fromIntegral n) in (fst im, distribute (snd im) ms)

monkeyRound :: [Monkey] -> ([Integer], [Monkey])
monkeyRound ms = go 0 ms
    where
        go n xs
            | n == (length ms - 1) = let (l,r) = update (toInteger n) xs in ([l], r)
            | otherwise = let (l, r) = update (toInteger n) xs
                              (a,b) = go (n+1) r
                          in (l : a, b)

monkeyBusiness :: Integer -> [Monkey] -> [([Integer],[Monkey])]
monkeyBusiness n = go 0
    where
        go :: Integer -> [Monkey] -> [([Integer],[Monkey])]
        go m xs
            | m == n = []
            | otherwise = let mm = monkeyRound xs in mm : go (m+1) (snd mm)

solvePartOne :: [([Integer], [Monkey])] -> Integer
solvePartOne = product . take 2 . reverse . sort . foldr (addList . fst) [0,0,0,0,0,0,0,0]

monkeys :: [([Integer], [Monkey])] -> [[Monkey]]
monkeys = map snd

addList :: [Integer] -> [Integer] -> [Integer]
addList [] _ = []
addList _ [] = []
addList (x:xs) (y:ys) = (x + y) : addList xs ys

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . monkeyBusiness 10000 . parseInput 0 . lines $ fileContents
