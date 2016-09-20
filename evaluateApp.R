source('data/prepareData.R')
source('nGramFreq/computeNGramFreq.R')
source('evaluate.R')

# This function returns a task (no-argument function) which performs an evaluation
# based on the given parameters.
createTask <- function(description, p, useQuadgrams, maxNumPredictions, lazy) {
  
  description <- description
  p <- p
  useQuadgrams <- useQuadgrams
  lazy <- lazy
  maxNumPredictions <- maxNumPredictions
  
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
      predictNextWord(prefix, nGramFreqList, maxNumPredictions = maxNumPredictions, lazy = lazy)
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
taskInfoList <- c()
pArray <- c(0.20)
useQuadgramsArray <- c(TRUE)
lazyArray <- c(TRUE)
numPredictionsArray <- 1:10
for (p in pArray) {
  dataDir <- paste('data', as.integer(100 * p), sep = '/')
  if (!dir.exists(dataDir)) {
    prepareData(p)
  }
  
  nGramFreqDir <- paste('nGramFreq', as.integer(100 * p), sep = '/')
  if (!dir.exists(nGramFreqDir)) {
    computeNGramFreq(p)
  }
  
  for (useQuadgrams in useQuadgramsArray) {
    for (lazy in lazyArray) {
      for (numPredictions in numPredictionsArray) {
        description <- paste(
          paste('p', p, sep = ' = '),
          paste('useQuadgrams', useQuadgrams, sep = ' = '),
          paste('lazy', lazy, sep = ' = '),
          paste('numPredictions', numPredictions, sep = ' = '),
          sep = ', ')
        task <- createTask(description, p, useQuadgrams, maxNumPredictions = numPredictions,  lazy = lazy)
        tasks <- c(tasks, task)
        
        # Task info
        taskInfo <- c()
        taskInfo$p <- p
        taskInfo$useQuadgrams <- useQuadgrams
        taskInfo$lazy <- lazy
        taskInfo$numPredictions <- numPredictions
        taskInfoList <- c(taskInfoList, taskInfo) 
      }
    }
  }
}

# Run the tasks.
results <- lapply(tasks, function(task) { task() })
save(results, file = 'results.rData')

# Append variables to the results.
for (j in seq_along(results)) {
  results[[j]]$p <- taskInfoList[[1 + 4 * (j - 1)]]
  results[[j]]$useQuadgrams <- taskInfoList[[2 + 4 * (j - 1)]]
  results[[j]]$lazy <- taskInfoList[[3 + 4 * (j - 1)]]
  results[[j]]$numPredictions <- taskInfoList[[4 * j]]
}
save(results, file = 'results.rData')

# Format the result.
numResults <- length(results)
ps <- rep(NA, numResults)
useQuadgrams <- rep(NA, numResults)
lazies <- rep(NA, numResults)
numPredictions <- rep(NA, numResults)
accuracies <- rep(NA, numResults)
meanPredictionTimes <- rep(NA, numResults)
evaluationTimes <- rep(NA, numResults)
for (j in seq_along(results)) {
  result <- results[[j]]
  ps[j] <- result$p
  useQuadgrams[j] <- result$useQuadgrams
  lazies[j] <- result$lazy
  numPredictions[j] <- result$numPredictions
  accuracies[j] <- result$accuracy
  meanPredictionTimes[j] <- result$meanPredictionTime
  evaluationTimes[j] <- result$evaluationTime
}

# Write the formatted results into a data frame.
formattedResults <- data.frame(
  p = ps,
  useQuadgrams = useQuadgrams,
  lazy = lazies,
  accuracy = accuracies,
  numPredictions = numPredictions,
  meanPredictionTime = meanPredictionTimes,
  evaluationTime = evaluationTimes
)
save(formattedResults, file = 'formattedResults.rData')
