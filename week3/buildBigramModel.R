source('util.R')
source('bigramModel.R')

blogsStartTime <- proc.time()
blogsTokens <- tokenize('sampleData/en_US.blogs.sample.txt')$tokens
blogsModel <- buildBigramModel(blogsTokens)
blogsEndTime <- proc.time()
blogsTime <- blogsEndTime - blogsStartTime
save(blogsTokens, blogsModel, blogsTime, file = 'week3/blogs.rData')

newsStartTime <- proc.time()
newsTokens <- tokenize('sampleData/en_US.news.sample.txt')$tokens
newsModel <- buildBigramModel(newsTokens)
newsEndTime <- proc.time()
newsTime <- newsEndTime - newsStartTime
save(newsTokens, newsModel, newsTime, file = 'week3/news.rData')

twitterStartTime <- proc.time()
twitterTokens <- tokenize('sampleData/en_US.twitter.sample.txt')$tokens
twitterModel <- buildBigramModel(twitterTokens)
twitterEndTime <- proc.time()
twitterTime <- twitterEndTime - twitterStartTime
save(twitterTokens, twitterModel, twitterTime, file = 'week3/twitter.rData')


combinedStartTime <- proc.time()
combinedTokens <- c(blogsTokens, newsTokens, twitterTokens)
combinedModel <- buildBigramModel(combinedTokens)
combinedEndTime <- proc.time()
combinedTime <- combinedEndTime - combinedStartTime
save(combinedTokens, combinedModel, combinedTime, file = 'week3/combined.rData')