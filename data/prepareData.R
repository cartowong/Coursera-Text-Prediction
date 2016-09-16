# Prepare the data for training and testing.

p <- 0.15

source('fileUtil.R')
source('nGramUtil.R')

inputDir <- 'rawData/final/en_US'
outputDir <- paste('data', as.integer(100 * p), sep = '/')

if (!dir.exists(outputDir)) {
  dir.create(outputDir)
}

getOutputPath <- function(fileName) {
  paste(outputDir, fileName, sep = '/')
}

outputFilePaths <- c()
fileNames <- c('en_US.blogs.txt', 'en_US.news.txt', 'en_US.twitter.txt')
for (fileName in fileNames) {
  inputFilePath <- paste(inputDir, fileName, sep = '/')

  n <- nchar(fileName)
  outputFileName <- paste0(substr(fileName, 1, n - 4), '.sample', substr(fileName, n - 3, n))
  outputFilePath <- paste(outputDir, outputFileName, sep = '/')
  outputFilePaths <- c(outputFilePaths, outputFilePath)
  
  message(paste0('Sampling ', as.integer(100 * p), '% of the lines from ', inputFilePath, ' to ', outputFilePath))
  sampleText(inputFilePath, outputFilePath, p)
}

message('Combining files...')
combinedFilePath <- getOutputPath('combined.txt')
combineText(outputFilePaths, combinedFilePath)

message('Tokenizing...')
tokens <- tokenize(getOutputPath('combined.txt'))

message(paste0('Saving the tokens into ', getOutputPath('tokens.rData')))
save(tokens, file = getOutputPath('tokens.rData'))
