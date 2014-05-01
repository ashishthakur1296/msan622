library(RColorBrewer)
library(ggplot2)
library(shiny)
library(GGally)
library(sqldf)
library(scales)

loadData <-function(){
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
# Remove last row
BRM2010 <- BRM2010[-nrow(BRM2010),]
#BRM <- rbind(BRM2010,BRM2011,BRM2012)
#return(list(BRM2010,BRM2011,BRM2012))
return(BRM2010)
}
# common data
globalData <- loadData()
View(globalData)
# Bar Plot generation
get_Bar<-function(df, countryCount,year){

    #View(df)
	bar_data<-sqldf(paste("Select country_sard,Total_num from df group by 1 order by Total_num desc limit",countryCount) )
	# Need to make it in decreasing order
	bar_data$country_sard <- factor(bar_data$country_sard,levels = bar_data$country_sard,ordered = TRUE)
	bar_data$country_sard <- factor(bar_data$country_sard,levels(bar_data$country_sard)[nrow(bar_data):1])
	bp<-ggplot(bar_data,aes(country_sard,Total_num))
	bp<-bp+geom_bar(stat='identity',fill="blue", colour="darkgreen",alpha=.6)+theme_bw()+labs(title = " Bar Chart - Remmitance Outflow",x = "Sending Country", y = "Amount Transferred (in million Dollars)")+scale_y_continuous(expand=c(0,0),labels=comma)+coord_flip()+
	theme(
    axis.ticks.y = element_blank(), 
    axis.text.x = element_text(size = 15, colour = "black"),
    axis.text.y = element_text(size = 15, hjust = 1, colour = "black"),
    plot.title=element_text(size = 30, colour = "blue"),
    axis.title = element_text(size=25))
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
  output$bar_plot<-
    renderPlot({
    p<-get_Bar(df=loadData(),
                  countryCount=input$countryCount, 
                  year=input$year_barp
                  )
    print(p)
    },width=1200,height=800)
  
  output$smplot<-renderPlot({
    g<-get_ScatterPlot(df = filteredData(),                       
                       input$inp_color
                       )
    print(g)
  }
  )
  
   
  output$paraplot<- renderPlot({
  if(length(input$add_variables)==0){varlst<-c("Population",
                                                             "Income",
                                                             "Illiteracy",
                                                             "Life.Exp",
                                                             "Murder",
                                                             "HS.Grad",
                                                             "Frost",
                                                             "Area")}
    else{varlst<-input$add_variables}
    q<-generateParallel(df=filteredData(),varlst,input$linealpha,input$para_color)
    print(q)
    },height=600)
  
})
