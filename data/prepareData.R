# Prepare the data for training and testing.

source('fileUtil.R')
source('nGramUtil.R')

prepareData <- function(p) {
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
  
  # Split the tokens into training and testing tokens.
  message('Spliting the tokens into training and testing tokens...')
  numTokens <- length(tokens)
  numTrainTokens <- round(0.9 * numTokens)
  trainTokens <- tokens[1:numTrainTokens]
  testTokens <- tokens[seq(numTrainTokens + 1, numTokens)]
  
  message(paste0('Saving the train tokens into ', getOutputPath('trainTokens.rData...')))
  save(trainTokens, file = getOutputPath('trainTokens.rData'))
  
  message(paste0('Saving the test tokens into ', getOutputPath('testTokens.rData...')))
  save(testTokens, file = getOutputPath('testTokens.rData'))
}
