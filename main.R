source('data/prepareData.R')
source('nGramFreq/computeNGramFreq.R')

ps <- c(0.01, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4)
for (p in ps) {
  dataDir <- paste('data', as.integer(100 * p), sep = '/')
  if (!dir.exists(dataDir)) {
    prepareData(p)
    computeNGramFreq(p)
  }
}
