{- 
    Made by Fanterox
    Github link: https://github.com/Fanterox
-}

import AsciiRender
import Reader
import System.IO

main :: IO()
main = do
    putStrLn "Please enter the name of the model you want to render"
    cmd <- getLine
    let archive   = "./Models/"++cmd++".obj"
    obj <- readFile archive
    let
        text      = filterLines obj
        move      = reCenter (vectorList text)
        list_vec3 = vec3List text move

    frameNum 0 list_vec3