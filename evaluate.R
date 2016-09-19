# Evaluate the n-gram predictive models.

source('nGramUtil.R')
source('predict.R')

evaluateAccuracyAndPerformance <- function(predict, testNGrams) {
  # Evaluate accuracy and performance.
  #
  # Args:
  #   predict     {function}
  #               a function which takes a prefix (character string) and returns a small frequency
  #               table. The names of the table are predicted n-grams (for possibly different values
  #               of n), and the values are estimated probabilities.
  #   testNGrams  {character[]}
  #               a vector of test n-grams
  #
  # Return: {list}
  #         $ accuracy            {numeric}
  #         $ meanPredictionTime  {numberic}
  
  numTestCases <- length(testNGrams)
  predictionTimes <- rep(NA, numTestCases)
  successCounts <- rep(NA, numTestCases)
  for (j in seq_along(testNGrams)) {
    testNGram <- testNGrams[j]
    testWords <- strsplit(testNGram, split = ' ')[[1]]
    prefix <- paste(testWords[seq(1, length(testWords) - 1)], collapse = ' ')
    word <- testWords[length(testWords)]
    
    startTime <- proc.time()
    predictions <- predict(prefix)
    endTime <- proc.time()
    predictionTimes[j] <- (endTime - startTime)['elapsed']
    
    predictedWords <- sapply(
      names(predictions),
      function(predictedPhrase) {
        ws <- strsplit(predictedPhrase, split = ' ')[[1]]
        ws[length(ws)]
      })
    successCounts[j] <- ifelse(word %in% predictedWords, 1, 0)
  }
  
  # assertion: make sure the prediction times and success counts are successfully generated
  if (sum(is.na(predictionTimes)) > 0) {
    stop('Check the prediction times computation!')
  }
  if (sum(is.na(successCounts)) > 0) {
    stop('Check the success counts computation!')
  }
  
  # return the accuracy and performance
  list(
    accuracy = sum(successCounts) / length(successCounts),
    meanPredictionTime = mean(predictionTimes)
  )
}

generateTestNGrams <- function(testTokens, n, numTestCases = 1000, seed = 26) {
  # Generate test n-grams.
  #
  # Args:
  #   testTokens    {character[]}
  #                 a vector of character strings
  #   n             {integer}
  #                 each n-gram consists of n words
  #   numTestCases  {integer}
  #                 Optional. The number of test cases. Default = 1000.
  #   seed          {integer}
  #                 Optional. Random seed. Default = 26.
  # Return: {character[]}
  #         a vector of test tokens. The length of the returned vector is equal to numTestCases.
  
  set.seed(seed) # for reproducibility
  
  # We keep the n-grams with frequency 1, but discard those which contain special words
  # {BEGIN} or {END}.
  freq <- nGramFreq(testTokens, n, message = FALSE)
  freq <- freq[!grepl('BEGIN|END', names(freq))]
  freq <- sample(freq, size = numTestCases, prob = freq)
  names(freq)
}
