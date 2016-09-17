# Compute n-gram frequencies.

source('nGramUtil.R')

computeNGramFreq <- function(p) {
  tokenDir <- paste('data', as.integer(100 * p), sep = '/')
  trainTokenFilePath <- paste(tokenDir, 'trainTokens.rData', sep = '/')
  outputDir <- paste('nGramFreq', as.integer(100 * p), sep = '/')
  
  if (!dir.exists(outputDir)) {
    dir.create(outputDir)
  }
  
  getOutputPath <- function(fileName) {
    paste(outputDir, fileName, sep = '/')
  }
  
  # Load the tokens.
  message(paste0('Loading the tokens from ', trainTokenFilePath, '...'))
  load(trainTokenFilePath)
  
  # Compute bigram frequencies.
  message('Computing bigram frequencies...')
  bigramFreq <- nGramFreq(trainTokens, n = 2)
  
  # Compute trigram frequencies.
  message('Computing trigram frequencies...')
  trigramFreq <- nGramFreq(trainTokens, n = 3)
  
  # Save the bigram and trigram frequencies.
  message(paste0('Saving bigram and trigram frequencies into ', outputDir, '/freq.rData...'))
  save(bigramFreq, trigramFreq, file = paste0(outputDir, '/freq.rData'))
  
  # Trim the bigram frequencies.
  message('Trimming bigram frequencies...')
  trimmedBigramFreq <- trimNGramFreq(bigramFreq)
  
  # Trim the trigram frequencies.
  message('Trimming trigram frequencies...')
  trimmedTrigramFreq <- trimNGramFreq(trigramFreq)
  
  # Save the trimmed bigram and trigram frequencies.
  message(paste0('Saving trimmed bigram and trigram frequencies into ', outputDir, '/trimmedFreq.rData...'))
  save(trimmedBigramFreq, trimmedTrigramFreq, file = paste0(outputDir, '/trimmedFreq.rData'))
}  