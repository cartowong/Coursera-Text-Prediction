# Common utility functions for this project.

library(tm)

# Read the input file line by line. For each line, write it to the output file with probability p.
sampleText <- function(inputFilePath, outputFilePath, p) {
  
  set.seed(26) # for reproducibility
  
  lines <- readLines(inputFilePath)
  sampleLines <- sample(lines, size = p * length(lines))
  writeLines(sampleLines, outputFilePath)
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
  
  lines <- readLines(filePath)
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
