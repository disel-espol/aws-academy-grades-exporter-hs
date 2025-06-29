module Exporter.Postgres (exporter) where

import           Control.Exception
import           Control.Monad
import           Control.Monad.IO.Class     (liftIO)
import qualified Control.Monad.IO.Class
import           Data.Aeson                 (FromJSON)
import qualified Data.ByteString.Char8      as B8
import qualified Data.List                  as L
import           Data.String                (fromString)
import qualified Data.Text                  as T
import qualified Data.Text.IO               as TIO
import qualified Database.PostgreSQL.Simple as Pg
import           Exporter
import           GHC.Generics               (Generic)
import           Network.HTTP.Req
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

  rowsWithNames <- forM rows $ \row -> do
      sd <- fetchStudentNames row
      return (nombres sd : apellidos sd : row)

  let values :: Row -> Row = \row -> map (\c -> "'" <> (if T.null c then "0" else c) <> "'") row
  let insertValues = T.intercalate "," (map (\r -> "(" <> (T.intercalate "," . values $ r) <> ")") rowsWithNames)
  let q = fromString $ "insert into " <> tableName <> " values " <> fromString (T.unpack insertValues)

  void $ Pg.execute_ conn q
  where
    createTable =  do
      let tableName = "Students_Grades_" <> show (length rows)
      let cols = "\"Nombres\" text" : "\"Apellidos\" text" : zipWith (\ x s -> mconcat ["\"", s <> "_" <> T.pack (show x), "\" text"]) [1..] header
      let q =  fromString $ mconcat [ "create table if not exists ", tableName, " (" , L.intercalate "," (map T.unpack cols) , ")" ]
      void $ Pg.execute_ conn q
      return tableName

disconnect :: Pg.Connection -> IO ()
disconnect = Pg.close

data StudentData = MkStudentData
  { nombres   :: !T.Text
  , apellidos :: !T.Text
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON)


fetchStudentNames :: Control.Monad.IO.Class.MonadIO m => Row -> m StudentData
fetchStudentNames row = do
  let studentEmail =
        if "@espol.edu.ec" `T.isSuffixOf` head row
        then head row
        else head row <> "@espol.edu.ec"
  liftIO $ TIO.putStrLn $ "Fetching student names for: " <> studentEmail
  runReq defaultHttpConfig $ do
    r <- req
      GET
      (https "wsarchivos.espol.edu.ec" /: "api" /: "consultas" /: "persona" /: studentEmail)
      NoReqBody
      jsonResponse
      mempty
    return $ head (responseBody r :: [StudentData])






