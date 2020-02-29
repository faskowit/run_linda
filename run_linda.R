# Rscript to run LINDA

# load up the package
library(LINDA)
library(ANTsR)

# command line args
cmdLineArgs <- commandArgs(trailingOnly = TRUE)

# read command line args
inputImg <- cmdLineArgs[1]
outDir <- cmdLineArgs[2]

# check inputs
if (!file.exists(inputImg)) {
  stop("input img does not seem to exist")
}

# create oDir if if does not exist
dir.create(file.path(outDir))
# and if couldn't write, stop
if (!dir.exists(file.path(outDir))) {
  stop("output dir could not be written")
}

# read in the image
iImg <- antsImageRead(inputImg)

# do the winsorize
# truncImg <- iMath(iImg, 'TruncateImageIntensity', 0.1, 0.99)
truncN4 <- abpN4(iImg, intensityTruncation = c(0.025, 0.975, 100),
usen3 = FALSE)

truncFile <- tempfile( fileext = ".nii.gz" ) 
antsImageWrite( truncN4 , truncFile)

# runit
linda_predict(truncFile, outdir = outDir, cache=TRUE)

# check results in outDir
