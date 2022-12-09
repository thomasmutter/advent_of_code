import Data.List ( nub, elemIndices )

type Position = (Int, Int)

type Rope = [Position]
type Path = [Position]

data Motion = Motion
            { direction :: String
            , amount    :: Int
            }
            deriving (Show)

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . lines $ fileContents
       print . solvePartTwo . lines $ fileContents

solvePartOne :: [String] -> Int
solvePartOne =  length . nub . ((0,0):) . simulateRope ((0,0), (0,0)) . concatMap parseMotion'

solvePartTwo :: [String] -> Int
solvePartTwo =  length . nub . ((0,0):) . simulateRope' ([(0,0) | _ <- [1..9]], (0,0)) . concatMap parseMotion'

parseMotion :: String -> Motion
parseMotion str = let parts = words str in Motion { direction = head parts, amount = (read . last) parts }

parseMotion' :: String -> [Motion]
parseMotion' str = let parts = words str
                       d = head parts
                       n = (read . last) parts
                   in go 0 n d where go m n d = if m == n then [] else Motion {direction = d, amount = 1} : go (m+1) n d

simulateRope :: (Position, Position) -> [Motion] -> [Position]
simulateRope _ [] = []
simulateRope (ot, oh) (m:ms) = let nh = move oh m
                               in let pos = f ot nh in pos : simulateRope (pos, nh) ms

simulateRope' :: ([Position], Position) -> [Motion] -> [Position]
simulateRope' _ [] =[]
simulateRope' (otails, ohead) (m:ms) = let nhead = move ohead m
                                       in let (ntails, pos) = trail otails nhead in pos : simulateRope' (ntails, nhead) ms



dbg :: [Position] -> Position -> Motion -> [Position]
dbg ps p m = fst (trail ps (move p m))

dbgps :: [Position] -> Position -> Motion -> [[Position]]
dbgps ps h (Motion a b) = go 1
    where go n = if n > b then [] else dbg ps h (Motion a n) : go (n+1)

allPos :: [Position] -> Position -> [Motion] -> [[Position]]
allPos ps h [] = []
allPos ps h (m:ms) = dbgps ps h m ++ allPos (dbg ps h m) (move h m) ms

dodbg :: [Motion] -> String
dodbg ms = unlines (map drawGrid (allPos [(0,0) | _ <- [1..9]] (0,0) ms))

move :: Position -> Motion -> Position
move (i, j) (Motion "R" a) = (i + a, j)
move (i, j) (Motion "L" a) = (i - a, j)
move (i, j) (Motion "U" a) = (i, j + a)
move (i, j) (Motion "D" a) = (i, j - a)
move _ _                   = error "Invalid motion"

tailTrail :: Position -> Position -> (Position, [Position])
tailTrail (i, j) (k, l)
    | abs dx == 1 && abs dy == 1    = ((i,j), [])
    | dx /= 0 && dy /= 0    = let pos = (i + signum dx, j + signum dy) in let (p, ps) = tailTrail pos (k, l) in (p, pos : ps)
    | dx == 0 && abs dy > 1 = let pos = (i, j + signum dy) in let (p, ps) = tailTrail pos (k, l) in (p, pos : ps)
    | abs dx > 1 && dy == 0 = let pos = (i + signum dx, j) in let (p, ps) = tailTrail pos (k, l) in (p, pos : ps)
    | otherwise             = ((i,j), [])
        where (dx, dy) = (k - i, l - j)

f :: Position -> Position -> Position
f (i, j) (k, l)
    | abs dx == 1 && abs dy == 1    = (i,j)
    | dx /= 0 && dy /= 0            = f (i + signum dx, j + signum dy) (k,l)
    | dx == 0 && abs dy > 1         = f (i, j + signum dy) (k,l)
    | abs dx > 1 && dy == 0         = f (i + signum dx, j) (k,l)
    | otherwise                     = (i,j)
        where (dx, dy) = (k - i, l - j)

trail :: [Position] -> Position -> ([Position], Position)
trail [] _ = error "Should never reach here"
trail [p] h = let p' = f p h in ([p'], p')
trail (p:ps) h = let (mp, seen) = trail ps (f p h) in (f p h : mp, seen)

drawGrid :: [Position] -> String
drawGrid pos = concat ['\n' : concat [if (x,y) == (0,0) then "s" else if (x, y) `elem` pos then show (head (elemIndices (x,y) pos) + 1) else "." | x <- [-11..25]] | y <- [21, 20..(-5)]]

drawGrid' :: [Position] -> String
drawGrid' pos = concat ['\n' : concat [if (x, y) `elem` pos then "#" else "." | x <- [-11..25]] | y <- [21, 20..(-5)]]
