# Evaluate the n-gram predictive models.

source('nGramUtil.R')
source('predict.R')

evaluateNGramModel <- function(p, numTestCases = 2000, seed = 26) {

  # Load the trimmed bigram and trigram frequencies.
  nGramFreqDir <- paste0('nGramFreq/', as.integer(100 * p))
  nGramTrimmedFreqFilePath <- paste0(nGramFreqDir, '/trimmedFreq.rData')
  load(nGramTrimmedFreqFilePath)
  
  # Load the test tokens.
  tokenDir <- paste0('data/', as.integer(100 * p))
  testTokenFilePath <- paste0(tokenDir, '/testTokens.rData')
  load(testTokenFilePath)
  
  # We use trigrams for testing. Also, we keep the trigram with frequency 1, but discard those
  # which contain special words {BEGIN} and {END}.
  set.seed(seed)
  trigramFreq <- nGramFreq(testTokens, n = 3, message = FALSE)
  trigramFreq <- trigramFreq[!grepl('BEGIN|END', names(trigramFreq))]
  trigramFreq <- sample(trigramFreq, size = numTestCases)
  
  successCount <- sapply(
    names(trigramFreq),
    function(trigram) {
      words <- strsplit(trigram, split = '[^a-z]+')[[1]]
      prefix <- paste(words[1], words[2])
      word <- words[3]
      predictions <- predictNextWord(prefix, trimmedBigramFreq, trimmedTrigramFreq)
      predictedWords <- sapply(
        names(predictions),
        function(predictedPhrase) {
          ws <- strsplit(predictedPhrase, split = '[^a-z]+')[[1]]
          ws[length(ws)]
        })
      ifelse(word %in% predictedWords, 1, 0)
    })
  
  # return the accuracy
  sum(successCount * trigramFreq) / sum(trigramFreq)
}  