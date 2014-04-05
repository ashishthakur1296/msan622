library(ggplot2)
library(shiny)
library(sqldf)
library(RColorBrewer)
library(scales)
# Objects defined outside of shinyServer() are visible to
# all sessions. Objects defined instead of shinyServer()
# are created per session. Place large shared data outside
# and modify (filter/sort) local copies inside shinyServer().

# See plot.r for more comments.

# Note: Formatting is such that code can easily be shown
# on the projector.

# Loads global data to be shared by all sessions. Using same code as assignment 1.
loadData <- function() {
    data(movies)
    mvs_gt0<-sqldf('select * from movies where budget>0')
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
    return(mvs_gt0)
    }



# Create plotting function.
getPlot <- function(localFrame,dotsize,dotalpha, colorScheme = "None") {


    # Create base plot.
    localPlot <- ggplot(localFrame, aes(x = budget, y = rating, col = mpaa)) +
        geom_point(size=dotsize,alpha=dotalpha, position='jitter') +
        scale_x_continuous('Budget',labels = dollar,expand=c(0,0)) +
        scale_y_continuous('Rating',expand=c(0,0)) +
        labs(title="Scatter Plot : Budget vs Rating") +
        theme_bw() +
        #theme(legend.position = "none") +
        theme(axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12)) +
        theme(plot.title = element_text(size=24),axis.title.x = element_text(size=20),axis.title.y = element_text(size=20)) 
        
    
    if (colorScheme == "Accent") {
        localPlot <- localPlot +
            scale_color_brewer(type = "qual", palette='Accent')
    }
    else if (colorScheme == "Set1") {
        localPlot <- localPlot +
            scale_color_brewer(type = "qual", palette = 'Set1')
    }
     else if (colorScheme == "Set2") {
        localPlot <- localPlot +
            scale_color_brewer(type = "qual", palette = 'Set2')
    }
     else if (colorScheme == "Set3") {
        localPlot <- localPlot +
            scale_color_brewer(type = "qual", palette = 'Set3')
    }
     else if (colorScheme == "Dark2") {
        localPlot <- localPlot +
            scale_color_brewer(type = "qual", palette = 'Dark2')
    }
     else if (colorScheme == "Pastel1") {
        localPlot <- localPlot +
            scale_color_brewer(type = "qual", palette = 'Pastel1')
    }
     else if (colorScheme == "Pastel2") {
        localPlot <- localPlot +
            scale_color_brewer(type = "qual", palette = 'Pastel2')
    }


    return(localPlot)
}

##### GLOBAL OBJECTS #####

# Shared data
globalData <- loadData()
View(globalData)

##### SHINY SERVER #####

# Create shiny server. Input comes from the UI input
# controls, and the resulting output will be displayed on
# the page.
shinyServer(function(input, output) {

    cat("Press \"ESC\" to exit...\n")

    # Copy the data frame (don't want to change the data
    # frame for other viewers)
    localFrame <- globalData
    # Creating filtered dataset based on input Radio Buttons and checkboxes
    filteredData<-reactive({
    # Handling Multiple values from checkboxes
    if(length(input$genre)==0){gnrlst<-c("Action","Animation","Comedy","Documentary","Drama","Mixed","Romance","Short","None")}
    else{gnrlst<-input$genre}
    # Handling values from radio button
    if(input$mpaa_rating=="All"){subset(localFrame,genre %in% gnrlst)     
    }else{subset(localFrame,(mpaa == input$mpaa_rating)&(genre %in% gnrlst))}
    })
    
    
    
    
    # Output sorted table.
    # Should update every time sort order updates.
    output$table <- renderTable(
        {
            return(filteredData())
        },
        include.rownames = FALSE
    )

    # Output sorted bar plot.
    # Should update every time sort or color criteria changes.
    output$scatterPlot <- renderPlot(
        {
            # Use our function to generate the plot.
            scatterPlot <- getPlot(
                #output from the reactive component
                filteredData(),
                #sortOrder(),
                 input$dotsize, 
                 input$dotalpha,

                input$colorScheme
            )

            # Output the plot
            print(scatterPlot)
        }
    )
})

# Two ways to run this application. Locally, use:
# runApp()

# To run this remotely, use:
# runGitHub("lectures", "msan622", subdir = "ShinyDemo/demo1")
