module Types where

import           Data.Text (Text)

-- | A CSV row
type Row = [Text]

-- | A CSV header
type Header = Row

-- | A bunch of CSV rows
type Rows = [Row]


