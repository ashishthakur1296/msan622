library(sqldf)
library(ggplot2)
library(scales)
Bilateral_Remittance_Matrix_2010_csv <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2010_csv.csv")
Bilateral_Remittance_Matrix_2011_csv <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2011_csv.csv")
Bilateral_Remittance_Matrix_2012_csv <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2012_csv.csv")
BRM2010<-Bilateral_Remittance_Matrix_2010_csv
BRM2011<-Bilateral_Remittance_Matrix_2011_csv
BRM2012<-Bilateral_Remittance_Matrix_2012_csv
BRM2010$Total_num<-as.numeric(sub(",", "",as.character(BRM2010$Total))) 
BRM2011$Total_num<-as.numeric(sub(",", "",as.character(BRM2011$Total))) 
BRM2012$Total_num<-as.numeric(sub(",", "",as.character(BRM2012$Total))) 
BRM2010$Year<-'2010'
BRM2011$Year<-'2011'
BRM2012$Year<-'2012'
BRM <- rbind(BRM2010,BRM2011,BRM2012)
