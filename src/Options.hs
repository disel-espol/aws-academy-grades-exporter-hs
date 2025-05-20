module Options (parseOpts, Opt (..), Dest (..)) where

import           Options.Applicative

data Dest = Postgres | Stdout
  deriving Show

data Opt = MkOpt
  { optDest :: Dest
  , optFile :: FilePath
  }
  deriving Show

opt :: Parser Opt
opt = MkOpt
  <$> option readDest
      ( long "destination"
      <> short 'd'
      <> help "Where to export the data"
      )
  <*> strOption
      ( long "file"
      <> short 'f'
      <> help "The file to be processed"
      )

  where
    readDest = eitherReader $ \s ->
      case s of
        "postgres" -> pure Postgres
        "stdout"   -> pure Stdout
        _          -> Left "Invalid exporter"

parseOpts :: IO Opt
parseOpts = execParser opts

opts :: ParserInfo Opt
opts = info (opt <**> helper)
      ( fullDesc
      <> progDesc "Export grade from AWS Academy to various different formats"
      <> header "aws-academy-grade-exporter - a tool for exporting grades from AWS Academy to various formats"
      )
