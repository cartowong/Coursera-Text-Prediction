# Private helper function to be used by the function predictNextWord(...).
findTopMatchingNGramProb <- function(pattern, nGramFreq, maxSize = 5) {
  matchingNGramFreq <- nGramFreq[grepl(pattern, names(nGramFreq))]
  totalMatchingNGramFreq <- sum(matchingNGramFreq)
  
  matchingNGramProb <- c()
  
  if (totalMatchingNGramFreq > 0) {
    matchingNGramProb <- matchingNGramFreq / totalMatchingNGramFreq
  }
  
  if (length(matchingNGramProb) > maxSize) {
    matchingNGramProb <- matchingNGramProb[1:maxSize]
  }
  
  return(matchingNGramProb)
}

predictNextWord <- function(phrase, nGramFreqList, maxNumPredictions = 10, lazy = TRUE) {
  # Predict the next word following a given phrase.
  #
  # Args:
  #   phrase             {character}
  #                      the given phrase
  #   nGramFreqList      {list}
  #                      a list of n-gram frequency tables
  #   maxNumPredictions  {integer}
  #                      maximum number of predictions to be returned
  #   lazy               {logical}
  #                      Optional. Default to TRUE (recommended). If TRUE, it will not use the
  #                      remaining frequency tables as long as enough predictions have been made.
  #
  # Return: {table}
  #         The names of the returned table are the predicted next words, and the values are the
  #         estimated probabilities. (Note that these probabilities may sum up to be larger than 1,
  #         since we are using back-off model. These probabilities may not necessarily come from
  #         the same probability space.) The returned table is sorted in decreasing probabilities.
  
  phrase <- tolower(trimws(phrase))
  tokens <- strsplit(phrase, split = '[^a-z]+')[[1]]
  numTokens <- length(tokens)
  
  predictions <- c()
  for (nGramFreq in nGramFreqList) {
    
    if (lazy & length(predictions) >= maxNumPredictions) {
      break
    }
    
    n <- length(strsplit(names(nGramFreq)[1], split = ' ')[[1]])
    if (numTokens >= n - 1) {
      pattern <- paste(tokens[seq(numTokens - n + 2, numTokens)], collapse = ' ')
      pattern <- paste0('^', pattern, ' ')
      matchingNGramProb <- findTopMatchingNGramProb(
        pattern,
        nGramFreq,
        maxSize = ifelse(lazy, maxNumPredictions - length(predictions), maxNumPredictions)
      )
      predictions <- c(predictions, matchingNGramProb)
    }
  }
  
  predictions <- sort(predictions, decreasing = TRUE)
  if (length(predictions) > maxNumPredictions) {
    predictions <- predictions[1:maxNumPredictions]
  }
  
  return(predictions)
}
