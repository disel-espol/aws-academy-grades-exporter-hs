module Main where

import qualified Data.ByteString.Lazy.Char8 as BL8
import           Data.Csv
import qualified Data.Vector                as V
import qualified Options
import           Row
import           System.IO                  (readFile')

readRows :: FilePath -> IO [Row]
readRows fileName = do
  contents <- readFile' fileName
  case decode HasHeader $ BL8.pack contents of
    Left err -> error err
    Right v  -> return $ V.toList v

main :: IO ()
main = do
  opts <- Options.parseOpts
  rows <- readRows (Options.optFile opts)
  print rows
