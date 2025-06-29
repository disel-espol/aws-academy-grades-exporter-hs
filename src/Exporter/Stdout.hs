module Exporter.Stdout (exporter) where

import           Control.Monad
import qualified Data.Text     as T
import qualified Data.Text.IO  as TIO
import           Exporter

-- | Exporter for printing data to standard output.
exporter :: ExporterHandle
exporter = ExporterHandle $ \header rs -> do
  TIO.putStrLn $ "Header: " <> T.intercalate "\t" header
  forM_ rs $ \row -> do
    TIO.putStrLn $ T.intercalate "\t" row




