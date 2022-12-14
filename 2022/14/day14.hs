import qualified Data.Set as S
import Data.Char ( isDigit )
import Data.Maybe ( Maybe(Just), Maybe(Nothing), isNothing, fromJust )
import Data.List ( maximumBy )

type Coordinate = (Int, Int)
type Visited = S.Set Coordinate

insertAll :: Visited -> [Coordinate] -> Visited
insertAll = foldr S.insert

insertRockCoordinates :: Coordinate -> Coordinate -> Visited -> Visited
insertRockCoordinates (x,y) (w,z) v
    | x == w = insertAll v [(x,j) | j <- [(min y z)..(max y z)]]
    | otherwise = insertAll v [(i,y) | i <- [(min x w)..(max x w)]]

parseCoordinate :: String -> Coordinate
parseCoordinate str = (read . takeWhile isDigit $ str, read . takeWhile isDigit . drop 1 . dropWhile isDigit $ str)

parseRockPath :: String -> Visited -> Visited
parseRockPath [] v = v
parseRockPath str v = parseRockPath rem (insertRockCoordinates start end v)
    where
        start = parseCoordinate str
        rem   = drop 2 . dropWhile (/='>') $ str
        end   = if null rem then start else parseCoordinate rem

parseCave :: Visited -> [String] -> Visited
parseCave = foldr parseRockPath

flow :: Coordinate -> Int -> Visited -> Maybe Visited
flow c@(x,y) maxDepth v
    | y == maxDepth = Nothing
    | S.notMember (x, y+1) v   = flow (x, y+1) maxDepth v   -- straight down
    | S.notMember (x-1, y+1) v = flow (x-1, y+1) maxDepth v -- diagonal left
    | S.notMember (x+1, y+1) v = flow (x+1, y+1) maxDepth v -- diagonal right
    | otherwise = Just (S.insert c v)

flow' :: Coordinate -> Int -> Visited -> Maybe Visited
flow' c@(x,y) maxDepth v
    | S.member (500, 0) v  = Nothing
    | y == (maxDepth - 1) = Just (S.insert c v)
    | S.notMember (x, y+1) v   = flow' (x, y+1) maxDepth v   -- straight down
    | S.notMember (x-1, y+1) v = flow' (x-1, y+1) maxDepth v -- diagonal left
    | S.notMember (x+1, y+1) v = flow' (x+1, y+1) maxDepth v -- diagonal right
    | otherwise = Just (S.insert c v)

fillCave :: Int -> Visited -> Visited
fillCave maxDepth v
    | isNothing c = v
    | otherwise = fillCave maxDepth (fromJust c)
        where
            c = flow (500, 0) maxDepth v

fillCave' :: Int -> Visited -> Visited
fillCave' maxDepth v
    | isNothing c = v
    | otherwise = fillCave' maxDepth (fromJust c)
        where
            c = flow' (500, 0) maxDepth v

maxDepth :: Visited -> Int
maxDepth = snd . maximumBy (\x y -> compare (snd x) (snd y)) . S.elems

solvePartOne :: Visited -> Int
solvePartOne v = S.size (fillCave (maxDepth v) v) - S.size v

solvePartTwo :: Visited -> Int
solvePartTwo v = S.size (fillCave' (2 + maxDepth v) v) - S.size v

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . parseCave S.empty . lines $ fileContents
       print . solvePartTwo . parseCave S.empty . lines $ fileContents