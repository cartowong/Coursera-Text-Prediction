source('util.R')

blogsWordFreqFilePath <- 'sampleData/blogsWordFreq.rData'
newsWordFreqFilePath <- 'sampleData/newsWordFreq.rData'
twitterWordFreqFilePath <- 'sampleData/twitterWordFreq.rData'

if (!file.exists(blogsWordFreqFilePath)) {
  blogsWordFreq <- wordFrequencies('sampleData/en_US.blogs.sample.txt')
  save(blogsWordFreq, file = blogsWordFreqFilePath)
}

if (!file.exists(newsWordFreqFilePath)) {
  newsWordFreq <- wordFrequencies('sampleData/en_US.news.sample.txt')
  save(newsWordFreq, file = newsWordFreqFilePath)
}

if (!file.exists(twitterWordFreqFilePath)) {
  twitterWordFreq <- wordFrequencies('sampleData/en_US.twitter.sample.txt')
  save(twitterWordFreq, file = twitterWordFreqFilePath)
}
