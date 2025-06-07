module Pg where

import           Control.Monad              (void)
import qualified Data.ByteString.Char8      as BL8
import           Database.PostgreSQL.Simple
import           Row
import           System.Environment

connect :: IO Connection
connect = do
  connStr <- getEnv "DB_URL"
  conn <- connectPostgreSQL $ BL8.pack connStr
  return conn

insertRows :: Connection -> [Row] -> IO  ()
insertRows conn rows = void $
  executeMany
    conn
    "insert into grades values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    rows

disconnect :: Connection -> IO ()
disconnect conn = close conn
