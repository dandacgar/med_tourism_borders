import geopandas as gpd
import pandas as pd

counties = gpd.read_file("../input/cb_2023_us_county_5m.zip")  # CB file (simplified)
intl = gpd.read_file("../input/tl_2023_us_internationalboundary.zip")  # International boundaries

# Ensure a projected CRS (meters) for robust topology
counties = counties.to_crs(3857)
intl = intl.to_crs(3857)

intl_can = intl[intl["IBTYPE"].isin(["A","C"])] # A = (Alaska-Canada), C = (Lower-48-Canada)
intl_mex = intl[intl["IBTYPE"].isin(["M"])] # M - (Lower-48-Mexico)

keep_cols = ["STATEFP","COUNTYFP","GEOID","NAME","STATE_NAME"]

# Spatial join: counties that intersect/touch the intl boundary
can_hits = gpd.sjoin(counties, intl_can, predicate="intersects", how="inner")
mex_hits = gpd.sjoin(counties, intl_mex, predicate="intersects", how="inner")

can_counties = (can_hits[keep_cols]
                .drop_duplicates()
                .assign(border="Canada"))

mex_counties = (mex_hits[keep_cols]
                .drop_duplicates()
                .assign(border="Mexico"))

can_mex = pd.concat([can_counties, mex_counties], ignore_index=True)
can_mex.to_csv("../temp/counties_bordering_canada_mexico.csv", index=False)
