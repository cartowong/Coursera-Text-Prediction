source('util.R')

p <- 0.01
inputDir <- 'rawData/final/en_US'
outputDir <- 'sampleData'
fileNames <- c('en_US.blogs.txt', 'en_US.news.txt', 'en_US.twitter.txt')

# Generate a sample (subset) of the given txt document and save it in the output directory.
generateSample <- function(fileName) {
  n <- nchar(fileName)
  inputFilePath <- paste(inputDir, fileName, sep = '/')
  outputFileName <- paste0(substr(fileName, 1, n-4), '.sample', substr(fileName, n -3, n))
  outputFilePath <- paste(outputDir, outputFileName, sep = '/')
  sampleText(inputFilePath, outputFilePath, p)
}

for (fileName in fileNames) {
  generateSample(fileName)
}