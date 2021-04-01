module Main

import Data.Nat
import Partial

%default total

pn : Nat -> Bool
pn n = n == 1000

testPred : (Nat -> Bool) -> Partial Nat
testPred p = testPredHelper p 0
  where
    testPredHelper : (Nat -> Bool) -> Nat -> Partial Nat
    testPredHelper p n = case p n of
      True  => Now n
      False => Later $ testPredHelper p $ n + 1

main : IO ()
main = do
  let res = testPred pn
  print res