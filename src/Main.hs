module Main where

import qualified Data.ByteString.Lazy.Char8 as BL8
import           Data.Csv
import qualified Data.Vector                as V
import           Exporter
import qualified Options
import           Row
import           System.IO                  (readFile')

readRows :: FilePath -> IO [Row]
readRows fileName = do
  contents <- readFile' fileName
  case decode HasHeader $ BL8.pack contents of
    Left err -> error err
    Right v  -> return $ V.toList v

doExport :: Options.Dest -> [Row] -> IO ()
doExport Options.Postgres rows = Exporter.ehExport postgresExporter $ rows
doExport Options.Stdout rows   = Exporter.ehExport stdoutExporter $ rows

main :: IO ()
main = do
  opts <- Options.parseOpts
  rows <- readRows (Options.optFile opts)
  doExport (Options.optDest opts) rows
