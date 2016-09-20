library(dplyr)
library(ggplot2)

df1 <-  read.csv('evaluationResult_p.csv')
df1 <- tbl_df(df1)
df1 <- filter(df1, lazy)

g1 <- ggplot(df1, aes(x = p, y = accuracy, color = useQuadgrams)) +
      geom_point(size = 4) +
      geom_line(size = 1) +
      ggtitle('Accuracy vs Data Size') +
      xlab('p') +
      ylab('accuracy')

png(file = 'accuracy_dataSize.png')
print(g1)
dev.off()

g2 <- ggplot(df1, aes(x = p, y = meanPredictionTime, color = useQuadgrams)) +
      geom_point(size = 4) +
      geom_line(size = 1) +
      ggtitle('Mean Prediction Time vs Data Size') +
      xlab('p') +
      ylab('mean prediction time (in seconds)')

png(file = 'meanPredictionTime_dataSize.png')
print(g2)
dev.off()

df2 <- read.csv('evaluationResult_numPredictions.csv')

g3 <- ggplot(df2, aes(x = numPredictions, y = accuracy)) +
      geom_point(size = 4) +
      geom_line(size = 1) +
      ggtitle('Accuracy vs Number of Predictions') +
      xlab('number of predictions') +
      ylab('accuracy')

png(file = 'accuracy_numPredictions.png')
print(g3)
dev.off()

g4 <- ggplot(df2, aes(x = numPredictions, y = meanPredictionTime)) +
      geom_point(size = 4) +
      geom_line(size = 1) +
      ggtitle('Mean Prediction Time vs Number of Predictions') +
      xlab('number of predictions') +
      ylab('mean prediction time (in seconds)')

png(file = 'meanPredictionTime_numPredictions.png')
print(g4)
dev.off()
