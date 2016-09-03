dataFileURL <- 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
rawDataDir <- 'rawData'
rawDataFileName <- 'data.zip'
rawDataFilePath <- paste0(rawDataDir, '/', rawDataFileName)

if (!file.exists(rawDataFilePath)) {
  download.file(url = dataFileURL, destfile = rawDataFilePath)
  unzip(zipfile = rawDataFilePath, exdir = rawDataDir)
}
