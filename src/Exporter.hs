module Exporter where

import           Row

data ExporterHandle = ExporterHandle
  { ehExport :: [Row] -> IO ()
  }


stdoutExporter :: ExporterHandle
stdoutExporter = ExporterHandle print
