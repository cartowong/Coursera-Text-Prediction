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

predictNextWord <- function(phrase, bigramFreq, trigramFreq, maxNumPredictions = 5) {
  # Predict the next word following a given phrase.
  #
  # Args:
  #   phrase             {character}
  #                      the given phrase
  #   bigramFreq         {table}
  #                      bigram frequencies
  #   trigramFreq        {table}
  #                      trigram frequencies
  #   maxNumPredictions  {integer}
  #                      maximum number of predictions to be returned
  # Return: {table}
  #         The names of the returned table are the predicted next words, and the values are the
  #         estimated probabilities. (Note that these probabilities may sum up to be larger than 1,
  #         since we are using back-off model. These probabilities may not necessarily come from
  #         the same probability space.) The returned table is sorted in decreasing probabilities.
  
  phrase <- tolower(trimws(phrase))
  tokens <- strsplit(phrase, split = '[^a-z]+')[[1]]
  numTokens <- length(tokens)
  
  predictions <- c()
  
  if ((numTokens >= 2) & (length(predictions) < maxNumPredictions)) {
    lastTwoTokens <- tokens[seq(numTokens - 1, numTokens)]
    pattern <- paste0('^', lastTwoTokens[1], ' ', lastTwoTokens[2], ' ')
    matchingTrigramProb <- findTopMatchingNGramProb(
      pattern,
      trigramFreq,
      maxSize = maxNumPredictions - length(predictions))
    predictions <- c(predictions, matchingTrigramProb)
  }
  
  if ((numTokens >= 1) & (length(predictions) < maxNumPredictions)) {
    lastToken <- tokens[numTokens]
    pattern <- paste0('^', lastToken, ' ')
    matchingBigramProb <- findTopMatchingNGramProb(
      pattern,
      bigramFreq,
      maxSize = maxNumPredictions - length(predictions))
    predictions <- c(predictions, matchingBigramProb)    
  }
  
  predictions <- sort(predictions, decreasing = TRUE)
  return(predictions)
}
