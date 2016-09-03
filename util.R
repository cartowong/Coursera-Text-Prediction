# Common utility functions for this project.

library(tm)

# Bernoulli random variable X, where P(X = 1) = p and P(X = 0) = 1 - p.
rbern <- function(p) {
  runif(n = 1) < p
}

# Read the input file line by line. For each line, write it to the output file with probability p.
sampleText <- function(inputFilePath, outputFilePath, p) {
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

# Tokenize the text document and return a vector of word counts in decreasing order.
# This function performs the following clean up steps:
#   - convert to lowercase
#   - remove punctuation
#   - strip white space
#   - remove stop words
wordFrequencies <- function(filePath) {
  con <- file(filePath, open = 'r')
  on.exit(close(con))
  
  lines <- readLines(con, n = -1L) # read up to the end of the file
  text <- paste(lines, collapse = '\n')
  textSource <- VectorSource(text)
  corpus <- Corpus(textSource)
  
  # Cleaning
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeWords, stopwords('english'))
  
  dtm <- DocumentTermMatrix(corpus)
  freq <- colSums(as.matrix(dtm))
  freq <- sort(freq, decreasing = TRUE)
  freq
}