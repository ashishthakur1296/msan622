shinyUI(navbarPage("Global Remittances Visualization",
                   # Tab 1 : Bar Plot Layout
					tabPanel("Bar Plot",
								fluidRow(
										#column(6,tabPanel("Bar Plot",plotOutput("bar_plot1",height='100%',width='100%') )),
										#column(6,tabPanel("Bar Plot",plotOutput("bar_plot2",height='100%',width='100%') ))
										column(6,plotOutput("bar_plot1",height='100%',width='100%') ),
										column(6,plotOutput("bar_plot2",height='100%',width='100%') )
										),
										#br(),
										#br(),
								fluidRow(
										column(4,sliderInput("countryCount", "Number of countries to display",min = 1, max = 100, value = 10,step=1),offset=1),								
										column(4,radioButtons("year_barp","Select year",c("2010","2011","2012"), selected = "2010"),offset=2)									
										#column(4,radioButtons("order_by", "Show Remittance by:", c("Outflow","Inflow"), selected = "outflow"),)
										)
							), 
					# Tab 2 : Heat Map Layout
					tabPanel("Heat Map"	,plotOutput("heat",height='100%',width='100%') 
                           
							), 
				
                                      
             #World Map
              tabPanel("World Map",plotOutput("world_map",height='100%',width='100%')
						),
				
			 tabPanel("World Map New",tags$iframe(src="Fiji_Earthquakes.html",style="width: 90%; height:600px ")
						),
			 tabPanel("D3 test",tags$iframe(src="india.html",style="width: 90%; height:800px ")
						),
			 
			 tabPanel("Network Graph",
					fluidPage(
								# Load D3.js
								tags$head(tags$script(src = 'http://d3js.org/d3.v3.min.js')),
								
								# Sidebar with a slider input for node opacity
								sidebarLayout(
									sidebarPanel(
										helpText(strong('Copy paste the exact country name from "Reference: Country Names" tab into text box')),
										textInput("country", "Country Name:", "Australia"),
										sliderInput('slider', label = strong('Choose node opacity'),
											min = 0, max = 1, step = 0.01, value = 0.9
										),
										sliderInput('slider1', label = strong('Choose link distance'),
											min = 50, max = 400, step = 10, value = 200
										),
										sliderInput('slider2', label = strong('Choose number of countries to display'),
											min = 2, max = 100, step = 1, value = 10
										),										
										radioButtons("origin_destination",strong("Select Outflow vs Inflow"),c("Outflow","Inflow"), selected = "Outflow"),
										radioButtons("year_nw",strong("Select year"),c("2010","2011","2012"), selected = "2010")
								),

								# Show network graph
								mainPanel(
									tabsetPanel(
												tabPanel("Network Plot", htmlOutput('networkPlot')),
												tabPanel("Details for chosen country", tableOutput("table1")),
												tabPanel("Sankey Diagram", htmlOutput('sankey')),
												tabPanel("Reference: Country Names", tableOutput("table"))
								)				)
							  )
							)	
			 
					)

) 
) 
