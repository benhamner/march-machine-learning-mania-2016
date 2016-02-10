import numpy as np
import pandas as pd

conversion = {
    "object": "TEXT",
    "float64": "NUMERIC",
    "int64": "INTEGER"
}

tables = {"Seasons": "input-v1/seasons_1985-2016.csv",
          "RegularSeasonCompactResults": "input-v1/regular_season_compact_results_1985-2015.csv",
          "RegularSeasonDetailedResults": "input-v1/regular_season_detailed_results_2003-2015.csv",
          "SampleSubmission": "input-v1/sample_submission_2012-2015.csv",
          "Teams": "input-v1/teams.csv",
          "TourneyCompactResults": "input-v1/tourney_compact_results_1985-2015.csv",
          "TourneyDetailedResults": "input-v1/tourney_detailed_results_2003-2015.csv",
          "TourneySeeds": "input-v1/tourney_seeds_1985-2015.csv",
          "TourneySlots": "input-v1/tourney_slots_1985-2015.csv"}

sql = """.separator ","

"""

for table in tables:
    print(table)
    indexes = ""
    data = pd.read_csv(tables[table], encoding="latin1")
    data.columns = [''.join(x for x in col.title() if not x.isspace()).replace("-","") for col in data.columns]
    print(data.columns)

    data.to_csv("output/%s.csv" % table, index=False)
    data = pd.read_csv("output/%s.csv" % table)

    sql += """CREATE TABLE %s (
%s);

.import "working/noHeader/%s.csv" %s

%s""" % (table,
         ",\n".join(["    %s %s%s" % (key,
                                     conversion[str(data.dtypes[key])],
                                     " PRIMARY KEY" if key=="Id" else "")
                     for key in data.dtypes.keys()]), table, table,
         indexes)

open("working/import.sql", "w").write(sql)
