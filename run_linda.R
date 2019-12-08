# Rscript to run LINDA

# load up the package
library(LINDA)

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

# runit
linda_predict(inputImg, outdir = outDir)

# check results in outDir
