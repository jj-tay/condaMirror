@ECHO OFF

REM Set temp directory
set TEMPDIR=tempdir

REM Activate conda environment
call conda activate conda-mirror

REM Download main, r channels for win-64, linux-64, noarch
for %%C in (main r) do (
  for %%P in (win-64 linux-64 noarch) do (
    conda-mirror ^
	  --upstream-channel https://repo.continuum.io/pkgs/%%C ^
    --temp-directory %TEMPDIR% ^
	  --target-directory condaMirror\%%C ^
	  --platform %%P ^
	  -vv ^
    --no-validate-target
  )
)

REM Download conda-forge channel for win-64, linux-64, noarch
for %%P in (win-64 linux-64 noarch) do (
  conda-mirror ^
  --upstream-channel https://conda.anaconda.org/conda-forge ^
  --temp-directory %TEMPDIR% ^
  --target-directory condaMirror\conda-forge ^
  --platform %%P ^
  --config whitelist_condaforge.yaml ^
  -D ^
  -vv ^
  --no-validate-target
)

REM Download msys2 channel for win-64
conda-mirror ^
--upstream-channel https://repo.continuum.io/pkgs/msys2 ^
--temp-directory %TEMPDIR% ^
--target-directory condaMirror\msys2 ^
--platform win-64 ^
-D ^
-vv ^
--no-validate-target

REM Download fastai, esri channel for win-64, linux-64, noarch
for %%C in (fastai esri) do (
  for %%P in (win-64 linux-64 noarch) do (
    conda-mirror ^
	  --upstream-channel https://conda.anaconda.org/%%C ^
    --temp-directory %TEMPDIR% ^
	  --target-directory condaMirror\%%C ^
	  --platform %%P ^
    -D ^
	  -vv ^
    --no-validate-target
  )
)

REM Download pytorch channel for win-64, linux-64, noarch
for %%P in (win-64 linux-64 noarch) do (
  conda-mirror ^
  --upstream-channel https://conda.anaconda.org/pytorch ^
  --temp-directory %TEMPDIR% ^
	--target-directory condaMirror\pytorch ^
	--platform %%P ^
	--config whitelist_pytorch.yaml ^
  -D ^
	-vv ^
  --no-validate-target
)

REM Download microsoft channel for win-64, linux-64, noarch
for %%P in (win-64 linux-64 noarch) do (
  conda-mirror ^
  --upstream-channel https://conda.anaconda.org/microsoft ^
  --temp-directory %TEMPDIR% ^
	--target-directory condaMirror\microsoft ^
	--platform %%P ^
	--config whitelist_microsoft.yaml ^
  -D ^
	-vv ^
  --no-validate-target
)

REM Index the channels

for /f %%C in ('dir /b condaMirror') do (
  python -m conda_index condaMirror\%%C
)

REM Deactivate conda environment
call conda deactivate

REM Sync to S3
aws s3 sync condaMirror s3://s3fs-mount-s3-prod/hdbconda --delete --debug --profile hdbba-s3fs
