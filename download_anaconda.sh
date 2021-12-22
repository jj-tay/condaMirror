#!/bin/bash

# Record start time for use to detect new files later
START_DATETIME=$(date +"%F %T")

# Setup conda
source $HOME/miniconda3/etc/profile.d/conda.sh

# Create conda-miror environment if required
RESULT=$(conda env list | grep -c conda-mirror)
if [ $RESULT -eq "0" ]
then
	conda env create -f environment.yml
	conda activate conda-mirror
else
	conda activate conda-mirror
fi

# Download main, r channels for win-64, linux-64, noarch
for CHANNEL in main r
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
	  --config $CWD/whitelist_condaforge.yaml \
	  -vv
done

# Download msys2 channel for win-64
conda-mirror \
  --upstream-channel https://repo.continuum.io/pkgs/msys2 \
  --target-directory msys2 \
  --platform win-64 \
  -vv

# Download fastai, esri channel for win-64, linux-64, noarch
for CHANNEL in fastai esri
do
  for PLATFORM in win-64 linux-64 noarch
  do
    conda-mirror \
	  --upstream-channel https://conda.anaconda.org/$CHANNEL \
	  --target-directory $CHANNEL \
	  --platform $PLATFORM \
	  -vv
  done
done

# Download pytorch channel for win-64, linux-64, noarch
for PLATFORM in win-64 linux-64 noarch
  do
    conda-mirror \
	  --upstream-channel https://conda.anaconda.org/pytorch \
	  --target-directory pytorch \
	  --platform $PLATFORM \
	  --config $CWD/whitelist_pytorch.yaml \
	  -vv
  done

# Exit conda-mirror environment and return to previous directory
conda deactivate
if [ $RESULT -eq 0 ]
then
	conda remove -y -n conda-mirror --all
fi

# Copy new files to modified folder to ease file transfers
if [ -d to_transfer ]
then 
	rm -rf to_transfer/
fi
mkdir to_transfer
find \
	conda-forge/ \
	esri/ \
	fastai/ \
	main/ \
	msys2/ \
	pytorch/ \
	r/ \
	-type f \
	-newermt "$START_DATETIME" \
	-exec rsync -R {} to_transfer \;
