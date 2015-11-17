shinyUI(navbarPage("Getting Around Town",
                   tabPanel("NYC Transportunities!",
                            fluidPage(theme = shinytheme("cosmo"),
                                      mainPanel(
                                        h1("NYC Transportunities"),
                                        br(),
                                        h3("Getting around New York can be the ultimate frustrating experience..."),
                                        br(),
                                        h3("Surprise! The", strong(span("6", style="color:green")), 
                                           strong("isn't running"), 
                                          "so the", strong(span("4", style="color:green")), 
                                          "is stopping", em("every 30 feet from here to Brooklyn.")),
                                        h3("Congratulations! Someone just", strong("stole your cab"), 
                                          "because", em("that's the kind of day you're having.")),
                                        h3("I guess you could", strong("walk"), ", but", 
                                           em("ain't nobody got time for that.")),
                                        br(),
                                        h2("Thankfully, there are new, cool ways to get around town!"),
                                        br(),
                                        img(src = "uber.jpg"),
                                        img(src = "citi.jpg"),
                                        width = 16
                                        
                                      )
                                      )),
                   
                   tabPanel("Problem",
                            fluidPage(theme=shinytheme("cosmo"),
                                      mainPanel(
                                        selectInput("rideprob",
                                                    label = h3("You're so hip. You must get around town some super cool way."),
                                                    choices = list(" ","Uber","Citibike")),
                                        conditionalPanel(condition = "input.rideprob == 'Uber'",
                                                         h3("Uh oh! A completely avoidable problem has ruined your afternoon!")),
                                        conditionalPanel(condition = "input.rideprob == 'Citibike'",
                                                         h3("Uh oh! A completely avoidable problem has ruined your afternoon!")),
                                        imageOutput("badpic"),
                                        br(),
                                        br(),
                                        conditionalPanel(condition = 
                                                           "input.rideprob == 'Uber'",
                                                         h3("Let's work toward solving this problem using data from",
                                                            tags$a(href="https://github.com/fivethirtyeight/uber-tlc-foil-response",
                                                                   "Uber"))),
                                        conditionalPanel(condition = "input.rideprob == 'Citibike'",
                                                         h3("Let's work toward solving this problem using data from",
                                                            tags$a(href="https://www.citibikenyc.com/system-data", 
                                                                   "Citibike"))),
                                        width = 16
                                      ))),
                   
                   tabPanel("Plots",
                            fluidPage(theme = shinytheme("cosmo"),
                                      
                                      sidebarLayout(
                                        sidebarPanel(
                                          h2("Options!"),
                                          
                                          selectInput("plot",
                                                      label = h3("Pick your plot"),
                                                      choices = list("Scatterplot of daily usage",
                                                                     "Barchart of usage by weather/day",
                                                                     "Barchart of monthly usage"),
                                                      selected = "Scatterplot of daily usage"),
                                          
                                          conditionalPanel(
                                            condition = "input.plot == 'Scatterplot of daily usage'",
                                            radioButtons("transportation2",
                                                         label = h3("Pick your ride"),
                                                         choices = list("Uber",
                                                                        "Citibike"),
                                                         selected = "Uber"),
                                            radioButtons("sort1",
                                                         label = h3("Color"),
                                                         choices = list("Weekends","Drizzly Days","Stormy Days","Hot Days"),
                                                         selected = "Weekends")),
                                          
                                          radioButtons("colors",
                                                       label = h3("Color Palettes!"),
                                                       choices = list("Neons!", "Bolds!", "Pastels!", "Color Blind!"),
                                                       selected = "Color Blind!")
                                          
                                        ),
                                        mainPanel(
                                          
                                          plotOutput("plot")
                                          
                                          
                                        )
                                      )
                            )
                   ),
                   
                   tabPanel("Heat Map",
                            fluidPage(theme = shinytheme("cosmo"),
                                      
                                      sidebarLayout(
                                        sidebarPanel(
                                          h2("Options!"),
                                          
                                          radioButtons("transportation",
                                                       label = h3("Pick your ride"),
                                                       choices = list("Uber",
                                                                      "Citibike"),
                                                       selected = "Uber"),
                                          
                                          selectInput("month",
                                                      label = h3("Pick a month"),
                                                      choices = list("April","May","June","July","August","September"),
                                                      selected = "April"),
                                          
                                          sliderInput("time",
                                                      label = h3("Time of Day"),
                                                      min = 0,
                                                      max = 24,
                                                      value = c(0,24)),
                                                      
                                          radioButtons("weekend",
                                                       label = h3("Day of the Week"),
                                                       choices = list("Weekdays","Weekends","Any Day"),
                                                       selected = "Any Day"),
                                          
                                          radioButtons("rain",
                                                       label = h3("Rain"), 
                                                       choices = list("Rain","Heavy Rain", "No Rain"),
                                                       selected = "No Rain"),
                                          
                                          radioButtons("temp",
                                                       label = h3("Temperature"),
                                                       choices = list("Hot", "Any"),
                                                       selected = "Any"),
                                         
                                          actionButton("goButton","Map me!")
                                        ),
                                        
                                        mainPanel(
                                          h1("Pickups", align="center"),
                                          plotOutput("mapa", width="700px", height="700px"),
                                          h5("* Random sample of 50,000 pickups")
                                        )
                                        
                                      )
                            )
                   ),
                   
                   
                   
                   tabPanel("Conclusions",
                            mainPanel(
                              h1(strong("Conclusions"), align = "center"),
                              br(),
                              h2("Uber"),
                              tags$li(h3("Encourage drivers when and where to work by publishing aggregate data")),
                              tags$li(h3("Ping drivers before distruptive weather")),
                              tags$li(h3("Predict growth")),
                              br(),
                              br(),
                              h2("Citibike"),
                              tags$li(h3("Incorporate weather data into redistribution effort")),
                              tags$li(h3("Determine where new banks would be most effective to minimize empty bank problem")),
                              br(),
                              h1(strong("Next steps"), align = "center"),
                              br(),
                              tags$li(h3("Incorporate Uber wait time and Citibike empty banks")),
                              tags$li(h3("Tackle the migration problem")),
                              width = 16
                              
                            ))
                   
                   
))
              