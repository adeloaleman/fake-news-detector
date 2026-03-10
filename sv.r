library(readtext)
x<-"./readData.txt"
# x<-"/home/adelo/1-system/desktop/downloads/myapp/readData.txt"
data<-readtext(x)
print (data$text)
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



save<- "./result-sv.txt"
# save<- "/home/adelo/1-system/desktop/downloads/myapp/result-sv.txt"

sink(save)
cat(res)
sink()

