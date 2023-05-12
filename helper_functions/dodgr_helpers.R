## Libraries
library(here)
library(tidyverse)

## Take a set of path point indices and return an sf data frame
## of multilinestrings with paths.

fn_make_paths_sf <- function(my_paths,
                             my_graph) {
  
  vertices <- as_tibble(my_graph) |>
    select(from_id, from_lon, from_lat) |>
    filter(!duplicated(from_id)) |>
    st_as_sf(coords = c("from_lon", "from_lat"), crs = "WGS84")
  
  origins <- names(my_paths)
  destinations <- sub(".*-", "", names(my_paths[[origins[1]]]))
  
  for (i in 1:length(origins)) {
    for (j in 1: length(destinations)) {
      this_path <- my_paths[[origins[i]]][[j]]
      
      if(origins[i] != destinations[j]) {
        path_points <- vertices |>
          filter(from_id %in% this_path) |>
          arrange(factor(from_id, levels = this_path)) |>
          mutate(order = 
                   as.character(seq(1, length(this_path), by = 1))) 
        
        first_points <- path_points[1:2,]
        
        this_path_line <- first_points |>
          summarize() |>
          st_cast("LINESTRING")
        
        for (k in 3:nrow(path_points)) {
          next_points <- path_points[(k-1):k,]
          next_line <- next_points |>
            summarize() |>
            st_cast("LINESTRING")
          
          this_path_line <- rbind(this_path_line, next_line) |>
            st_union()
          
        }
        if(exists("path_lines")) {
          path_lines <- c(path_lines, this_path_line)
        } else {
          path_lines <- this_path_line
        }
      }
    }
  }
  
  df <- tibble(id = as.character(seq(1, length(path_lines), by=1))) |>
    st_set_geometry(path_lines)
  
  df
  
}