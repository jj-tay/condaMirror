#!/bin/bash
set -e

# Set temp directory
TEMPDIR=tempdir

# Activate conda environment
conda activate conda-mirror

# Download main, r channels for win-64, noarch
# for CHANNEL in main r
# do
#   for PLATFORM in win-64 noarch
#   do
#     conda-mirror \
#       --upstream-channel https://repo.continuum.io/pkgs/$CHANNEL \
#       --temp-directory $TEMPDIR \
# 	    --target-directory condaMirror/$CHANNEL \
# 	    --platform $PLATFORM \
# 	    -vv \
#       --no-validate-target
#   done
# done

# Download conda-forge channel for win-64, noarch
for PLATFORM in win-64 noarch
do
  conda-mirror \
    --upstream-channel https://conda.anaconda.org/conda-forge \
    --temp-directory $TEMPDIR \
    --target-directory condaMirror/conda-forge \
    --platform $PLATFORM \
    --config whitelist_condaforge.yaml \
    -D \
    -vv \
    --no-validate-target
done

# Download msys2 channel for win-64
conda-mirror \
  --upstream-channel https://repo.continuum.io/pkgs/msys2 \
  --temp-directory $TEMPDIR \
  --target-directory condaMirror/msys2 \
  --platform win-64 \
  -D \
  -vv \
  --no-validate-target

# Download fastai, esri channel for win-64, noarch
for CHANNEL in fastai esri
do
  for PLATFORM in win-64 noarch
  do
    conda-mirror \
	    --upstream-channel https://conda.anaconda.org/$CHANNEL \
      --temp-directory $TEMPDIR \
	    --target-directory condaMirror/$CHANNEL \
	    --platform $PLATFORM \
      -D \
	    -vv \
      --no-validate-target
  done
done

# Download pytorch channel for win-64, noarch
for PLATFORM in win-64 noarch
  do
    conda-mirror \
	    --upstream-channel https://conda.anaconda.org/pytorch \
      --temp-directory $TEMPDIR \
	    --target-directory condaMirror/pytorch \
	    --platform $PLATFORM \
	    --config whitelist_pytorch.yaml \
      -D \
	    -vv \
      --no-validate-target
  done

# Download microsoft channel for win-64, noarch
for PLATFORM in win-64 noarch
  do
    conda-mirror \
	    --upstream-channel https://conda.anaconda.org/microsoft \
      --temp-directory $TEMPDIR \
	    --target-directory condaMirror/microsoft \
	    --platform $PLATFORM \
	    --config whitelist_microsoft.yaml \
      -D \
	    -vv \
      --no-validate-target
  done

# Download h2oai channel for win-64, noarch
for PLATFORM in win-64 noarch
  do
    conda-mirror \
	    --upstream-channel https://conda.anaconda.org/h2oai \
      --temp-directory $TEMPDIR \
	    --target-directory condaMirror/h2oai \
	    --platform $PLATFORM \
	    --config whitelist_h2oai.yaml \
      -D \
	    -vv \
      --no-validate-target
  done

# Index the channels
for CHANNEL in condaMirror/*
do
  python -m conda_index $CHANNEL
done

# Deactivate conda environment
conda deactivate

# Sync to S3
aws s3 sync condaMirror s3://s3fs-mount-s3-prod/hdbconda --delete --debug --profile hdbba-s3fs
