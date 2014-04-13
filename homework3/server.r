library(RColorBrewer)
library(ggplot2)
library(shiny)
library(GGally)

loadData <-function(){
 df <- data.frame(state.x77,State = state.name,Abbrev = state.abb,Region = state.region,Division = state.division)
 df$Region<- as.factor(df$Region)
 df$Abbrev <-as.factor(df$Abbrev)
 df$Division <- as.factor(df$Division)
 return(df)
}
# common data
globalData <- loadData()

# Bubble Chart Code:
get_Bubble<-function(df, size_var, col_var){
#  browser()
    #Create plot
    View(df)
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
  output$bubble_chart<-
    renderPlot({
    p<-get_Bubble(df=filteredData(),
                  size_var=input$bubble_size, 
                  col_var=input$bubble_color
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
