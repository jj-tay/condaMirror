#!/bin/bash
set -e

# Record start time for use to detect new files later
START_DATETIME=$(date +"%F %T")

# Setup conda
source $HOME/miniconda3/etc/profile.d/conda.sh

# Create conda-miror environment if required
RESULT=$(conda env list | grep -c conda-mirror)
if [ $RESULT -eq 0 ]
then
	conda env create -f environment.yml
	conda activate conda-mirror
else
	conda activate conda-mirror
fi

# Set temp directory
TEMPDIR=tempdir

# Download main, r channels for win-64, linux-64, noarch
for CHANNEL in main r
do
  for PLATFORM in win-64 linux-64 noarch
  do
    conda-mirror \
	  --upstream-channel https://repo.continuum.io/pkgs/$CHANNEL \
      --temp-directory $TEMPDIR \
	  --target-directory condaMirror/$CHANNEL \
	  --platform $PLATFORM \
	  -vv
  done
done

# Download conda-forge channel for win-64, linux-64, noarch
for PLATFORM in win-64 linux-64 noarch
do
    conda-mirror \
	  --upstream-channel https://conda.anaconda.org/conda-forge \
      --temp-directory $TEMPDIR \
	  --target-directory condaMirror/conda-forge \
	  --platform $PLATFORM \
	  --config whitelist_condaforge.yaml \
      -D \
	  -vv
done

# Download msys2 channel for win-64
conda-mirror \
  --upstream-channel https://repo.continuum.io/pkgs/msys2 \
  --temp-directory $TEMPDIR \
  --target-directory condaMirror/msys2 \
  --platform win-64 \
  -vv

# Download fastai, esri channel for win-64, linux-64, noarch
for CHANNEL in fastai esri
do
  for PLATFORM in win-64 linux-64 noarch
  do
    conda-mirror \
	  --upstream-channel https://conda.anaconda.org/$CHANNEL \
      --temp-directory $TEMPDIR \
	  --target-directory condaMirror/$CHANNEL \
	  --platform $PLATFORM \
	  -vv
  done
done

# Download pytorch channel for win-64, linux-64, noarch
for PLATFORM in win-64 linux-64 noarch
  do
    conda-mirror \
	  --upstream-channel https://conda.anaconda.org/pytorch \
      --temp-directory $TEMPDIR \
	  --target-directory condaMirror/pytorch \
	  --platform $PLATFORM \
	  --config whitelist_pytorch.yaml \
      -D \
	  -vv
  done

# Exit conda-mirror environment and return to previous directory
conda deactivate
if [ $RESULT -eq 0 ]
then
	conda remove -y -n conda-mirror --all
fi
