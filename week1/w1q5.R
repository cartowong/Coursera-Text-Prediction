# The one tweet in the en_US twitter data set that matches the word "biostats" says what?

twitterFilePath <- 'rawData/final/en_US/en_US.twitter.txt'
twitterCon <- file(twitterFilePath, open = 'r')
twitterLines <- readLines(twitterCon, n = -1L)
close(twitterCon)

continsBiostats <- sapply(twitterLines, function (line) { grepl('biostats', line) })
which(continsBiostats)