import Data.List ( nub )

type Position = (Int, Int)

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

-- Should probably use a Set to prevent double storage in the first place
solvePartOne :: [String] -> Int
solvePartOne =  length . nub  . simulateRope [(0,0) | _ <- [0..1]] . concatMap parseMotion

solvePartTwo :: [String] -> Int
solvePartTwo =  length . nub . simulateRope [(0,0) | _ <- [0..9]] . concatMap parseMotion

-- This is a hack
parseMotion :: String -> [Motion]
parseMotion str = let parts = words str
                      d = head parts
                      n = (read . last) parts
                   in go 0 n d where go m n d = if m == n then [] else Motion {direction = d, amount = 1} : go (m+1) n d

simulateRope :: [Position] -> [Motion] -> [Position]
simulateRope _ [] = []
simulateRope ps (m:ms) = let nhead = move (head ps) m
                           in let (ntails, pos) = trail (nhead : tail ps) in pos : simulateRope (nhead : ntails) ms

move :: Position -> Motion -> Position
move (i, j) (Motion "R" a) = (i + a, j)
move (i, j) (Motion "L" a) = (i - a, j)
move (i, j) (Motion "U" a) = (i, j + a)
move (i, j) (Motion "D" a) = (i, j - a)
move _ _                   = error "Invalid motion"

update :: Position -> Position -> Position
update (i, j) (k, l)
    | abs dx == 1 && abs dy == 1    = (i,j)
    | dx /= 0 && dy /= 0            = update (i + signum dx, j + signum dy) (k,l)
    | dx == 0 && abs dy > 1         = update (i, j + signum dy) (k,l)
    | abs dx > 1 && dy == 0         = update (i + signum dx, j) (k,l)
    | otherwise                     = (i,j)
        where (dx, dy) = (k - i, l - j)

trail :: [Position] -> ([Position], Position)
trail [h, p] = let p' = update p h in ([p'], p')
trail (h:p:ps) = let (mp, seen) = trail (update p h : ps) in (update p h : mp, seen)
trail _ = error "Should never reach here"
