library(readtext)
x<-"./readData.txt"
data<-readtext(x)
library(xgboost)
library(tm)
library(text2vec)
library(devtools)
library(readr)
library(tools)       # No tiene que ser isntalado. It's a base pacakge
library(SnowballC)
library(RTextTools)
library(RFakeNewsDetector)

res<-modelSVM(data$text)


save<- "./result-nbase.txt"

sink(save)
cat(res)
sink()

