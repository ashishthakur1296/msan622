shinyUI(navbarPage("Global Remmitances Visualization",
                   # Tab 1 : Bar Plot Layout
					tabPanel("Bar Plot",
                            sidebarLayout(
								sidebarPanel(width=3,
									sliderInput("countryCount", "Number of countries to display",min = 1, max = 100, value = 10,step=1),
									br(),
									selectInput("year_barp","Select year from drop down",c("2010","2011","2012","ALL"), selected = "2010"),
										
									radioButtons("order_by", "Show Remmitance by:", c("outflow","inflow"), selected = "outflow")
										),	 
								mainPanel(
									tabPanel("Bar Plot",plotOutput("bar_plot",height='100%',width='100%') )
										  ) 
										)
							), 
					# Tab 2 : Heat Map Layout
					tabPanel("Heat Map",
                            sidebarLayout(
								sidebarPanel(width=3,
                                               selectInput("bubble_size","Select from the drop down to choose bubble size",c("Area","Illiteracy","Life.Exp"), selected = "Income"),
                                             
                                             checkboxGroupInput("Region", "Region Filter", 
                                                         c("North Central",
														   "Northeast",
                                                           "South",
                                                           "West")
                                                         , selected = c("North Central",
														   "Northeast",
                                                           "South",
                                                           "West")),
                                      radioButtons("bubble_color", "Color by:", c("Region","Division"), selected = "Region")
											), 
							mainPanel(
								tabPanel("Bubble Chart",plotOutput("bubble_chart",height='100%',width='100%') )
									 ) 
										)
							), 
           
              #Scatter  Plot Matrix Layout
              tabPanel("Bubble Plot",
                       sidebarLayout(
                         sidebarPanel(width=3,
                                      radioButtons("inp_color", "Color by:", c("Region",
                                                                                "Division"), selected = "Region")
                                      
                                     
                         ),
                         mainPanel(
                           tabPanel("Scatter Plot Matrix",plotOutput("smplot"))
                         )
                       )
              ),
                                      
             #Parallel Coordinate Plot Panel Layout
              tabPanel("World Map",
                       sidebarLayout(
                         sidebarPanel(width=3,
                                        checkboxGroupInput("add_variables", "Add variables", 
                                                           c("Population",
                                                             "Income",
                                                             "Illiteracy",
                                                             "Life.Exp",
                                                             "Murder",
                                                             "HS.Grad",
                                                             "Frost",
                                                             "Area")
                                                           , selected = c("Population","Income")),
										
                                        radioButtons("para_color", "Color by:", c("Region","Division"), selected = "Region"),
                            
                            sliderInput("linealpha", "Line Alpha:",min = 0.1, max = 1, value = .8,step=0.1)
                                      ),
                         mainPanel(plotOutput("paraplot",width="100%",height="100%"))
                                    )
						)                    
              
) 
) 
