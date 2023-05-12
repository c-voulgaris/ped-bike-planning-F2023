library(tigris)
library(sf)

somerville_bbox <- places(state = "MA") |>
  filter(NAME == "Somerville") |>
  st_bbox()

somerville_bbox
