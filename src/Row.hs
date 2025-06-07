module Row where


import           Data.Csv
import           Database.PostgreSQL.Simple.ToRow
import           GHC.Generics                     (Generic)

data Row = MkRow
  { rStudent                         :: !String
  , rId                              :: !Int
  , rLoginID                         :: !String
  , rSection                         :: !String
  , rModule1KC                       :: !(Maybe Double)
  , rModule2KC                       :: !(Maybe Double)
  , rModule3KC                       :: !(Maybe Double)
  , rModule4KC                       :: !(Maybe Double)
  , rModule5KC                       :: !(Maybe Double)
  , rModule6KC                       :: !(Maybe Double)
  , rModule7KC                       :: !(Maybe Double)
  , rModule8KC                       :: !(Maybe Double)
  , rModule9KC                       :: !(Maybe Double)
  , rModule10KC                      :: !(Maybe Double)
  , rCourseAssesment                 :: !(Maybe Double)
  , rLab1                            :: !(Maybe Double)
  , rLab2                            :: !(Maybe Double)
  , rLab3                            :: !(Maybe Double)
  , rActivityAwsLambda               :: !(Maybe Double)
  , rActivityElasticBeanstalk        :: !(Maybe Double)
  , rLab4                            :: !(Maybe Double)
  , rLab5                            :: !(Maybe Double)
  , rLab6                            :: !(Maybe Double)
  , rAssignmentsCurrentPoints        :: !(Maybe Double)
  , rAssignmentsFinalPoints          :: !(Maybe Double)
  , rAssignmentsCurrentScore         :: !(Maybe Double)
  , rAssignmentsUnpostedCurrentScore :: !(Maybe Double)
  , rAssignmentsFinalScore           :: !(Maybe Double)
  , rAssignmentsUnpostedFinalScore   :: !(Maybe Double)
  , rKCCurrentPoints                 :: !(Maybe Double)
  , rKCFinalPoints                   :: !(Maybe Double)
  , rKCCurrentScore                  :: !(Maybe Double)
  , rKCUnpostedCurrentScore          :: !(Maybe Double)
  , rKCFinalScore                    :: !(Maybe Double)
  , rKCUnpostedFinalScore            :: !(Maybe Double)
  , rLabsCurrentPoints               :: !(Maybe Double)
  , rLabsFinalPoints                 :: !(Maybe Double)
  , rLabsCurrentScore                :: !(Maybe Double)
  , rLabsUnpostedCurrentScore        :: !(Maybe Double)
  , rLabsFinalScore                  :: !(Maybe Double)
  , rLabsUnpostedFinalScore          :: !(Maybe Double)
  , rCurrentPoints                   :: !(Maybe Double)
  , rFinalPoints                     :: !(Maybe Double)
  , rCurrentScore                    :: !(Maybe Double)
  , rUnpostedCurrentScore            :: !(Maybe Double)
  , rFinalScore                      :: !(Maybe Double)
  , rUnpostedFinalScore              :: !(Maybe Double)
  }
  deriving stock (Show, Generic)
  deriving anyclass (ToRow)

instance FromRecord Row
