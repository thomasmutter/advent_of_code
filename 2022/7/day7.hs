import Data.Char ( isSpace )

data Dir a
    = Dir a [Dir a]
    | File String Int
    deriving (Show)

main :: IO()
main = do
       fileContents <- readFile "input.txt"
       print . solvePartOne . lines $ fileContents
       print . solvePartTwo . lines $ fileContents

solvePartOne :: [String] -> Int
solvePartOne = sum . filter (<100000) . dirSizes . rootDirectories

solvePartTwo :: [String] -> Int
solvePartTwo strs = minimum . filter (> minReq) . dirSizes . rootDirectories $ strs
    where
        minReq = requiredSpace (Dir "." (rootDirectories strs))

rootDirectories :: [String] -> [Dir String]
rootDirectories strs = contents "/" (jumpTo ("/", 0) 0 strs)

requiredSpace :: Dir String -> Int
requiredSpace d = dirSize d - 40000000

readInt :: String -> Int
readInt = read

jumpTo :: (String, Int) -> Int -> [String] -> (Int, [String])
jumpTo _ n [] = (n,[])
jumpTo (str, t) n (x:xs)
    | x == "$ cd .."                = jumpTo (str, t) (n - 1) xs
    | x == "$ cd " ++ str && t == n = (n, drop 1 xs)
    | take 4 x == "$ cd"            = jumpTo (str, t) (n + 1) xs
    | otherwise                     = jumpTo (str, t) n xs

contents :: String -> (Int, [String]) -> [Dir String]
contents _ (_, ('$':_):_)     = []
contents name (n, x:xs)       = (parseEntryParts xs n . dirEntryParts) x : contents name (n,xs)
contents _ (_,[])             = []

parseEntryParts :: [String] -> Int -> (String, String) -> Dir String
parseEntryParts con n (l, r)
    | l == "dir" = Dir r (contents r (jumpTo (r, n+1) (n+1) con))
    | otherwise  = File r (readInt l)

dirEntryParts :: String -> (String, String)
dirEntryParts str = let (l, r) = break isSpace str
                    in (l, drop 1 r)

dirSize :: Dir String -> Int
dirSize (File _ n) = n
dirSize (Dir _ []) = 0
dirSize (Dir _ ds) = (sum . map dirSize) ds

dirSizes :: [Dir String] -> [Int]
dirSizes ((Dir a b):ds) = (dirSize (Dir a b) : dirSizes ds) ++ dirSizes b
dirSizes ((File _ _):ds) = dirSizes ds
dirSizes [] = []
