ps <- c(0.01, 0.20, 0.25, 0.30, 0.35, 0.40)
for (p in ps) {
  prepareData(p)
  computeNGramFreq(p)
}
