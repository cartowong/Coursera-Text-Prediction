source('data/prepareData.R')
source('nGramFreq/computeNGramFreq.R')

ps <- c(0.01, 0.20, 0.25, 0.30)
for (p in ps) {
  prepareData(p)
  computeNGramFreq(p)
}
