import Data.Char ( isDigit )
import Data.List ( sort, elemIndex )
import Data.Maybe ( fromJust )

data Packet
    = Packet [Packet]
    | Single Int
    deriving ( Show )

instance Eq Packet where
    Packet ps == Packet qs = ps == qs
    Single n  == Packet ps = Packet [Single n] == Packet ps
    Packet ps == Single n = Packet ps == Packet [Single n]
    Single n == Single m = n == m

instance Ord Packet where
    Packet ps `compare` Packet qs = ps `compare` qs
    Single n `compare` Packet ps = Packet [Single n] `compare` Packet ps
    Packet ps `compare` Single n = Packet ps `compare` Packet [Single n]
    Single n `compare` Single m = n `compare` m

readPacket :: String -> [Packet]
readPacket [] = []
readPacket (x:xs)
    | x == '[' = let (l, r) = readList' (x:xs) in Packet (readPacket l) : readPacket r
    | x == ',' = readPacket xs
    | isDigit x = let (s, str) = readSingle (x:xs) in s : readPacket str
    | otherwise = readPacket xs

readList' :: String -> (String, String)
readList' str = go 0 (drop 1 str)
    where
        go :: Int -> [Char] -> (String, String)
        go _ [] = error "Packet must always end with ]"
        go n (x:xs)
            | n == 0 && x == ']' = ([], xs)
            | x == '[' = let (l, r) = go (n+1) xs in (x : l, r)
            | x == ']' = let (l, r) = go (n-1) xs in (x : l, r)
            | otherwise = let (l, r) = go n xs in (x : l, r)

readSingle :: String -> (Packet, String)
readSingle str = ((Single . read . takeWhile isDigit) str, dropWhile isDigit str)

parseInput :: [String] -> [(Int, [Packet])]
parseInput str = zip [1..(length str `div` 2)] ((group 2 . map (head . readPacket)) str)

group :: Int -> [a] -> [[a]]
group _ [] = []
group n xs = l : group n r
    where
        (l,r) = splitAt n xs

isSorted :: Ord a => [a] -> Bool
isSorted [] = True
isSorted [x] = True
isSorted (x:y:xs) = (x <= y) && isSorted (y:xs)

solvePartOne :: [(Int, [Packet])] -> Int
solvePartOne = sum . map fst . filter (\(_, ps) -> isSorted ps)

findDecoderPackets :: [Packet] -> [Int]
findDecoderPackets ps = [1 + (fromJust . elemIndex (Packet [Packet [Single 2]])) ps, 1 + (fromJust . elemIndex (Packet [Packet [Single 6]])) ps]

solvePartTwo :: [String] -> Int
solvePartTwo = product . findDecoderPackets . sort . map (head . readPacket)

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . parseInput . filter (not . null) . lines $ fileContents
       print . solvePartTwo . filter (not . null) . lines $ fileContents
