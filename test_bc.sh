#!/bin/bash
#SBATCH -c 1
#SBATCH -t 0-0:10
#sBATCH -p gpu
#SBATCH --mem=1000
#SBATCH --gres=gpu
#SBATCH -o rc_output_%j.out
#SBATCH -e rc_errors_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=cvoulgaris@gsd.harvard.edu
module load python # load Python
source activate ped_net # activate virtual env that has tile2net installed
location="42.35555189953313, -71.07168915322092, 42.35364837213307, -71.06437423368418" #bc example site
output_dir="bc_example"
# Run the generate and inference commands
python -m tile2net generate -l "$location" -o "$output_dir" -n example | python -m tile2net inference
