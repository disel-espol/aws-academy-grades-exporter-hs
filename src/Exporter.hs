module Exporter where

import           Control.Exception
import qualified Pg
import           Row

data ExporterHandle = ExporterHandle
  { ehExport :: [Row] -> IO ()
  }


stdoutExporter :: ExporterHandle
stdoutExporter = ExporterHandle print

postgresExporter :: ExporterHandle
postgresExporter = ExporterHandle $ \rows -> do
  bracket
    (Pg.connect)
    (Pg.disconnect)
    (\conn -> Pg.insertRows conn rows)

