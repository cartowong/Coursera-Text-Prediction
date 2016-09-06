source('util.R')

blogsSampleFilePath <- 'sampleData/en_US.blogs.sample.txt'

# Bigram frequencies
blogsTokens <- tokenize(blogsSampleFilePath)
blogsTokens2 <- c(blogsTokens[-1], ".")
bigrams <- paste(blogsTokens, blogsTokens2)
freq2 <- sort(table(bigrams), decreasing = TRUE)

# Trigram frequencies
blogsTokens3 <- c(blogsTokens2[-1], ".")
trigrams <- paste(blogsTokens, blogsTokens2, blogsTokens3)
freq3 <- sort(table(trigrams), decreasing = TRUE)