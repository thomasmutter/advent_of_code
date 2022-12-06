
main :: IO()
main = do
       contents <- readFile "input.txt"
       print . solvePartOne $ contents
       print . solvePartTwo $ contents

solvePartOne :: String -> Int
solvePartOne = detectMarker

solvePartTwo :: String -> Int
solvePartTwo = detectMessage

detectMarker :: String -> Int
detectMarker = go 0
    where
        go n (w:x:y:z:xs) = if isMarker [w,x,y,z] then n + 4 else go (n+1) (x:y:z:xs)
        go _ _ = error "No marker found"

detectMessage :: String -> Int
detectMessage = go 0
    where
        go n (a:b:c:d:e:f:g:h:j:i:k:l:m:o:xs) = if isMarker [a,b,c,d,e,f,g,h,j,i,k,l,m,o] then n + 14 else go (n+1) (b:c:d:e:f:g:h:j:i:k:l:m:o:xs)
        go _ _ = error "No marker found"


isMarker :: [Char] -> Bool
isMarker [] = True
isMarker (x:xs) = notElem x xs && isMarker xs
