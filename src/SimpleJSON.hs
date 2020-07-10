module SimpleJSON where

data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String, JValue)]
            | JArray [JValue]
              deriving (Eq, Ord, Show)

-- Rode o comando: 
-- $ stack ghci

getString :: JValue -> Maybe String
getString (JString s) = Just s
getString _           = Nothing