{- 
    Made by Fanterox
    Github link: https://github.com/Fanterox
-}
module Reader (filterLines,vectorList,reCenter,vec3List,frameNum)where
import AsciiRender
import System.IO
import Data.Char
import Data.List
import Data.List.Split
import Control.Concurrent
import Control.Monad

--There may be an easier and more efficient way to do this, i would not know


--Transformation functions

strToInt :: [String] -> [Int]
strToInt input = map(read) input

strToFloat :: [String] -> [Float]
strToFloat input = map(read) input

floatToVec3 :: [Float] -> [Vec3]
floatToVec3 [x,y,z] = [(x,y,z)]

vec3ToTriangle :: [Vec3] -> [Triangle]
vec3ToTriangle [x,y,z] = [Triangle x y z Norm]

--only search function.... i think
findItem :: [Vec3] -> [Int] -> [Vec3]
findItem list_v [x,y,z] = [list_v !! (x-1), list_v !! (y-1), list_v !! (z-1)]


-- Model altering functions

toOrigin :: [Float] -> [Float] -> [Float]
toOrigin [x1, y1, z1] [x2, y2, z2] = [x2 - x1, y2 - y1, z2 - z1]

scaleDown :: Float -> [Float] -> Vec3
scaleDown ratio [x,y,z] = ( (x/(2*ratio)), 0.5 - (y/(2*ratio)), z/(2*ratio) )

--This function will give us the center of the bounding bos of the model
modelCenter :: [String] -> [Float]
modelCenter input = 
    let
        simplify  = map(words) input
        simplify2 = map(strToFloat) simplify
        --Lists to use
        list_yz   = map(tail) simplify2
        list_x    = map(head) simplify2
        list_y    = map(head) list_yz
        list_z    = map(last) list_yz
        --Max and Min values of x,y,z
        max_x     = maximum list_x
        min_x     = minimum list_x
        max_y     = maximum list_y
        min_y     = minimum list_y
        max_z     = maximum list_z
        min_z     = minimum list_z
        result    = [(max_x + min_x)/2, (max_y + min_y)/2, (max_z + min_z)/2]
    in result

reCenter :: [String] -> [Vec3]
reCenter input = 
    let
        simplify  = map(words) input
        simplify2 = map(strToFloat) simplify
        --get model center vector
        center    = modelCenter input
        --move all model vectors to the center
        move      = map(toOrigin center) simplify2
        --turn to Vec3
        converted = map(floatToVec3) move
        list_1    = concat converted
        scale     = maximum(map(mag)list_1)
        result    = map(scaleDown scale) move
    in result

{- 
    We want to get only the lines that begin with either 'v ' or 'f'
    so this function does just that, gets the file as a string and returns
    a string that has the verices and faces from the object file
-}

filterLines :: String -> String
filterLines input = 
    let
        simplify  = map(words) (lines input)
        remover   = filter(\x -> null x /= True)simplify --Removes the empty lists from simplify
        simplify2 = map(unwords) remover
        --We want to get only the 'v ' and 'f' lines from the file
        separator = filter(\line -> head line == 'v' && head (tail line) == ' ' || head line == 'f')simplify2
        list_1    = map(words) separator
        place_1   = map(map(splitOneOf "/")) list_1
        place_2   = map(map(head)) place_1
        place_3   = map(unwords) place_2
        result    = unlines place_3
    in result

--Triangulates faces with more than 3 vertices
triangulateF :: [String] -> [[Int]]
triangulateF input = 
    let
        int_list = strToInt input
        list_1   = [[head input] ++ tail(tail input)]
        list_2   = [head int_list, head(tail int_list), head(tail(tail int_list))]
        list_3   = concat(map(triangulateF) list_1)
        list_4   = [list_2] ++ list_3
    in if length int_list > 3
        then list_4
        else [int_list]


-- Lets us separate the vectors from the filtered text and put them in a list 
vectorList :: String -> [String]
vectorList input =
    let
        simplify = lines input
        separate = filter(\line -> head line == 'v') simplify

        list_1   = map(words) separate
        list_2   = map(drop 1) list_1
        result   = map(unwords) list_2
    in result

--Lets us separate the faces from the filtered text and put them in a list
facesList :: String -> [String]
facesList input =
    let
        simplify = lines input
        separate = filter(\line -> head line == 'f') simplify

        list_1   = map(words) separate
        list_2   = map(drop 1) list_1
        result   = map(unwords) list_2
    in result

--Yes, i know those 2 are practically the same function, but hey, it works

--This is gonna give us a list of all the faces turned into Vec3
vec3List :: String -> [Vec3] -> [[Vec3]]
vec3List input v_list =
    let
        face_list = facesList input
        simplify  = map(words) face_list
        list_1    = map(triangulateF) simplify
        list_2    = map(map(findItem v_list)) list_1
        result    = concat list_2
    in result

triangleList :: [[Vec3]] -> [Triangle]
triangleList input =
    let
        simplify = map(vec3ToTriangle) input
        result   = concat simplify
    in result

frameNum :: Int -> [[Vec3]] -> IO()
frameNum frame triangles = do
    let
        t             = fromIntegral frame
        angle         = (0.4 + 0.8*cos(t/15))
        -- Rotations
        rot_y         = map(map(rotateY (t*0.1))) triangles
        -- Triangle list that will be used in the render function
        triangle_list = triangleList rot_y
    -- The amount of space for the image in the terminal will be 60x35, this can be modified if needed
    image <- putStrLn $ render 60 35 triangle_list
    threadDelay 60000
    
    return (putStrLn "\x1b[H")
    return image
    frameNum (frame + 1) triangles