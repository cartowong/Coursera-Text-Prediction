buildBigramModel <- function(tokens) {
  
  # Bigram counts. The names are unigrams (prefixes). For each unigram prefix, the value is a list
  # whose names are the words which follow the prefix, and whose values are the counts.
  bigramCounts <- list()
  
  addBigram <- function(word1, word2, bigramCounts) {
    if (word1 %in% names(bigramCounts)) {
      counts <- bigramCounts[[word1]]
      counts[word2] <- ifelse(
        word2 %in% names(counts),
        counts[word2] + 1,
        1
      )
      bigramCounts[[word1]] <- counts
    }
    else {
      bigramCounts[[word1]] <- c()
      bigramCounts[[word1]][word2] <- 1
    }
    
    # Return
    bigramCounts
  }
  
  for (j in seq(1, length(tokens) - 1)) {
    bigramCounts <- addBigram(tokens[j], tokens[j + 1], bigramCounts)
  }
 
  # Compute unigram counts.
  unigramCounts <- sapply(names(bigramCounts), function(word1) { sum(bigramCounts[[word1]]) })
  totalUnigramCounts <- sum(unigramCounts)
  
  getUnigramCount <- function(word1) {
    ifelse(word1 %in% names(unigramCounts), unigramCounts[word1], 0)
  }
  
  getBigramCount <- function(word1, word2) {
    ifelse(
      (word1 %in% names(bigramCounts)) & (word2 %in% names(bigramCounts[[word1]])),
      bigramCounts[[word1]][word2],
      0)
  }
  
  getUnigramLogProb <- function(word1) {
    ifelse(
      word1 %in% names(unigramCounts),
      log(unigramCounts[word1]) - log(totalUnigramCounts),
      - Inf)
  }
  
  getLogCondProb <- function(word, on) {
    unigramCount <- getUnigramCount(on)
    if (unigramCount == 0) {
      stop(paste('unigram', on, 'not found'))
    }
      
    bigramCount <- getBigramCount(on, word)
    ifelse(bigramCount > 0, log(bigramCount) - log(unigramCount), - Inf)
  }
  
  # Return
  list(
    getUnigramCount = getUnigramCount,
    getBigramCount = getBigramCount,
    getUnigramLogProb = getUnigramLogProb,
    getLogCondProb = getLogCondProb
  )
}
