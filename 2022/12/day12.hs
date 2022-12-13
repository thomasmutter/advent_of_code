import Data.Char ( ord )
import Data.Array ( Array, listArray, (!), bounds, elems )
import qualified Data.Set as Set ( Set, fromList, difference, union, map, delete, insert, elemAt, empty )
import qualified Data.Map as Map ( Map, findWithDefault, insert, fromList, map, filter, assocs )
import Data.List ( elemIndex, findIndex, elemIndices )
import Data.Maybe ( fromJust )

type Coordinate = (Int, Int)
type Elevation = Char
type HeightMap = Array Int (Array Int Elevation)

data Tracker = Tracker
    { queue      :: Set.Set Node
    , distance   :: Map.Map Coordinate Node
    , visited    :: Set.Set Coordinate
    } deriving ( Show )

data Node = Node
    { value :: Int
    , coordinate :: Coordinate
    , previous :: Coordinate
    } deriving ( Show )

instance Eq Node where
    (Node v1 c1 p1) == (Node v2 c2 p2) = v1 == v2 && c1 == c2 && p1 == p2

instance Ord Node where
    (Node e1 c1 p1) `compare` (Node e2 c2 p2) = (e1, c1, p1) `compare` (e2, c2, p2)

cost :: Char -> Char -> Int
cost s d
    | s == 'S' = 0
    | ord d - ord s == 1   = 1
    | d == s               = 2
    | ord d - ord s > 1    = maxBound `div` 2
    | otherwise            = abs (ord d - ord s) + 2

newCost :: HeightMap -> Coordinate -> Coordinate -> Int
newCost hm source dest = cost (elevationAt hm source) (elevationAt hm dest)

listToArray :: [a] -> Array Int a
listToArray list = listArray (0, length list - 1) list

parseHeightMap :: [String] -> HeightMap
parseHeightMap = listToArray . map listToArray

elevationAt :: HeightMap -> Coordinate -> Elevation
elevationAt hm (r, c) = (hm ! r) ! c

mapBounds :: HeightMap -> (Int, Int)
mapBounds hm = ((snd . bounds) hm, (snd . bounds) (hm ! 0))

neighbors :: HeightMap -> Coordinate -> [Coordinate]
neighbors hm (r, c) = let (rb, cb) = mapBounds hm
                      in filter (not . (\(x, y) -> x < 0 || y < 0 || x > rb || y > cb)) [(r, c+1), (r-1, c), (r, c-1), (r+1, c)]

getValue :: Map.Map Coordinate Node -> Coordinate -> Int
getValue m c = value (Map.findWithDefault (Node 0 (0,0) (0,0)) c m)

getNode :: Map.Map Coordinate Node -> Coordinate -> Node
getNode m c = Map.findWithDefault (Node 0 (0,0) (0,0)) c m

unvisited :: Tracker -> [Coordinate] -> Set.Set Node
unvisited (Tracker _ d v) cs = Set.map (getNode d) (Set.difference (Set.fromList cs) v)

uq :: HeightMap -> Tracker -> Coordinate -> Node -> Tracker
uq hm (Tracker q d v) c node
    | nc >= value node = Tracker { queue = q, distance = d, visited = v}
    | otherwise = Tracker { queue = (Set.insert Node { value = nc, coordinate = coordinate node, previous = c} . Set.delete node) q
                          , distance = Map.insert (coordinate node) (Node nc (coordinate node) c ) d
                          , visited = v
                          }
        where nc = getValue d c + newCost hm c (coordinate node)

uq' :: HeightMap -> Tracker -> Coordinate -> Node -> Tracker
uq' hm (Tracker q d v) c node
    | nc >= value node = Tracker { queue = q, distance = d, visited = v}
    | otherwise = Tracker { queue = (Set.insert Node { value = nc, coordinate = coordinate node, previous = c} . Set.delete node) q
                          , distance = Map.insert (coordinate node) (Node nc (coordinate node) c ) d
                          , visited = v
                          }
        where nc = getValue d c + newCost hm (coordinate node) c

updateQueue :: HeightMap -> Tracker -> Coordinate -> Set.Set Node -> Tracker
updateQueue hm t c = foldr (\x acc -> uq hm acc c x) t

updateQueue' :: HeightMap -> Tracker -> Coordinate -> Set.Set Node -> Tracker
updateQueue' hm t c = foldr (\x acc -> uq' hm acc c x) t

findPath :: HeightMap -> Tracker -> Tracker
findPath hm t
    | null (queue t) = t
    | otherwise = let node = (Set.elemAt 0 . queue) t
                      nb = (unvisited t . neighbors hm) (coordinate node)
                      ut = updateQueue hm t (coordinate node) nb
                  in findPath hm (Tracker { queue = Set.delete node (queue ut), distance = distance ut, visited = Set.insert (coordinate node) (visited ut) })

findPath' :: HeightMap -> Tracker -> Tracker
findPath' hm t
    | elevationAt hm (coordinate ((Set.elemAt 0 . queue) t )) == 'a' = t
    | otherwise = let node = (Set.elemAt 0 . queue) t
                      nb = (unvisited t . neighbors hm) (coordinate node)
                      ut = updateQueue' hm t (coordinate node) nb
                  in findPath' hm (Tracker { queue = Set.delete node (queue ut), distance = distance ut, visited = Set.insert (coordinate node) (visited ut) })

initialTracker :: (Int, Int) -> Coordinate -> Tracker
initialTracker (r, c) co = Tracker { queue = Set.insert (Node {value = 0, coordinate = co, previous = co}) (Set.delete (Node {value = maxBound, coordinate = co, previous = co }) (Set.fromList [ Node { value = maxBound `div` 2, coordinate = (x,y), previous = (x,y)} | x <- [0..r], y <- [0..c]]))
, distance = Map.insert co (Node 0 co co) (Map.fromList [((x,y), Node maxBound (x,y) (x,y)) | x <- [0..r], y <- [0..c]])
, visited = Set.empty
}

path' :: HeightMap -> Coordinate -> Tracker -> String
path' hm co t
    | nc == co = []
    | otherwise = elevationAt hm nc : path' hm nc t
        where nc = previous (getNode (distance t) co)

findElement :: Char -> HeightMap -> (Int, Int)
findElement c hm = let row = (fromJust . findIndex (elem c ) . map elems) (elems hm)
             in (row,  (fromJust . elemIndex c . elems) (hm ! row))

bs :: HeightMap -> [(Int, Int)]
bs hm = [(x,1) | x <- [0..((fst . mapBounds) hm)]]

findA :: Tracker -> (Int, Int)
findA t = coordinate ((Set.elemAt 0 . queue) t )

solvePartOne :: HeightMap -> Int
solvePartOne hm = length (path' hm (findElement '{' hm) (findPath hm (initialTracker (mapBounds hm) (findElement 'S' hm))))

solvePartOne' :: HeightMap -> Int
solvePartOne' hm = let a = findPath' hm (initialTracker (mapBounds hm) (findElement '{' hm))
                   in length (path' hm (findA a) a)

solvePartTwo :: HeightMap -> Int
solvePartTwo hm = 1 + minimum [length (path' hm (findElement '{' hm) (findPath hm (initialTracker (mapBounds hm) bco))) | bco <- bs hm]

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . parseHeightMap . lines $ fileContents
       print . solvePartOne' . parseHeightMap . lines $ fileContents
