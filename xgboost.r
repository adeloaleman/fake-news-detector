library(readtext)
x<-"./readData.txt"
# x<-"/home/adelo/1-system/desktop/downloads/myapp/readData.txt"
#x<-"D:/RWebProject/ShinyApp-ver1/Ver03-ahsan/readData.txt"
data<-readtext(x)
#print(y$text)
library(xgboost)
library(tm)
library(text2vec)
library(readr)
library(tools)       # No tiene que ser isntalado. It's a base pacakge
library(SnowballC)
library(RTextTools)
library(FakeNewsDetector)
print(data$text)

res<-modelXGBoost(data$text)


save<- "./result-xgboost.txt"
# save<- "/home/adelo/1-system/desktop/downloads/myapp/result-xgboost.txt"

sink(save)
cat(res)
sink()

