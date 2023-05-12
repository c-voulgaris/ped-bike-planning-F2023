library(tidyverse)
library(dodgr)
library(sf)
library(here)
library(leaflet)
library(RColorBrewer)

here("helper_functions",
     "dodgr_helpers.R") |>
  source()

# Read in shapefile from tile2net output
# Might need a little preprocessing in QGIS or ArcGIS to confirm
# network matches field observations and all vertices split the
# edges they are on. 
boston_common <- here("sample-data") |>
  st_read() |>
  st_transform("WGS84") |>
  st_cast("LINESTRING") |>
  mutate(id = seq(1, length(f_type), by=1))

# Set weights for link types. Lower values mean the link is
# less desirable.
wts_bc <- data.frame (name = "foot",
                   way = unique (boston_common$f_type)) |>
  mutate(value = case_when(way == "crosswalk" ~ 0.5,
                           way == "sidewalk_connection" ~ 1,
                           way == "sidewalk" ~ 1,
                           way == "medians" ~ 1))

# Build the graph
bc_graph <- weight_streetnet(boston_common, 
                             type_col = "f_type",
                             id_col = "id",
                             wt_profile = wts_bc)

# Calculate shortest paths
origins <- c("156", "394", "417", "187")
destination <- c("259", "69", "156")

paths <- dodgr_paths(bc_graph, from = origins, to = destination) |>
  fn_make_paths_sf(bc_graph)
  
# Diplay results on a map
path_pal <- colorFactor(brewer.pal(length(paths$id), "Set3"), paths$id)

leaflet(boston_common) |>
  addProviderTiles(providers$Stamen.TonerLite) |>
  addPolylines(weight = 1,
               color = "gray") |>
  addPolylines(data = paths,
               color = ~path_pal(id),
               weight = 3,
               highlightOptions = highlightOptions(weight = 5,
                                                   opacity = 1)) 

