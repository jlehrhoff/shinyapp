source("helpers.R")

shinyServer(function(input,output) {
  
  badpic <- reactive({switch(input$rideprob,
                             " " = "blank.png",
                             "Uber" = "uberpic.png",
                             "Citibike" = "citipic.jpg"  )})
  
  ridenum <- reactive({switch(input$transportation2,
                              "Uber" = uberridership,
                              "Citibike" = citiridership) })
  
  color <- reactive({switch(input$sort1,
                            "Weekends" = "weekend",
                            "Drizzly Days" = "drizzle",
                            "Stormy Days" = "downpour",
                            "Hot Days" = "hot") })
  
  palette <- reactive({switch(input$colors,
                              "Neons!" = c("green2","maroon1"),
                              "Bolds!" = c("goldenrod2", "midnightblue"),
                              "Pastels!" = c("lightblue", "lightgoldenrod1"),
                              "Color Blind!" = c("grey80", "grey25") )})
  
  ##### Due to performance issues, I'm mapping a random sample of 50000 pickups per month #####
  
  ride <- reactive({ switch(input$transportation,
                            "Uber" = ubersample,
                            "Citibike" = citisample)  })
  
  ridefilter2 <- reactive({
  # Month filter
  if (input$month == "April") {
    ridefilter <- ride() %>% filter(., mon == "4")
  }
  if (input$month == "May") {
    ridefilter <- ride() %>% filter(mon == "5")
  }
  if (input$month == "June") {
    ridefilter <- ride() %>% filter(mon == "6")
  }
  if (input$month == "July") {
    ridefilter <- ride() %>% filter(mon == "7")
  }
  if (input$month == "August") {
    ridefilter <- ride() %>% filter(mon == "8")
  }
  if (input$month == "September") {
    ridefilter <- ride() %>% filter(mon == "9")
  class(ridefilter)
    }
    
   # Time filter
     mintime <- input$time[1]
     maxtime <- input$time[2]
     ridefilter <- ridefilter %>% filter(., time >= mintime, time <= maxtime)
  
  # Weekend filter
  if (input$weekend == "Weekends") {
    ridefilter <- ridefilter %>% filter(., weekend == TRUE)
  }
  if (input$weekend == "Weekdays") {
    ridefilter <- ridefilter %>% filter(., weekend == FALSE)
  }
  
  # Rain filter
  if (input$rain == "Rain") {
    ridefilter <- ridefilter %>% filter(., PRCP > 0 )
  }
  if (input$rain == "Heavy Rain") {
    ridefilter <- ridefilter %>% filter(., PRCP > 100)
  }
  
  # Temp filter
  if (input$temp == "Hot") {
    ridefilter <- ridefilter %>% filter(., TMAX > 267)
  }
  
  ridefilter <- as.data.frame(ridefilter)
  })
      
  heatmap <-  eventReactive(input$goButton, {
#     withProgress(message = 'Heads up: This might take a while...',
#                  {
#       for (i in 1:50) {
#         incProgress(1/50)
#         Sys.sleep(0.25)
#       }})
    mapfunc(ridefilter2())
    
  })
  
  output$mapa <- renderPlot({
    heatmap()
  })
  
  plot <- reactive({pal <- palette()
  switch(input$plot,
         "Scatterplot of daily usage" = 
           ggplot(data=ridenum(), aes(x=DATE, y=count)) + 
           geom_point(size=5) +
           geom_point(aes_string(color=color()), size = 4) +
           scale_color_manual(values = pal) +
           theme_bw() + xlab("Date") + ylab("Rides") + ggtitle(paste(input$transportation2, "Ridership")) +
           theme(axis.title = element_text(size = 24), axis.text = element_text(size=12), 
                 title = element_text(size=30), legend.title = element_blank()) + 
           scale_y_continuous(limits = c(0, 45000)),
         
         "Barchart of monthly usage" =
           ggplot(data=ridership1, aes(x=mon, y=`sum(count)`, fill=ride)) +
           geom_bar(stat="identity", position = "dodge") +
           scale_fill_manual(values = palette()) +
           theme_bw() + xlab("Month") + ylab("Rides") + ggtitle(paste("Average Ridership by Month")) +
           theme(axis.title = element_text(size = 24), axis.text = element_text(size=12), title = element_text(size=30),
                 legend.title = element_blank()) +
           scale_x_continuous(breaks=4:9, labels=c("April","May","June","July","August","September")),
         
         "Barchart of usage by weather/day" =
           ggplot(data=usage, aes(x=category, y=count, fill=ride)) +
           geom_bar(stat="identity", position = "dodge") +
           scale_fill_manual(values = palette()) +
           theme_bw() + xlab("Type of Day") + ylab("Rides") + ggtitle(paste("Average Ridership by Type of Day")) +
           theme(axis.title = element_text(size = 24), axis.text = element_text(size=12), title = element_text(size=30),
                 legend.title = element_blank()) 
         
  )
  })
  
  output$plot <- renderPlot({
    plot()
  })
  
  output$badpic <- renderImage({
    filename <- normalizePath(file.path('./www', badpic()))
    list(src = filename,
         alt = badpic())
  }, deleteFile = FALSE)
  
}) 