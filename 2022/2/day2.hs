import System.Posix (LockRequest(ReadLock))
main :: IO()
main = do
       contents <- readFile "input.txt"
       print . solvePartOne . lines $ contents
       print . solvePartTwo . lines $ contents

data Shape
    = Rock
    | Paper
    | Scissors
    deriving (Show, Eq)

data Outcome
    = Win
    | Draw
    | Loss
    deriving (Show)

shapeScore :: Shape -> Int
shapeScore Rock     = 1
shapeScore Paper    = 2
shapeScore Scissors = 3

outcomeScore :: Outcome -> Int
outcomeScore Win  = 6
outcomeScore Draw = 3
outcomeScore Loss = 0

game :: (Shape, Shape) -> Outcome
game (a, b)
    | a == Scissors && b == Rock   = Win
    | a == Rock && b == Scissors   = Loss
    | shapeScore a < shapeScore b  = Win
    | shapeScore a == shapeScore b = Draw
    | otherwise                    = Loss

totalScore :: (Shape, Shape) -> Int
totalScore (a, b) = (outcomeScore . game) (a, b) + shapeScore b

decodeShape :: String -> Shape
decodeShape c
    | c == "A" || c == "X" = Rock
    | c == "B" || c == "Y" = Paper
    | c == "C" || c == "Z" = Scissors
    | otherwise = error "Invalid character in encoding"

decodeLine :: String -> (Shape, Shape)
decodeLine str = (head shapes, last shapes)
    where
        shapes = map decodeShape (words str)

solvePartOne :: [String] -> Int
solvePartOne = sum . map (totalScore . decodeLine)

determineShape :: (Shape, Outcome) -> Shape
determineShape (s, Draw) = s
determineShape (s, Win) = winningShape s
determineShape (s, Loss) = losingShape s

winningShape :: Shape -> Shape
winningShape Rock = Paper
winningShape Paper = Scissors
winningShape Scissors = Rock

losingShape :: Shape -> Shape
losingShape Rock = Scissors
losingShape Paper = Rock
losingShape Scissors = Paper

deducedShapes :: (Shape, Outcome) -> (Shape, Shape)
deducedShapes t = (fst t, ds)
    where
        ds = determineShape t

decodeOutcome :: String -> Outcome
decodeOutcome c
    | c == "X" = Loss
    | c == "Y" = Draw
    | c == "Z" = Win
    | otherwise = error "Invalid character in encoding"

decodeLine' :: String -> (Shape, Outcome)
decodeLine' str = ((decodeShape . head) d, (decodeOutcome . last) d)
    where
        d = words str

solvePartTwo :: [String] -> Int
solvePartTwo = sum . map (totalScore . deducedShapes . decodeLine')
