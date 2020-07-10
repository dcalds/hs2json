import SimpleJSON

data Doc = ToBeDefined
         deriving (Show)
    
-- Casamento de Padrões para os tipos em JSON
renderJValue :: JValue -> Doc
renderJValue (JBool True)  = text "true"
renderJValue (JBool False) = text "false"
renderJValue JNull         = text "null"
renderJValue (JNumber num) = double num
renderJValue (JString str) = string str

-- Envolve uma expressão de valor Doc com caractere de abertura e fechamento
enclose :: Char -> Char -> Doc -> Doc
enclose left right x = char left <> x <> char right

-- Função equivalente ao operador ++
(<>) :: Doc -> Doc -> Doc
a <> b = undefined

hcat :: [Doc] -> Doc
hcat xs = undefined

char :: Char -> Doc
char c = undefined

string :: String -> Doc
string = enclose '"' '"' . hcat . map oneChar

text :: String -> Doc
text str = undefined

double :: Double -> Doc
double num = undefined

oneChar :: Char -> Doc
oneChar c = case lookup c simpleEscapes of
              Just r -> text r
              Nothing | mustEscape c -> hexEscape c
                      | otherwise    -> char c
    where mustEscape c = c < ' ' || c == '\x7f' || c > '\xff'

simpleEscapes :: [(Char, String)]
simpleEscapes = zipWith ch "\b\n\f\r\t\\\"/" "bnfrt\\\"/"
    where ch a b = (a, ['\\',b])

-- Expressão "point-free"
pointyString :: String -> Doc
pointyString s = enclose '"' '"' (hcat (map oneChar s))


smallHex :: Int -> Doc
smallHex x  = text "\\u"
           <> text (replicate (4 - length h) '0')
           <> text h
    where h = showHex x ""


astral :: Int -> Doc
astral n = smallHex (a + 0xd800) <> smallHex (b + 0xdc00)
    where a = (n `shiftR` 10) .&. 0x3ff
          b = n .&. 0x3ff

hexEscape :: Char -> Doc
hexEscape c | d < 0x10000 = smallHex d
            | otherwise   = astral (d - 0x10000)
  where d = ord c