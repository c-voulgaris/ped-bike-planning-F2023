#!/bin/bash

# Run the generate and inference commands
location="42.35555189953313, -71.07168915322092, 42.35364837213307, -71.06437423368418"
output_dir="schools"
python -m tile2net generate -l "$location" -o "$output_dir" -n whcis | python -m tile2net inference

zip -r schools.zip schools
