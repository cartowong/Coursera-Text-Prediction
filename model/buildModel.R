# Build n-gram models.

source('nGramUtil.R')

# You may change this parameter to any number between 0 and 1. The code below will continue to work.
p <- 0.20

tokenDir <- paste('data', as.integer(100 * p), sep = '/')
tokenFilePath <- paste(tokenDir, 'tokens.rData', sep = '/')
outputDir <- paste('model', as.integer(100 * p), sep = '/')

if (!dir.exists(outputDir)) {
  dir.create(outputDir)
}

getOutputPath <- function(fileName) {
  paste(outputDir, fileName, sep = '/')
}

# Load the tokens.
message(paste0('Loading the tokens from ', tokenFilePath, '...'))
load(tokenFilePath)

# Compute bigram frequencies.
message('Computing bigram frequencies...')
bigramFreq <- nGramFreq(tokens, n = 2)

# Compute trigram frequencies.
message('Computing trigram frequencies...')
trigramFreq <- nGramFreq(tokens, n = 3)

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
