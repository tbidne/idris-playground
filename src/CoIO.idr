module CoIO

import Data.Stream
import Partial

%default total

public export
data CoIO : Type -> Type where
  CoIOSing : IO a -> CoIO a
  CoIOCons : IO a -> Inf (CoIO a) -> CoIO a

export
ioToCoIO : IO a -> CoIO a
ioToCoIO = CoIOSing

export partial
unsafeCoIOToIO : CoIO a -> IO a
unsafeCoIOToIO (CoIOSing io) = io
unsafeCoIOToIO (CoIOCons io ios) = io *> unsafeCoIOToIO ios

partial
bindCoIO : CoIO a -> (a -> CoIO b) -> CoIO b
bindCoIO (CoIOSing io) f = CoIOSing $ io >>= (unsafeCoIOToIO . f)
bindCoIO (CoIOCons io ios) f = CoIOCons (io >>= unsafeCoIOToIO . f) (bindCoIO ios f)

partial
joinIOs : IO (CoIO a) -> IO a
joinIOs = join . map unsafeCoIOToIO

partial
joinCoIO : CoIO (CoIO a) -> CoIO a
joinCoIO (CoIOSing io) = CoIOSing (joinIOs io)
joinCoIO (CoIOCons io ios) = CoIOCons (joinIOs io) (joinCoIO ios)

export
Functor CoIO where
  map f (CoIOSing io)    = CoIOSing $ map f io
  map f (CoIOCons io ios) = CoIOCons (map f io) $ map f ios

export
Applicative CoIO where
  pure = CoIOSing . pure

  CoIOSing f    <*> CoIOSing io     = CoIOSing (f <*> io)
  CoIOSing f    <*> CoIOCons io ios = CoIOCons (f <*> io) (CoIOSing f <*> ios)
  CoIOCons f fs <*> CoIOSing io     = CoIOCons (f <*> io) (fs <*> CoIOSing io)
  CoIOCons f fs <*> CoIOCons io ios = CoIOCons (f <*> io) (fs <*> ios)

export partial
Monad CoIO where
  (>>=) = bindCoIO
  join = joinCoIO

export
mapStream : Stream a -> (a -> IO a) -> CoIO a
mapStream (x :: xs) f = CoIOCons (f x) (mapStream xs f)