module DocVector
( frequencyWordDoc
, numDocPalabra
, freqDocInversa
, pesoEnDocumento
,pesosEnDocumento
) where

import Types
import Data.Array

frequencyWordDoc :: Documento -> String -> Int
frequencyWordDoc doc pal = foldl (\acc x -> if pal == x then acc + 1 else acc) 0 doc

numDocPalabra :: Corpus a -> String -> Int
numDocPalabra corp pal = foldl f 0 corp
    where f acc x
            | frequencyWordDoc x pal /= 0 = acc + 1
            | otherwise = acc

freqDocInversa :: Corpus a -> String -> Float
freqDocInversa corp pal = logBase 10 $ n / freqDocumental
    where n = fromIntegral(length corp)
          freqDocumental = fromIntegral(numDocPalabra corp pal)

pesoEnDocumento :: Corpus a -> String -> [Float]
pesoEnDocumento corp pal = map (* freqi) ls --listArray (1, n) ls'
    where ls = [fromIntegral(frequencyWordDoc x pal) | x <- corp]
          --n = length ls'
          freqi = freqDocInversa corp pal

pesosEnDocumento :: Corpus a -> Matriz Float
pesosEnDocumento corp = listaMatriz ls
    where ls = [pesoEnDocumento corp x | x <- (removeDuplicates2 (concat corp))]

listaMatriz :: Num a => [[a]] -> Matriz a
listaMatriz xss = listArray ((1,1),(m,n)) (concat xss)
    where m = length xss
          n = length (head xss)

--(\acc x -> if (frequencyWordDoc x pal) /= 0 then acc + 1 else acc)

representacionVectorial :: Corpus a -> Matriz a
representacionVectorial corp = undefined

removeDuplicates2 = foldl (\seen x -> if x `elem` seen
                                      then seen
                                      else seen ++ [x]) []
