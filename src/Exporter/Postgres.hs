module Exporter.Postgres (exporter) where

import           Control.Exception
import           Control.Monad
import qualified Data.ByteString.Char8      as B8
import qualified Data.List                  as L
import           Data.String                (fromString)
import qualified Data.Text                  as T
import qualified Data.Text.IO               as TIO
import qualified Database.PostgreSQL.Simple as Pg
import           Exporter
import           System.Environment
import           Types

-- | Exporter for storing data in a PostgreSQL database.
exporter :: ExporterHandle
exporter = ExporterHandle $ \header rows -> do
  bracket
    connect
    disconnect
    (\conn -> insertRows conn header rows)

connect :: IO Pg.Connection
connect = do
  connStr <- getEnv "DB_URL"
  Pg.connectPostgreSQL $ B8.pack connStr

insertRows :: Pg.Connection -> Header -> Rows -> IO  ()
insertRows conn header rows = do
  tableName <- createTable

  let values :: Row -> Row = \row -> map (\c -> "'" <> (if T.null c then "X" else c) <> "'") row
  let insertValues = T.intercalate "," (map (\r -> "(" <> (T.intercalate "," . values $ r) <> ")") rows)
  let q = fromString $ "insert into " <> tableName <> " values " <> fromString (T.unpack insertValues)

  void $ Pg.execute_ conn q
  where
    createTable =  do
      let tableName = "Students_Grades_" <> show (length rows)
      let cols = zipWith (\ x s -> mconcat ["\"", s <> "_" <> T.pack (show x), "\" text"]) [1..] header
      let q =  fromString $ mconcat [ "create table if not exists ", tableName, " (" , L.intercalate "," (map T.unpack cols) , ")" ]
      void $ Pg.execute_ conn q
      return tableName

disconnect :: Pg.Connection -> IO ()
disconnect = Pg.close














































































