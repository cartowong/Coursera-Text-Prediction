source('data/prepareData.R')
source('nGramFreq/computeNGramFreq.R')
source('evaluate.R')

# This function returns a task (no-argument function) which performs an evaluation
# based on the given parameters.
createTask <- function(description, p, useQuadgrams, lazy) {
  
  description <- description
  p <- p
  useQuadgrams <- useQuadgrams
  lazy <- lazy
  
  function() {
    startTime <- proc.time()
    message(paste('Task description:', description))
   
    # Load the test tokens.
    testTokensDir <- paste('data', as.integer(100 * p), sep = '/')
    testTokensFilePath <- paste(testTokensDir, 'testTokens.rData', sep = '/')
    load(testTokensFilePath) 
    
    testNGrams <- generateTestNGrams(testTokens, n = 4)
    
    # Load the n-gram frequencies.
    nGramFreqDir <- paste('nGramFreq', as.integer(100 * p), sep = '/')
    nGramFreqFilePath <- paste(nGramFreqDir, 'trimmedFreq.rData', sep = '/')
    load(nGramFreqFilePath)
    
    # Construct the list of n-gram frequency tables.
    nGramFreqList <- list(trimmedTrigramFreq, trimmedBigramFreq)
    if (useQuadgrams) {
      nGramFreqList <- list(trimmedQuadgramFreq, trimmedTrigramFreq, trimmedBigramFreq)
    }
    
    predict <- function(prefix) {
      predictNextWord(prefix, nGramFreqList, lazy = lazy)
    }
    
    result <- evaluateAccuracyAndPerformance(predict, testNGrams)
    result$description <- description
    
    print(paste0('accuracy = ', result$accuracy))
    print(paste0('meanPredictionTime = ', result$meanPredictionTime))
    
    endTime <- proc.time()
    print(endTime - startTime) 
    result$evaluationTime <- endTime - startTime
    
    # Clean up: remove all variables except for 'result' and functions.
    rm(list = setdiff(setdiff(ls(), lsf.str()), 'result'))
    gc()
    
    return(result)
  }  
}

tasks <- c()
for (p in c(0.01, 0.2, 0.3)) {
  for (useQuadgrams in c(TRUE, FALSE)) {
    for (lazy in c(TRUE, FALSE)) {
      description <- paste(
        paste('p', p, sep = ' = '),
        paste('useQuadgrams', useQuadgrams, sep = ' = '),
        paste('lazy', lazy, sep = ' = '),
        sep = ', ')
      task <- createTask(description, p, useQuadgrams, lazy)
      tasks <- c(tasks, task)
    }
  }
}

# Run the tasks.
results <- lapply(tasks, function(task) { task() })
save(results, file = 'results.rData')
