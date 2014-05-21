library(d3Network)
library(leafletR)
library(ggplot2)
library(shiny)
library(sqldf)
library(scales)
library(maps)
library(ggmap)
library(reshape)

#source('leaflet.r')
loadData <-function(){
# Read Data
#BRM2010 <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2010_csv.csv")
#BRM2011 <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2011_csv.csv")
#BRM2012 <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2012_csv.csv")
BRM2010 <- read.csv("Bilateral_Remittance_Matrix_2010_csv.csv")
BRM2011 <- read.csv("Bilateral_Remittance_Matrix_2011_csv.csv")
BRM2012 <- read.csv("Bilateral_Remittance_Matrix_2012_csv.csv")

#Removing Total Column
BRM2010<-BRM2010[,!(names(BRM2010) %in% 'Total')]
BRM2011<-BRM2011[,!(names(BRM2011) %in% 'Total')]
BRM2012<-BRM2012[,!(names(BRM2012) %in% 'Total')]

#Filtering commas
BRM2010[,2:ncol(BRM2010)] <- lapply(BRM2010[,2:ncol(BRM2010)],function(x){as.numeric(gsub(",", "", x))})
BRM2011[,2:ncol(BRM2011)] <- lapply(BRM2011[,2:ncol(BRM2011)],function(x){as.numeric(gsub(",", "", x))})
BRM2012[,2:ncol(BRM2012)] <- lapply(BRM2012[,2:ncol(BRM2012)],function(x){as.numeric(gsub(",", "", x))})



BRM2010$year<-'2010'
BRM2011$year<-'2011'
BRM2012$year<-'2012'
# Remove last row
BRM2010 <- BRM2010[-nrow(BRM2010),]
BRM2011 <- BRM2011[-nrow(BRM2011),]
BRM2012 <- BRM2012[-nrow(BRM2012),]
# Melt
BRM2010_m<-melt(BRM2010)
BRM2011_m<-melt(BRM2011)
BRM2012_m<-melt(BRM2012)


BRM2010_f<-sqldf('Select country_sard as origin_country,variable as destination_country,value as Amount,year from BRM2010_m')
BRM2011_f<-sqldf('Select country_sard as origin_country,variable as destination_country,value as Amount,year from BRM2011_m')
BRM2012_f<-sqldf('Select country_sard as origin_country,variable as destination_country,value as Amount,year from BRM2012_m')

BRM <- rbind(BRM2010_f,BRM2011_f,BRM2012_f)
return(BRM)
}
# common data
globalData <- loadData()

# Bar Plot generation
get_Bar_Out<-function(df, countryCount,year){

    #View(df)
	
	bar_data<-sqldf(paste("Select origin_country,sum(Amount) as Total_Amount from df where year=",year," group by 1 order by 2 desc limit",countryCount) )
	# Need to make it in decreasing order
	bar_data$origin_country <- factor(bar_data$origin_country,levels = bar_data$origin_country,ordered = TRUE)
	bar_data$origin_country <- factor(bar_data$origin_country,levels(bar_data$origin_country)[nrow(bar_data):1])
	bp<-ggplot(bar_data,aes(origin_country,Total_Amount))
	bp<-bp+geom_bar(stat='identity',fill="blue", colour="darkgreen",alpha=.6)+theme_bw()+labs(title = "Remittance Outflow",x = "Sending Country", y = "Amount Transferred (in million Dollars)")+scale_y_continuous(expand=c(0,0),labels=comma)+coord_flip()+
	theme(
    axis.ticks.y = element_blank(), 
    axis.text.x = element_text(size = 20, colour = "black"),
    axis.text.y = element_text(size = 20, hjust = 1, colour = "black"),
    plot.title=element_text(size = 40, colour = "brown"),
    axis.title = element_text(size=30,colour= "brown"))
	bp<-bp+
    theme( # remove the vertical grid lines
           panel.grid.major.y = element_blank(),panel.border = theme_blank()
           # explicitly set the horizontal lines (or they will disappear too)
           #panel.grid.major.x = element_line( size=.1, color="black" ) 
    )
    return(bp)
}
get_Bar_In<-function(df, countryCount,year){

    #View(df)
	bar_data<-sqldf(paste("Select destination_country,sum(Amount) as Total_Amount from df where year=",year," group by 1 order by 2 desc limit",countryCount) )
	# Need to make it in decreasing order
	bar_data$destination_country <- factor(bar_data$destination_country,levels = bar_data$destination_country,ordered = TRUE)
	bar_data$destination_country <- factor(bar_data$destination_country,levels(bar_data$destination_country)[nrow(bar_data):1])
	bp<-ggplot(bar_data,aes(destination_country,Total_Amount))
	bp<-bp+geom_bar(stat='identity',fill="blue", colour="darkgreen",alpha=.6)+theme_bw()+labs(title = "Remittance Inflow",x = "Receiving Country", y = "Amount Received (in million Dollars)")+scale_y_continuous(expand=c(0,0),labels=comma)+coord_flip()+
	theme(
    axis.ticks.y = element_blank(), 
    axis.text.x = element_text(size = 20, colour = "black"),
    axis.text.y = element_text(size = 20, hjust = 1, colour = "black"),
    plot.title=element_text(size = 40, colour = "brown"),
    axis.title = element_text(size=30,colour= "brown"))
	bp<-bp+
    theme( # remove the vertical grid lines
           panel.grid.major.y = element_blank(),panel.border = theme_blank()
           # explicitly set the horizontal lines (or they will disappear too)
           #panel.grid.major.x = element_line( size=.1, color="black" ) 
    )
    return(bp)
}

