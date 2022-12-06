
main :: IO()
main = do
       contents <- readFile "input.txt"
       print . solvePartOne $ contents
       print . solvePartTwo $ contents

solvePartOne :: String -> Int
solvePartOne = detectUnique 4

solvePartTwo :: String -> Int
solvePartTwo = detectUnique 14

detectMarker :: String -> Int
detectMarker = go 0
    where
        go n (w:x:y:z:xs) = if unique [w,x,y,z] then n + 4 else go (n+1) (x:y:z:xs)
        go _ _ = error "No marker found"

detectMessage :: String -> Int
detectMessage = go 0
    where
        go n (a:b:c:d:e:f:g:h:j:i:k:l:m:o:xs) = if unique [a,b,c,d,e,f,g,h,j,i,k,l,m,o] then n + 14 else go (n+1) (b:c:d:e:f:g:h:j:i:k:l:m:o:xs)
        go _ _ = error "No marker found"

detectUnique :: Int -> String -> Int
detectUnique n str
    | (unique . take n) str = n
    | otherwise = 1 + detectUnique n (drop 1 str)

unique :: [Char] -> Bool
unique [] = True
unique (x:xs) = notElem x xs && unique xs
