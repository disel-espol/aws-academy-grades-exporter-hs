module Pg where

import           Control.Monad              (forM, void)
import           Data.Aeson                 (FromJSON)
import qualified Data.ByteString.Char8      as BL8
import           Data.List                  (isSuffixOf)
import qualified Data.Text                  as T
import           Database.PostgreSQL.Simple
import           GHC.Generics               (Generic)
import           Network.HTTP.Req
import           Row
import           System.Environment

connect :: IO Connection
connect = do
  connStr <- getEnv "DB_URL"
  conn <- connectPostgreSQL $ BL8.pack connStr
  return conn

data StudentData = MkStudentData
  { nombres   :: !String
  , apellidos :: !String
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON)

insertRows :: Connection -> [Row] -> IO  ()
insertRows conn rows = do
  void $ executeMany
    conn
    "insert into grades values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    rows

  students <- forM rows $ \row -> do
    -- TODO: Should do this in parallel.
    let studentEmail = getStudentEmail row

    runReq defaultHttpConfig $ do
      r <- req
        GET
        (https "wsarchivos.espol.edu.ec" /: "api" /: "consultas" /: "persona" /: (T.pack studentEmail))
        NoReqBody
        jsonResponse
        mempty

      return $ head $ map (\sd -> (studentEmail, nombres sd, apellidos sd)) (responseBody r :: [StudentData])

  void $ executeMany conn "insert into students values (?,?,?)" (students :: [(String, String, String)])

getStudentEmail :: Row -> String
getStudentEmail row
  | not (null $ rLoginID row) = rLoginID row
  | "@espol.edu.ec" `isSuffixOf` rStudent row = rStudent row
  | otherwise = rStudent row ++ "@espol.edu.ec"

disconnect :: Connection -> IO ()
disconnect conn = close conn
