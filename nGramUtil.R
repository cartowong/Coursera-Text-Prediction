# Utility functions for creating n-gram models.

tokenize <- function(filePath)
  {
    # Read the text file and tokenize it.
    #
    # Args:
    #   filePath {string}
    #            the file path
    #
    # Returns: {character[]}
    #          a vector of words including two special words {BEGIN} and {END} to indicate
    #          the begin and end of a sentence
    
    startTime <- proc.time()
    
    lines <- readLines(filePath)
    text <- paste(lines, collapse = '\n')
    text <- tolower(text)
    text <- gsub('\n+', ' {END} {BEGIN} ', text)
    text <- paste0('{BEGIN} ', text, ' {END}')
    
    tokens <- strsplit(text, split = '[^a-z|A-Z|{|}]+')[[1]]
    
    endTime <- proc.time()
    print(endTime - startTime)
    return(tokens)
  }

nGramFreq <- function(tokens, n, sortAsDecreasing = TRUE, message = TRUE)
  {
    # n-gram Frequencies.
    #
    # Args:
    #   tokens            {character[]}
    #                     a vector of tokens
    #   n                 {int}
    #                     the value of n
    #   sortAsDecreasing  {boolean}
    #                     if true, the returned frequency table will be sorted in decreasing order.
    # Return: {table}
    #         a table whose names are distinct n-grams and values are the frequencies of the n-grams
    
    startTime <- proc.time()
  
    shifts <- list(tokens)
    if (n >= 2) {
      for (j in seq(2, n)) {
        shifts[[j]] <- c(shifts[[j - 1]][-1], '.')
      }
    }
    
    nGrams <- Reduce(paste, shifts)
    nGrams <- nGrams[seq(1, length(tokens) - n + 1)]
    
    if (sortAsDecreasing) {
      freq <- sort(table(nGrams, dnn = ''), decreasing = TRUE)
    }
    else {
      freq <- table(nGrams, dnn = '')
    }
    
    endTime <- proc.time()
    if (message) {
      print(endTime - startTime)
    }
    return(freq)
  }

trimNGramFreq <- function(nGramFreq)
  {
    # Trim n-gram frequencies by removing the n-grams with frequency 1 and those contains the
    # special characters {BEGIN} or {END}.
    #
    # Args:
    #   nGramFreq {table}
    #             n-gram frequencies. The names are n-grams, and the values are the frequencies.
    #
    # Return: {table}
    #         the trimmed n-gram frequency table.
  
    startTime <- proc.time()
    trimmedFreq <- nGramFreq[nGramFreq > 1]
    trimmedFreq <- trimmedFreq[!grepl('BEGIN|END', names(trimmedFreq))]
    
    # What percentage of the n-grams remain?
    p <- length(trimmedFreq) / length(nGramFreq)
    message(paste0(format(100 * (1 - p), digits = 4), '% of the n-grams are trimmed.'))
    
    endTime <- proc.time()
    print(endTime - startTime)
    
    trimmedFreq
}

# This function is deprecated for performance reason.
buildNGramModel <- function(tokens, n)
  {
    # Build n-gram model.
    #
    # Args:
    #   tokens            {character[]}
    #                     a vector of tokens
    #   n                 {int}
    #                     the value of n
    # Return: {list}
    #         A model object which consists of the following properties.
    #         getPrefixFreq   {function}
    #                         Take a prefix (character string) and return the frequency
    #         getLastWordFreq {function}
    #                         Take a prefix (character string) and return a frequency table for
    #                         the following word
    #         time            {proc_time}
    #                         The time that was spent to build this model.
  
    if (n < 2) {
      stop('It is expected that n >= 2.')
    }
    if (length(tokens) < max(n, 5)) {
      stop('Not enough tokens!')
    }
  
    # start time
    startTime <- proc.time()
  
    prefixFreq <- nGramFreq(tokens, n - 1)
    totalPrefixFreq <- sum(prefixFreq)
    
    lastWordFreq <- list()
    lastWordFreq <- lapply(names(prefixFreq), function (prefix) { c() })
    names(lastWordFreq) <- names(prefixFreq)
    for (j in seq(1, length(tokens) - n + 1)) {
      prefix <- paste(tokens[seq(j, j + n - 2)], collapse = ' ')
      word <- tokens[j + n - 1]
      lastWordFreq[[prefix]] <- c(lastWordFreq[[prefix]], word)
    }
    for (prefix in names(lastWordFreq)) {
      lastWordFreq[[prefix]] <- sort(table(lastWordFreq[[prefix]], dnn = ''), decreasing = TRUE)
    }
    
    getPrefixFreq <- function(prefix) {
      ifelse(
        is.null(prefixFreq[prefix]),
        0,
        prefixFreq[prefix])
    }
    
    getTotalPrefixFreq <- function() {
      totalPrefixFreq
    }
    
    getNumPrefixes <- function() {
      length(prefixFreq)
    }
    
    getTopPrefixes <- function(k = 10) {
      head(prefixFreq, n = k)
    }
    
    getLastWordFreq <- function(prefix) {
      if (is.null(lastWordFreq[[prefix]])) {
        table(c())
      }
      else {
        lastWordFreq[[prefix]]
      }
    }
    
    # end time
    endTime <- proc.time()
    print(endTime - startTime)
    
    # return
    list(
      getPrefixFreq = getPrefixFreq,
      getTotalPrefixFreq = getTotalPrefixFreq,
      getNumPrefixes = getNumPrefixes,
      getTopPrefixes = getTopPrefixes,
      getLastWordFreq = getLastWordFreq,
      time = endTime - startTime
    )
  }  
