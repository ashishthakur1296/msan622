#Loading Data and Data Manipulation
library(ggplot2) 
library(sqldf)
library(scales)
data(movies) 
data(EuStockMarkets)
mvs_gt0<-sqldf('select * from movies where budget>0')
genre <- rep(NA, nrow(mvs_gt0))
count <- rowSums(mvs_gt0[, 18:24])
genre[which(count > 1)] = "Mixed"
genre[which(count < 1)] = "None"
genre[which(count == 1 & mvs_gt0$Action == 1)] = "Action"
genre[which(count == 1 & mvs_gt0$Animation == 1)] = "Animation"
genre[which(count == 1 & mvs_gt0$Comedy == 1)] = "Comedy"
genre[which(count == 1 & mvs_gt0$Drama == 1)] = "Drama"
genre[which(count == 1 & mvs_gt0$Documentary == 1)] = "Documentary"
genre[which(count == 1 & mvs_gt0$Romance == 1)] = "Romance"
genre[which(count == 1 & mvs_gt0$Short == 1)] = "Short"
mvs_gt0$genre<-genre

eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

#Plot 1
d<-ggplot(mvs_gt0,aes(budget,rating))
d+geom_point()+theme_bw()+scale_x_continuous(labels = dollar)+labs(title = " Budget vs Rating Scatter Plot",x = "Budget", y = "Rating")
ggsave(file = "hw1-scatter.png", dpi = 150, width = 12, height = 8)


#Plot 2
q2_data<-sqldf('Select genre,count(*) as count from mvs_gt0 group by 1')
q2<-ggplot(q2_data,aes(genre,count))
q2+geom_bar(stat='identity',fill="blue", colour="darkgreen")+theme_bw()+labs(title = " Bar Chart - Genre",x = "Genre", y = "Count")
ggsave(file = "hw1-bar.png", dpi = 150, width = 12, height = 8)


#Plot 3
d+geom_point()+facet_wrap(~genre)+theme_bw()+scale_x_continuous(labels = dollar)+labs(title = " Budget vs Rating Scatter Facet Plot",x = "Budget", y = "Rating")
ggsave(file = "hw1-multiples.png", dpi = 150, width = 18, height = 10)

#Plot 4
q4<-ggplot(eu,aes(time,DAX))
q4+geom_line()+theme_bw()+scale_y_continuous(labels = comma)+geom_line(aes(y=SMI),colour='blue')+geom_line(aes(y=CAC,colour='red',label='Deposit Count'))+geom_line(aes(y=FTSE,colour='darkgreen',label='Deposit Count'))+labs(title = "Stock Index Trend - 1990's",x = "Years", y = "Index Value")+ theme(legend.position="none")
ggsave(file = "hw1-multilines.png", dpi = 150, width = 12, height = 8)