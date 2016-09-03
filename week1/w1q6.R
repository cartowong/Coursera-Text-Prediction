# How many tweets have the exact characters "A computer once beat me at chess, but it was no match
# for me at kickboxing". (I.e. the line matches those characters exactly.)

twitterFilePath <- 'rawData/final/en_US/en_US.twitter.txt'
twitterCon <- file(twitterFilePath, open = 'r')
twitterLines <- readLines(twitterCon, n = -1L)
close(twitterCon)

sentence <- 'A computer once beat me at chess, but it was no match for me at kickboxing'
sum(twitterLines == sentence)
