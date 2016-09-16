# Utility functions for sampling, splitting, and combining text documents.

sampleText <- function(inputFilePath, outputFilePath, p, seed = 26)
  {
    # Sample text.
    #
    # Args:
    #   inputFilePath   {character}
    #                   input file path
    #   outputFilePath  {character}
    #                   output file path
    #   p               {numeric}
    #                   Each line of the input file will be written to the output file with
    #                   probability p
    #   seed            {integer}
    #                   Optional. Random seed.
    #
    # Return: {void}
  
    startTime <- proc.time()
  
    set.seed(seed) # for reproducibility
    
    lines <- readLines(inputFilePath)
    sampleLines <- sample(lines, size = p * length(lines))
    writeLines(sampleLines, outputFilePath)
    
    endTime <- proc.time()
    print(endTime - startTime)
  }

splitText <- function(inputFilePath, outputFilePaths, prob, seed = 26)
  {
    # Split text.
    #
    # Args:
    #   inputFilePath    {character}
    #                    input file path
    #   outputFilePaths  {character[]}
    #                    the vector of output file paths
    #   prob             {numeric[]}
    #                    a numeric vector of probabilities. The length of this vector should be
    #                    equal to the number of output file paths 
    #   seed            {integer}
    #                   Optional. Random seed.
    #
    # Return: {void}
  
    startTime <- proc.time()
    
    set.seed(seed) # for reproducibility
  
    # Input file connection.
    inputConnection <- file(inputFilePath, open = 'r')
    
    # Output file connection.
    outputConnections <- lapply(
      outputFilePaths,
      function(outputFilePath) { file(outputFilePath, open = 'w') })
    
    while (TRUE) {
      line <- readLines(inputConnection, 1)
      if (length(line) > 0) {
        outputConnection <- sample(outputConnections, size = 1, prob = prob)[[1]]
        writeLines(line, con = outputConnection)
      }
      else {
        break
      }
    }
    
    # Close the file connections.
    close(inputConnection)
    for (outputConnection in outputConnections) {
      close(outputConnection)
    }
    
    endTime <- proc.time()
    print(endTime - startTime)
  }

combineText <- function(inputFilePaths, outputFilePath)
  {
    # Combine text.
    #
    # Args:
    #   inputFilePaths  {character[]}
    #                   the vector of input file paths
    #   outputFilePath  {character}
    #                   the output file path
    #
    # Return: {void}
  
    startTime <- proc.time()
    
    outputConnection <- file(outputFilePath, open = 'w')
    
    for (inputFilePath in inputFilePaths) {
      lines <- readLines(inputFilePath)
      writeLines(lines, outputConnection)
    }
    
    close(outputConnection)
    
    endTime <- proc.time()
    print(endTime - startTime)
  }
