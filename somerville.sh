#!/bin/bash
#SBATCH -c 1
#SBATCH -t 1-00:00
#sBATCH -p gpu
#SBATCH --mem=8000
#SBATCH --gres=gpu
#SBATCH -o rc_output_%j.out
#SBATCH -e rc_errors_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=cvoulgaris@gsd.harvard.edu
module load python # load Python
source activate ped_net # activate virtual env that has tile2net installed
location="42.41816, -71.13464, 42.37253, -71.07269" #somerville bounding box
output_dir="somerville"
# Run the generate and inference commands
python -m tile2net generate -l "$location" -o "$output_dir" -n somerville | python -m tile2net inference
