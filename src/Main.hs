module Main where

import qualified Data.Text         as T
import qualified Data.Text.IO      as TIO
import           Exporter
import qualified Exporter.Postgres as Postgres
import qualified Exporter.Stdout   as Stdout
import qualified Options
import           Types

readRows :: FilePath -> IO (Header, Rows)
readRows fileName = do
  contents <- TIO.readFile fileName
  let (header, contents') = T.breakOn "\n" contents
  let header' = T.splitOn "," header
  let rows = map (T.splitOn ",") (drop 1 $ T.lines contents')
  return (header', rows)

doExport :: Options.Dest -> Header -> Rows -> IO ()
doExport Options.Postgres header rows = Exporter.ehExport Postgres.exporter header rows
doExport Options.Stdout   header rows = Exporter.ehExport Stdout.exporter header rows

main :: IO ()
main = do
  opts <- Options.parseOpts
  (header, rows) <- readRows (Options.optFile opts)
  doExport (Options.optDest opts) header rows





