#Shiny Server Code:
shinyServer(function(input, output,session) {
  localFrame<-globalData
  output$bar_plot1<-
    renderPlot({
    p<-get_Bar_Out(df=globalData,
                  countryCount=input$countryCount, 
                  year=input$year_barp
                  )
    print(p)
    },width=1200,height=800)
  
  output$bar_plot2<-
    renderPlot({
    p<-get_Bar_In(df=globalData,
                  countryCount=input$countryCount, 
                  year=input$year_barp
                  )
    print(p)
    },width=1200,height=800)
  
    
  output$world_map<-
    renderPlot({
	if (input$flow == "Outflow") {
        df<-sqldf(paste('Select origin_country as region,sum(Amount) as Amount from globalData where year=',input$year_heatw,'group by 1'))
		View(df)
			}
		else if (input$flow == "Inflow") {
        df<-sqldf(paste('Select destination_country as region,sum(Amount) as Amount from globalData where year=',input$year_heatw, 'group by 1'))
			}
	df$region[df$region=='United States']<-'USA'
	df$region[df$region=='Russian Federation']<-'USSR'
	map.world <- map_data(map = "world")
	zoro <- merge(map.world,df,sort=FALSE,by = "region")
	zoro <- zoro[order(zoro$order), ]
	p1 <- ggplot(zoro, aes(x = long, y = lat, group = group, fill = Amount))
	#p1 <- ggplot(zoro, aes(x = long, y = lat, group = group))
	p1 <- p1 + geom_polygon() # fill areas
	p1 <- p1 + labs(title = "World Map : Remittances Flow") + theme_bw()
	p1 <- p1 + theme(plot.title=element_text(size = 20, colour = "blue"),axis.text.y = element_blank(),axis.text.x = element_blank(),axis.ticks=element_blank(),panel.border=element_blank(),axis.title=element_blank())
	p1 <- p1 + opts(panel.grid.major = theme_blank(),
    panel.grid.minor = theme_blank(),
    panel.border = theme_blank(),
    panel.background = theme_blank()) 	
	print(p1)
    },width=1200,height=800)
   
  output$heat<- renderPlot({	
	final_qw <- sqldf(paste('Select * from globalData where Amount>',input$minr,'and Amount <',input$maxr,'and year=',input$year_heat))
	p <- ggplot(final_qw, aes(x = origin_country, y = destination_country))
	p <-p + geom_tile(aes(fill=Amount))+ scale_fill_gradient(low = "black",high = "red")
	p <- p+labs(list(title="Global Remittance Heat Map",x="Origin Country",y='Destination Country'))+theme_bw()+
	theme(legend.position = "right", 
    axis.ticks = element_blank(), 
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1, colour = "black"),
    axis.text.y = element_text(size = 10, hjust = 1, colour = "black"),
    plot.title=element_text(size = 20, colour = "blue"),
    axis.title = element_text(size=15))
	#theme(axis.text.x = element_text(size = 10,hjust = 1, angle = 45, colour = "black"),plot.title=element_text(size = 20, colour = "blue"))
	p<-p+coord_flip()
	#p<-p+coord_polar()+theme_bw()+theme(plot.title=element_text(size = 20, colour = "blue"),axis.text.y = element_blank(),axis.ticks=element_blank(),panel.border=element_blank(),axis.title=element_blank())+labs(title="Global Remittance Circular Heatmap")
    print(p)
    },height=600)
	
  output$networkPlot <- renderPrint({
		#sql<-paste('Select origin_country as source,destination_country as target from globalData where origin_country="',input$country,'" and Amount>0 and year=',input$year_nw,sep="")
		if (input$origin_destination == "Outflow") {
        df<-sqldf(paste('Select origin_country as source,destination_country as target from globalData where origin_country="',input$country,'" and Amount>0 and year=',input$year_nw,' limit ',input$slider2,sep=""))
			}
		else if (input$origin_destination == "Inflow") {
        df<-sqldf(paste('Select destination_country as source,origin_country as target from globalData where destination_country="',input$country,'" and Amount>0 and year=',input$year_nw,' limit ',input$slider2,sep=""))
			}
		d3SimpleNetwork(df, 
		width = 600, height = 500,standAlone = FALSE,charge=-1000,fontsize = 16, linkDistance = input$slider1, opacity = input$slider,
            linkColour = "#666", nodeColour = "#3182bd",nodeClickColour = "#E34A33", textColour = "#3182bd", parentElement = "#networkPlot")
        
			})
  output$table <- renderTable(
        {
            df<-sqldf('Select origin_country as Country_name from globalData where Amount>0 group by 1')
			return(df)
        },
        include.rownames = FALSE
    )
  output$table1 <- renderTable(
        {
            if (input$origin_destination == "Outflow") {
        df<-sqldf(paste('Select origin_country as Origin,destination_country as Destination,Amount as Amount_million_dollars from globalData where origin_country="',input$country,'" and Amount>0 and year=',input$year_nw,' limit ',input$slider2,sep=""))
			}
		else if (input$origin_destination == "Inflow") {
        df<-sqldf(paste('Select destination_country as Destination,origin_country as Origin,Amount as Amount_million_dollars from globalData where destination_country="',input$country,'" and Amount>0 and year=',input$year_nw,' limit ',input$slider2,sep=""))
			}
			return(df)
        }
        
    )
  output$sankey <- renderPrint({
		
		if (input$origin_destination == "Outflow") {
        df<-sqldf(paste('Select origin_country as source,destination_country as target, Amount as value from globalData where origin_country="',input$country,'" and Amount>0 and year=',input$year_nw,' limit ',input$slider2,sep=""))
			}
		else if (input$origin_destination == "Inflow") {
        df<-sqldf(paste('Select destination_country as target,origin_country as source, Amount as value from globalData where destination_country="',input$country,'" and Amount>0 and year=',input$year_nw,' limit ',input$slider2,sep=""))
			}
		
		tempdf<-data.frame("source"=as.factor(df$source),"target"=as.factor(df$target),"value"=df$value)
		newdf<-data.frame("source"=unclass(as.factor(tempdf$source)),"target"=unclass(as.factor(df$target)),"value"=df$value)
		if (input$origin_destination == "Outflow") {
		newdf$source<-0
		a<-sqldf('Select source as name from tempdf group by 1')
		b<-sqldf('Select target as name from tempdf group by 1')
		c<-rbind(a,b)
		}
		else if (input$origin_destination == "Inflow") {
		newdf$target<-0
		a<-sqldf('Select source as name from tempdf group by 1')
		b<-sqldf('Select target as name from tempdf group by 1')
		c<-rbind(b,a)
		}
		
		

		d3Sankey(Links = newdf, Nodes = c, Source = "source",
         Target = "target", Value = "value", NodeID = "name",
         fontsize = 15, nodeWidth = 10, width = 600,height=600,standAlone = FALSE,parentElement = "#sankey")

			})

  
})
