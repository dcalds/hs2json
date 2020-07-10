module Main (main) where

import SimpleJSON
import Prettify
import PrettyJSON


value = renderJValue $ JObject [("nome", JString "Sergio Costa"), ("matricula", JNumber 123), ("status", JBool True)]
main :: IO ()
main = do
    putStrLn (pretty 10 value)