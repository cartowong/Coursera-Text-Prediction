# Common utility functions for this project.

library(tm)

# Bernoulli random variable X, where P(X = 1) = p and P(X = 0) = 1 - p.
rbern <- function(p) {
  runif(n = 1) < p
}

# Read the input file line by line. For each line, write it to the output file with probability p.
sampleText <- function(inputFilePath, outputFilePath, p) {
  
  set.seed(26) # for reproducibility
  
  input <- file(inputFilePath, open = 'r')
  on.exit(close(input))
  output <- file(outputFilePath, open = 'w')
  on.exit(close(output))
  
  while (TRUE) {
    line <- readLines(input, 1)
    if (length(line) > 0 ) {
      if (rbern(p)) {
        writeLines(line, output)
      }
    }
    else {
      break
    }
  }
}

tokenize <- function(filePath,
                     to.lower = FALSE,
                     remove.punctuation = FALSE,
                     strip.whitespace = FALSE,
                     remove.stopwords = FALSE)
{
  # Read the text file and tokenize it.
  #
  # Args:
  #   filePath {string}
  #            the file path
  #   to.lower {boolean}
  #            Should it convert characters to lower case?
  #   remove.punctuation {boolean}
  #                      Should it remove punctuation?
  #   strip.whitespace   {boolean}
  #                      Should it strip whitespace?
  #   remove.stopwords   {boolean}
  #                      Should it remove stopwords?
  #
  # Returns: {list}
  #          a list with the following properties:
  #          - numLines {int}
  #                     the number of lines
  #          - text     {character}
  #                     the clean text
  #          - tokens   {character}
  #                     a vector of words
  
  con <- file(filePath, open = 'r')
  on.exit(close(con))
  
  lines <- readLines(con, n = -1L) # read up to the end of the file
  text <- paste(lines, collapse = '\n')
  textSource <- VectorSource(text)
  corpus <- Corpus(textSource)
  
  # Cleaning
  if (to.lower) {
    corpus <- tm_map(corpus, content_transformer(tolower))
  }
  if (remove.punctuation) {
    corpus <- tm_map(corpus, removePunctuation)
  }
  if (strip.whitespace) {
    corpus <- tm_map(corpus, stripWhitespace)
  }
  if (remove.stopwords) {
    corpus <- tm_map(corpus, removeWords, stopwords('english'))
  }
  
  cleanText <- corpus[[1]]$content
  tokens <- strsplit(cleanText, split = '[^a-z]+')[[1]]
  
  result = list()
  result$numLines <- length(lines)
  result$text <- cleanText
  result$tokens <- tokens
  result
}
