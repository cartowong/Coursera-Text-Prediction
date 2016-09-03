# In the en_US twitter data set, if you divide the number of lines where the word "love" (all
# lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do
# you get?

twitterFilePath <- 'rawData/final/en_US/en_US.twitter.txt'
twitterCon <- file(twitterFilePath, open = 'r')
twitterLines <- readLines(twitterCon, n = -1L)
close(twitterCon)

containsLove <- sapply(twitterLines, function (line) { grepl('love', line) })
containsHate <- sapply(twitterLines, function (line) { grepl('hate', line) })

loveCount <- sum(containsLove)
hateCount <- sum(hateCount)

# answer
loveCount / hateCount
