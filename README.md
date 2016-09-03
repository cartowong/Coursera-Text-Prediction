# Data Science Capstone (by Johns Hopkins University through Coursera)

This repository contains my work to the data science capstone project. It is the last course in the
[Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science). In this
7-week project, we are asked to perform text mining, create a text prediction model, and build a
Shiny app which takes a phrase as input and predicts the next word.

# Data set

We will use the [capstone dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
provided by SwiftKey. The files are named LOCALE.SOURCE.txt where LOCALE is the each of the four locales
*en_US*, *de_DE*, *ru_RU* and *fi_FI*, and SOURCE is *blogs*, *news*, or *twitter*. The data is from
a corpus called [HC Corpora](www.corpora.heliohost.org). See the readme file at [http://www.corpora.heliohost.org/aboutcorpus.html](http://www.corpora.heliohost.org/aboutcorpus.html)
for details on the corpora available. The files have been language filtered but may still contain some
foreign text.

# File organization

The files are basically organized by week. Shared scripts are saved in the root directory. Below
are the sub-directories.

* `rawData`: The raw dataset is stored in this directory. We download the dataset from internet,
  unzip it, and save the files in this directory. No additional processing or transformation is
  performed to these files. Note that the raw data files are not under version control, but the
  script for downloading and unzipping the file is in `downloadData.R`.
  
* `sampleData`: Due to the size of the dataset, a lot of our analysis will be performed on a subset
  of the raw dataset. The script for generating the sample data files is in `util.R` (under the
  root directory).
  
* `weekX` (where X = 1, 2,  ..., 7): In each week we store the script for that week in a separate
  directory.  