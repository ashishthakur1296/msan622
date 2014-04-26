library(ggplot2)
library(scales)
data(Seatbelts)
sbdata<-data.frame(Seatbelts)
ukts<-ts(sbdata$DriversKilled,start=1969,frequency=12)

#function to extract dates from timeseries
tsdates <- function(ts){
    dur<-12%/%frequency(ts)
    years<-trunc(time(ts))
    months<-(cycle(ts)-1)*dur+1
    yr.mn<-as.data.frame(cbind(years,months))
    dt<-apply(yr.mn,1,function(r){paste(r[1],r[2],'01',sep='/')})
    as.POSIXct(dt,tz='UTC')
  }


# Data Munging

sbdata$dt<-tsdates(ukts)
sbdata$month<-months(sbdata$dt)
sbdata$month <- factor(sbdata$month, levels=c("January", "February", "March","April","May","June","July","August","September","October","November","December"), ordered=TRUE)
sbdata$quarter<-quarters(sbdata$dt)
sbdata$year<-as.character(as.numeric(format(sbdata$dt, "%Y")) )
#+scale_x_date(format = "%b-%Y")

# Multiline Plot
p1<-ggplot(sbdata, aes(x=as.Date(dt))) + theme_bw()+geom_line(data=sbdata,aes(y=drivers,group=1,color='Legend')) + geom_line(data=sbdata,aes(y=DriversKilled,color='Drivers Killed')) +geom_line(data=sbdata,aes(y=rear,group=1,color='Rear')) + geom_line(data=sbdata,aes(y=front,color='Front')) +
labs(list(title="Multi Line Plot : UK Road Accidents 1969 - 1984",x="Date",y='Counts'))+ scale_x_date(labels = date_format("%B %Y"), breaks = date_breaks("years"),expand=c(0,0))+scale_y_continuous(expand=c(0,0))+
  theme(axis.text.x = element_text(size = 10,hjust = 1, angle = 45, colour = "black"),plot.title=element_text(size = 20, colour = "blue"))
p1

p1 + facet_wrap(~ month, ncol = 4) +labs(title="Small Multiples Multiline Plot : UK Road Accidents 1969 - 1984")

#p1 + facet_wrap(~ quarter, ncol = 2)

#Star Plot
p2<-p1+coord_polar()+theme(axis.text.x = element_text(size = 10,angle=0,hjust = 1, colour = "black"),axis.text.y = element_blank(),axis.ticks=element_blank(),panel.border=element_blank(),axis.title=element_blank())+labs(title="Star Plot : UK Road Accidents 1969 - 1984") 
p2

p2 + facet_wrap(~ month, ncol = 4)+ scale_x_date(labels = date_format("%Y")) +labs(title="Small Multiples Star Plot : UK Road Accidents 1969 - 1984")

#p2 + facet_wrap(~ quarter, ncol = 2)

# Heatmap
p <- ggplot(
    sbdata, 
    aes(x = month, y = year)
)

p <-p + geom_tile(aes(fill=DriversKilled))+ scale_fill_gradient(low = "black",high = "red") + coord_fixed(ratio = 1)+scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + labs(list(title="Heat Map : UK Road Accidents Driver Deaths 1969 - 1984",x='Months',y='Year'))+
  theme(legend.position = "right", 
    axis.ticks = element_blank(), 
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1, colour = "black"),
    axis.text.y = element_text(size = 10, hjust = 1, colour = "black"),
    plot.title=element_text(size = 20, colour = "blue"),
    axis.title = element_text(size=15))
   

p

p3 <- p + coord_polar()+theme_bw()+theme(plot.title=element_text(size = 20, colour = "blue"),axis.text.y = element_blank(),axis.ticks=element_blank(),panel.border=element_blank(),axis.title=element_blank())+labs(title="Circular Heatmap : UK Road Accidents 1969 - 1984")#+theme_bw()
p3
