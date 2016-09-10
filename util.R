# Common utility functions for this project.

# Read the input file line by line. For each line, write it to the output file with probability p.
sampleText <- function(inputFilePath, outputFilePath, p) {
  
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
  #          - tokens   {character}
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
