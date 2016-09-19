source('data/prepareData.R')
source('nGramFreq/computeNGramFreq.R')
source('evaluate.R')

ps <- c(0.01, 0.20, 0.25, 0.30, 0.35, 0.40)
for (p in ps) {
  prepareData(p)
  computeNGramFreq(p)
}

# Evaluate the accuracy of the n-gram model for different values of p.
accuracies <- rep(0, length(ps))
meanPredictionTimes <- rep(0, length(ps))
for (j in seq_along(ps)) {
  p <- ps[j]
  message(paste0('Evaluating the accuracy for p = ', p, '...'))
  result <- evaluateNGramModel(p)
  accuracies[j] <- result$accuracy
  meanPredictionTimes[j] <- result$meanPredictionTime
  
  print(paste0('accuracy = ', result$accuracy))
  print(paste0('meanPredictionTime = ', result$meanPredictionTime))
}
write.table(
  list(p = ps, accuracy = accuracies, meanPredictionTime = meanPredictionTimes),
  file = 'accuracy.txt', row.names = FALSE)
