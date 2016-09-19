# Evaluate the n-gram predictive models.

source('nGramUtil.R')
source('predict.R')

evaluateNGramModel <- function(p, numTestCases = 1000, seed = 26) {

  # Load the trimmed bigram and trigram frequencies.
  nGramFreqDir <- paste0('nGramFreq/', as.integer(100 * p))
  nGramTrimmedFreqFilePath <- paste0(nGramFreqDir, '/trimmedFreq.rData')
  load(nGramTrimmedFreqFilePath)
  
  # Load the test tokens.
  tokenDir <- paste0('data/', as.integer(100 * p))
  testTokenFilePath <- paste0(tokenDir, '/testTokens.rData')
  load(testTokenFilePath)
  
  # We use quadgrams for testing. Also, we keep the quadgrams with frequency 1, but discard those
  # which contain special words {BEGIN} and {END}.
  set.seed(seed)
  quadgramFreq <- nGramFreq(testTokens, n = 4, message = FALSE)
  quadgramFreq <- quadgramFreq[!grepl('BEGIN|END', names(quadgramFreq))]
  quadgramFreq <- sample(quadgramFreq, size = numTestCases, prob = quadgramFreq)
  
  predictionTimes <- rep(NA, length(quadgramFreq))
  successCount <- rep(NA, length(quadgramFreq))
  for (j in seq_along(quadgramFreq)) {
    quadgram <- names(quadgramFreq)[j]
    words <- strsplit(quadgram, split = '[^a-z]+')[[1]]
    prefix <- paste(words[1], words[2], words[3])
    word <- words[4]
    
    startTime <- proc.time()
    predictions <- predictNextWord(prefix, trimmedBigramFreq, trimmedTrigramFreq, trimmedQuadgramFreq)
    endTime <- proc.time()
    predictionTimes[j] <- (endTime - startTime)['elapsed']
    
    predictedWords <- sapply(
      names(predictions),
      function(predictedPhrase) {
        ws <- strsplit(predictedPhrase, split = '[^a-z]+')[[1]]
        ws[length(ws)]
      })
    successCount[j] <- ifelse(word %in% predictedWords, 1, 0)
  }
  
  # assertion: make sure the prediction times and success counts are successfully generated
  if (sum(is.na(predictionTimes)) > 0) {
    stop('Check the prediction times computation!')
  }
  if (sum(is.na(successCount)) > 0) {
    stop('Check the success counts computation!')
  }
  
  # return the accuracy
  list(
    accuracy = sum(successCount) / length(successCount),
    meanPredictionTime = mean(predictionTimes)
  )
}  