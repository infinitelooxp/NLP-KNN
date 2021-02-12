module Knn
( obtieneDistancia
, obtieneClaseMayoritaria
, obtieneListasClases
, obtieneClasesMayoritarias
, obtienePrecision
) where

import Types
import DocVector as Dv
import Data.List (sortBy)
import Data.Function (on)
import Data.Array

obtieneDistancia :: (Ord a, Floating a) => Matriz a -> Matriz a -> [[(Int,a)]]
obtieneDistancia xtrain xtest = [simDoc xtrain (colMat i xtest) | i <- [1..snd(snd(bounds xtest))]]

simDoc :: (Ord a, Floating a) => Matriz a -> Vector a -> [(Int,a)]
simDoc train doc = ordenaPorSegundoElemento d
        where sim = [similitud (colMat i train) doc | i <- [1..columnas]]
              d = zip [1..columnas] sim
              columnas = snd(snd(bounds train))

--obtieneVecinos corp doc = ordenaPorSegundoElemento tuplas
--        where matriz = Dv.pesosEnDocumento corp
--              ls = matrizLista matriz
--              lss = map (\i -> prodEscalar (listaVector i) (listaVector doc)) ls
--              tuplas = zip corp lss

obtieneListasClases :: (Ord a, Floating a) => Matriz a -> Matriz a -> [Int] -> [[Int]]
obtieneListasClases xtrain xtest ytrain = [take 5 $ obtieneClases xtrain (colMat i xtest) ytrain | i <- [1..snd(snd(bounds xtest))]]

obtieneClases :: (Ord a, Floating a) => Matriz a -> Vector a -> [Int] -> [Int]
obtieneClases pesos doc ytrain = [ytrain!!(j-1) | j <- pr]
      where pr = [fst p | p <- sim]
            --sim = [similitud (colMat i pesos) doc | i <- [1..columnas]]
            sim = simDoc pesos doc
            --d = zip [1..columnas] sim
            --columnas = snd(snd(bounds pesos))


obtieneClaseMayoritaria :: [Int] -> Int
obtieneClaseMayoritaria ls = if uncurry (>) tupla then 0 else 1
      where tupla = foldl (\(j,k) x -> if x == 1 then (j,k+1) else (j+1,k)) (0,0) ls

obtieneClasesMayoritarias :: [[Int]] -> [Int]
obtieneClasesMayoritarias lss = map obtieneClaseMayoritaria lss

ordenaPorSegundoElemento :: Ord b => [(a, b)] -> [(a, b)]
ordenaPorSegundoElemento = sortBy (flip compare `on` snd)

obtienePrecision :: [Int] -> [Int] -> Float
obtienePrecision resultados ytrain = (fromIntegral a) / (fromIntegral b)
      where b = length ytest
            zipped = zip resultados ytest
            a = foldl (\acc x -> if uncurry (==) x then acc + 1 else acc) 0 zipped

similitud :: (Floating a, Eq a) => Vector a -> Vector a -> a
similitud v1 v2
    | b == 0 = 0.0
    | otherwise = a/b
    where a = sum [i*j | (i,j) <- zip (elems v1) (elems v2)]
          b = sqrt(sum [i^2 | i <- elems v1]) * sqrt(sum [i^2 | i <- elems v2])

colMat :: Num a => Int -> Matriz a -> Vector a
colMat m p = listaVector [p!(i, m) | i <- [1..numFilas p]]

numFilas m = fst(snd(bounds m))