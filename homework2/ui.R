library(shiny)
# Create a simple shiny page.
shinyUI(
    # We will create a page with a sidebar for input.
    pageWithSidebar(
        # Add title panel.
        headerPanel("Data Visualization HW - 2"),

        # Setup sidebar widgets.
        sidebarPanel(width=3,

            #Adding radio Buttons for MPAA
            radioButtons(
             "mpaa_rating",
             strong("MPAA Rating"),c("All","PG-13","PG","R", "NC-17"),selected = "All"),
            # Checkbox for genre
            checkboxGroupInput(
          "genre",
          strong("Genre"),c("Action","Animation","Comedy","Documentary","Drama","Mixed","Romance","Short","None"),
             selected=c("Action","Animation","Comedy","Documentary","Drama","Mixed","Romance","Short","None")
  ),

            # Add a little bit of space between widgets.
            br(),

            # Add drop down for selecting the color scheme.
            
            selectInput(
                "colorScheme",
                strong("Color Scheme:"),
                c("Default", "Accent", "Set1", "Set2","Set3","Dark2","Set2","Pastel1","Pastel2")
            ),
            
            # Slider Inputs
            sliderInput("dotsize", strong("Dot Size:"),min = 1, max = 10, value = 3, step=1),
            sliderInput("dotalpha", strong("Dot Alpha:"),min = 0.1, max = 1, value = .8,step=0.1),
            # Add a download link
            HTML("<p align=\"center\">[ <a href=\"https://github.com/ashishthakur1296/msan622/tree/master/homework2\">download source</a> ]</p>")
        ),

        # Setup main panel.
        mainPanel(
            # Create a tab panel.
            tabsetPanel(
                # Add a tab for displaying the Scatter Plot.
                tabPanel("Scatter Plot", plotOutput("scatterPlot")),

                # Add a tab for displaying the table .
                tabPanel("Table Details", tableOutput("table"))
            )
        )
    )
)