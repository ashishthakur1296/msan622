shinyUI(navbarPage("Data Visualization HW 3",
                   #Bubble Chart Layout
           tabPanel("Bubble Chart",
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
              tabPanel("Scatter Plot Matrix",
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
              tabPanel("Parallel Coordinate Plot",
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
