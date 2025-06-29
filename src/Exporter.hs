module Exporter (ExporterHandle(..)) where

import           Types

data ExporterHandle = ExporterHandle
  { ehExport :: Header -> Rows -> IO ()
  }



