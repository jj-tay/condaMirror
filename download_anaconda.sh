#!/bin/bash

# Setup conda
source $HOME/anaconda3/etc/profile.d/conda.sh

# Create conda-miror environment if required
RESULT=$(conda env list | grep -c conda-mirror)
if [ $RESULT -eq "0" ]
then
	conda env create -f environment.yml
	conda activate conda-mirror
else
	conda activate conda-mirror
fi

# Download main, free, r channels for win-64, linux-64, noarch
for CHANNEL in main free r
do
  for PLATFORM in win-64 linux-64 noarch
  do
    conda-mirror \
	  --upstream-channel https://repo.continuum.io/pkgs/$CHANNEL \
	  --target-directory $CHANNEL \
	  --platform $PLATFORM \
	  -vv
  done
done

# Download conda-forge channel for win-64, linux-64, noarch
CWD=`dirname $0`
for PLATFORM in win-64 linux-64 noarch
do
    conda-mirror \
	  --upstream-channel https://conda.anaconda.org/conda-forge \
	  --target-directory conda-forge \
	  --platform $PLATFORM \
    --config $CWD/whitelist.yaml
	  -vv
done

# Download msys2 channel for win-64
conda-mirror \
  --upstream-channel https://repo.continuum.io/pkgs/msys2 \
  --target-directory msys2 \
  --platform win-64 \
  -vv

# Download esri channel for win-64, noarch
for PLATFORM in win-64 noarch
do
  conda-mirror \
  --upstream-channel https://conda.anaconda.org/esri/ \
  --target-directory esri \
  --platform $PLATFORM \
  -vv
done

# Exit conda-mirror environment and return to previous directory
conda deactivate
if [ $RESULT -eq 0 ]
then
	conda remove -y -n conda-mirror --all
fi

