module Partial

%default total

public export
data Partial : Type -> Type where
  Now   : a               -> Partial a
  Later : Inf (Partial a) -> Partial a

export
Show a => Show (Partial a) where
  show (Now x)   = "Now " ++ show x
  show (Later _) = "Later ..."

export
Functor Partial where
  map f (Now x)   = Now   $ f x
  map f (Later x) = Later $ map f x

export
Applicative Partial where
  pure = Now

  Now f   <*> Now x   = Now   $ f x
  Later f <*> Now x   = Later $ f     <*> Now x
  Now f   <*> Later x = Later $ Now f <*> x
  Later f <*> Later x = Later $ f     <*> x

export
Monad Partial where
  Now x   >>= f = f x
  Later x >>= f = Later $ x >>= f

export
smashDown : Nat -> Partial a -> Maybe a
smashDown _     (Now x)   = Just x
smashDown 0     (Later x) = Nothing
smashDown (S n) (Later x) = smashDown n x