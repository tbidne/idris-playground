module Main

import Data.Nat
import Partial
import CoIO

%default total

pn : Nat -> Bool
pn n = n == 20000

testPred : (Nat -> Bool) -> Partial Nat
testPred p = testPredHelper p 0
  where
    testPredHelper : (Nat -> Bool) -> Nat -> Partial Nat
    testPredHelper p n = case p n of
      True  => Now n
      False => Later $ testPredHelper p $ n + 1

multipleThousand : Nat -> Bool
multipleThousand n = mod n 1000 == 0

-- TODO: Unfortunately, this doesn't actually print out the
-- log messages in "real time". Our CoIO value is built up
-- then all the messages are dumped at the same time in
-- unsafeCoIOToIO.
coioPred : Nat -> Partial Nat -> CoIO ()
coioPred _ (Now x) = ioToCoIO $ putStrLn $ "Found solution: " ++ show x
coioPred counter (Later xs) =
  let progress = if multipleThousand counter
        then putStrLn $ "Searched up to: " ++ show counter
        else pure ()
  in CoIOCons progress (coioPred (counter + 1) xs)

partial
main : IO ()
main = do
  let res = coioPred 0 $ testPred pn
  unsafeCoIOToIO res