#!/bin/bash

# bounding box for Somerville
location="42.41816, -71.13464, 42.37253, -71.07269"

output_dir="schools"

# Run the generate and inference commands
python -m tile2net generate -l "$location" -o "$output_dir" -n somerville | python -m tile2net inference

zip -r schools.zip schools
