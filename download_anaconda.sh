#!/bin/bash

# Setup conda
source $HOME/anaconda3/etc/profile.d/conda.sh

# Create conda-miror environment if required
RESULT=$(conda env list | grep -c conda-mirror)
if [ $RESULT -eq 0 ]
then
	conda create -y -n conda-mirror -c conda-forge conda-mirror
	conda activate conda-mirror
else
	conda activate conda-mirror
fi

# Create local dir for mirror if required
MIRROR_DIR=$PWD

# Download main channel for win-64
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/main --target-directory main --temp-directory "$MIRROR_DIR" --platform win-64 -vv

# Download main channel for linux-64
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/main --target-directory main --temp-directory "$MIRROR_DIR" --platform linux-64 -vv

# Download main channel for noarch
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/main --target-directory main --temp-directory "$MIRROR_DIR" --platform noarch -vv

# Download free channel for win-64
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/free --target-directory free --temp-directory "$MIRROR_DIR" --platform win-64 -vv

# Download free channel for linux-64
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/free --target-directory free --temp-directory "$MIRROR_DIR" --platform linux-64 -vv

# Download free channel for noarch
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/free --target-directory free --temp-directory "$MIRROR_DIR" --platform noarch -vv

# Download r channel for win-64
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/r --target-directory r --temp-directory "$MIRROR_DIR" --platform win-64 -vv

# Download r channel for linux-64
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/r --target-directory r --temp-directory "$MIRROR_DIR" --platform linux-64 -vv

# Download r channel for noarch
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/r --target-directory r --temp-directory "$MIRROR_DIR" --platform noarch -vv

# Download msys2 channel for win-64
conda-mirror --upstream-channel https://repo.continuum.io/pkgs/msys2 --target-directory msys2 --temp-directory "$MIRROR_DIR" --platform win-64 -vv

# Download esri channel for win-64
conda-mirror --upstream-channel https://conda.anaconda.org/esri/ --target-directory esri --temp-directory "$MIRROR_DIR" --platform win-64 -vv

# Download esri channel for noarch
conda-mirror --upstream-channel https://conda.anaconda.org/esri/ --target-directory esri --temp-directory "$MIRROR_DIR" --platform noarch -vv

# Download conda-forge channel for win-64
conda-mirror --upstream-channel https://conda.anaconda.org/conda-forge --target-directory conda-forge --temp-directory "$MIRROR_DIR" --platform win-64 -vv

# Download conda-forge channel for linux-64
conda-mirror --upstream-channel https://conda.anaconda.org/conda-forge --target-directory conda-forge --temp-directory "$MIRROR_DIR" --platform linux-64 -vv

# Download conda-forge channel for noarch
conda-mirror --upstream-channel https://conda.anaconda.org/conda-forge --target-directory conda-forge --temp-directory "$MIRROR_DIR" --platform noarch -vv

# Exit conda-mirror environment and return to previous directory
conda deactivate
if [ $RESULT -eq 0 ]
then
	conda remove -y -n conda-mirror --all
fi

