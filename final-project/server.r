library(d3Network)
library(leafletR)
library(ggplot2)
library(shiny)
library(GGally)
library(sqldf)
library(scales)
library(maps)
library(ggmap)
library(reshape)

#source('leaflet.r')
loadData <-function(){
# Read Data
BRM2010 <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2010_csv.csv")
BRM2011 <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2011_csv.csv")
BRM2012 <- read.csv("C:/Users/Sunny/Desktop/Spring mod2/Data Visualizations/Project Data/Modified/Bilateral_Remittance_Matrix_2012_csv.csv")
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
    return(bp)
}


# Bubble Chart Code:
get_Bubble<-function(df, size_var, col_var){
#  browser()
    #Create plot
    #View(df)
    p<-ggplot(df,aes(x=Population, y = Income))+geom_point(aes_string(color=col_var, size = size_var),alpha=1, position="jitter")+geom_text(aes(label = Abbrev))+scale_size_continuous(range = c(8,35))+ labs(title="Bubble Chart")+theme_bw()+theme(axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12)) +theme(plot.title = element_text(size=24),axis.title.x = element_text(size=20),axis.title.y = element_text(size=20))
   
     return(p)
}

#Scatter Plot Matrix Code:
get_ScatterPlot <- function(df, colorby){
# Load required packages
require(GGally)
# Create scatterplot matrix
p <- ggpairs(df, columns = 1:4,upper = "blank",lower = list(continuous = "points"),diag = list(continuous = "density"),axisLabels = "none",
    colour = colorby,
    title = "Scatter Plot Matrix"
)

# Remove grid from plots along diagonal
for (i in 1:4) {
    # Get plot out of matrix
    inner = getPlot(p, i, i);
    
    # Add any ggplot2 settings you want
    inner = inner + theme_bw();

    # Put it back into the matrix
    p <- putPlot(p, inner, i, i);
}

# Show the plot
print(p)


 }


#Parallel Coordinates Plot Code:
generateParallel <- function(df,varlst,inp_alpha,para_color) {
  p <- ggparcoord(data = df,columns = varlst,groupColumn = para_color,order = "anyClass",showPoints = FALSE,shadeBox = NULL,scale = "uniminmax", alphaLines = inp_alpha ) + scale_x_discrete(expand = c(0.02, 0.02))+ scale_y_continuous(expand = c(0.02, 0.02))+ theme_bw()
  
  return(p)
}
#Shiny Server Code:
shinyServer(function(input, output,session) {
  localFrame<-globalData
  filteredData<-reactive({
    # Handling Multiple values from checkboxes
    if(length(input$Region)==0){regionlst<-c("Northeast", "South","North Central","West")}
    else{regionlst<-input$Region}
    subset(localFrame,Region %in% regionlst)
    })
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
	map.world <- map_data(map = "world")
	p1 <- ggplot(map.world, aes(x = long, y = lat, group = group, fill = region))
	#p1 <- ggplot(map.world, aes(x = long, y = lat, group = group))
	p1 <- p1 + geom_polygon() # fill areas
	p1 <- p1 + labs(title = "World Map : Remittances Flow") + theme_bw()+theme(legend.position="none")
	
	print(p1)
    },width=1200,height=800)
   
  output$heat<- renderPlot({
	#qw <- melt(loadData())
	#df <- subset( loadData(), select = -country_sard )
	#View(df)
	#final_qw<-subset(qw, country_sard="Russia" & as.numeric(as.character(value))>0,select=country_sard:value)
	final_qw <- sqldf(paste('Select * from globalData where Amount>','1000','and Amount <','5000'))
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
		
		View(c)

		d3Sankey(Links = newdf, Nodes = c, Source = "source",
         Target = "target", Value = "value", NodeID = "name",
         fontsize = 15, nodeWidth = 10, width = 600,height=600,standAlone = FALSE,parentElement = "#sankey")

			})

  
})
