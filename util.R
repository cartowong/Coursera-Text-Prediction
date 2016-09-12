# Common utility functions for this project.

# Read the input file line by line. For each line, write it to the output file with probability p.
sampleText <- function(inputFilePath, outputFilePath, p)
  {
    set.seed(26) # for reproducibility
    
    lines <- readLines(inputFilePath)
    sampleLines <- sample(lines, size = p * length(lines))
    writeLines(sampleLines, outputFilePath)
  }

tokenize <- function(filePath)
  {
    # Read the text file and tokenize it.
    #
    # Args:
    #   filePath {string}
    #            the file path
    #
    # Returns: {list}
    #          a list with the following properties:
    #          - numLines {int}
    #                     the number of lines
    #          - text     {character}
    #                     the text content
    #          - tokens   {character[]}
    #                     a vector of words including two special words {BEGIN} and {END} to indicate
    #                     the begin and end of a sentence
    
    lines <- readLines(filePath)
    text <- paste(lines, collapse = '\n')
    text <- tolower(text)
    text <- gsub('\n+', ' {END} {BEGIN} ', text)
    text <- paste0('{BEGIN} ', text, ' {END}')
    
    tokens <- strsplit(text, split = '[^a-z|A-Z|{|}]+')[[1]]
    
    result = list()
    result$numLines <- length(lines)
    result$text <- text
    result$tokens <- tokens
    result
  }

nGramFreq <- function(tokens, n, sortAsDecreasing = TRUE)
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
    
    shifts <- list(tokens)
    if (n >= 2) {
      for (j in seq(2, n)) {
        shifts[[j]] <- c(shifts[[j - 1]][-1], '.')
      }
    }
    
    nGrams <- Reduce(paste, shifts)
    nGrams <- nGrams[seq(1, length(tokens) - n + 1)]
    
    # return
    if (sortAsDecreasing) {
      sort(table(nGrams, dnn = ''), decreasing = TRUE)
    }
    else {
      table(nGrams, dnn = '')
    }
  }

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

