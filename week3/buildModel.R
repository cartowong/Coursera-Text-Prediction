source('util.R')

blogsTokens <- tokenize('sampleData/en_US.blogs.sample.txt')$tokens
newsTokens <- tokenize('sampleData/en_US.news.sample.txt')$tokens
twitterTokens <- tokenize('sampleData/en_US.twitter.sample.txt')$tokens
combinedTokens <- c(blogsTokens, newsTokens, twitterTokens)

bigramModel <- buildNGramModel(combinedTokens, n = 2)
save(bigramModel, file = 'bigramModel.rData')
