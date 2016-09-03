# What is the length of the longest line seen in any of the three en_US data sets?

longestLineLength <- function(filePath) {
  con <- file(filePath, open = 'r')
  on.exit(close(con))
  
  lines <- readLines(con, n = -1L)
  max(sapply(lines, nchar))
}

blogsLongestLineLength <- longestLineLength('rawData/final/en_US/en_US.blogs.txt')
newsLongestLineLength <- longestLineLength('rawData/final/en_US/en_US.news.txt')
twitterLongestLineLength <- longestLineLength('rawData/final/en_US/en_US.twitter.txt')
